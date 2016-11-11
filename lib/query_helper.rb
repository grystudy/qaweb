class QueryHelper
  $s_lock = Mutex.new

  class << self
    def loop chepai_
      city_info = WeizhangInfo.new.get_city_info
      unless city_info
        puts 'no cityinfo response'
        return nil
      end
      city_info = city_info[:configs]

      res_hash = {}
      bus = []
      max_count = 16
      chepai_.each do |uuitem|
        chepai = uuitem.vehicle.plate
        next unless chepai.size > 3
        bus << {no: chepai, entity: uuitem}
        if bus.size == max_count
          QueryHelper.go(bus, city_info,res_hash)
          bus.clear
        end
      end
      QueryHelper.go(bus, city_info,res_hash) unless bus.size == 0
      bus.clear
      res_hash
    end

    def go array_hash, city_info, result_hash
      a_thread = []
      array_hash.each do |v|
        chepai = v[:no]
        uuitem = v[:entity]
        a_thread << Thread.new do
          pro = chepai[0]
          city = chepai[1]
          city_code = nil
          frame_num = nil
          engine_num = nil
          city_info.each do |pro_json|
            city_code, frame_num, engine_num = pro_json.weizhang_provience_match(pro, city)
            break if city_code
          end
          unless city_code
            Thread.exit
          end
          get_param_func = lambda do |src_, num_|
            return nil unless src_
            return "" if num_ == 0
            return src_ if num_ == -1
            return src_[0, num_]
          end
          begin
            response = WeizhangInfo.new(city_code, chepai, get_param_func.call(uuitem.vehicle.engine, engine_num), get_param_func.call(uuitem.vehicle.frame, frame_num)).get
          rescue Exception => ex_
            p "exception !!!!!!!!!!!!!!!!!!!!!!  #{ex_.message}"
            sleep(30)
            retry
            Thread.exit
          end
          rspcode = response.weizhang_response_code
          if rspcode
            p "#{chepai} #{rspcode}"
            $s_lock.synchronize do
              his_array = response.weizhang_histories
              case rspcode
                when 20000, 21000
                  result_hash[uuitem.id] = his_array if his_array && his_array.length > 0
                when 50101
                else
              end
            end
          end
        end
      end
      a_thread.each do |thread|
        thread.join
      end
    end
  end
end

class WeizhangInfo
  require 'digest/md5'
  include HTTParty
  base_uri 'http://www.loopon.cn'

  def initialize(city=nil, chepai=nil, fadongji=nil, chejia=nil)
    t = ","
    src = "{plate_num:#{chepai}#{t}body_num:#{chejia}#{t}engine_num:#{fadongji}#{t}city_id:#{city}#{t}car_type:02}"
    @car_info = src
  end

  def get
    @data_hash = nil
    car_info = @car_info
    return nil unless @car_info
    api_id = 18
    app_key = "08ecf6d0-89e4-0134-864d-0242c0a80007"
    timestamp = Time.now.getutc.to_i
    sign = Digest::MD5.hexdigest(api_id.to_s + car_info + timestamp.to_s + app_key)
    res = self.class.get("/traffic_violation/api/v1/query", {query: {car_info: car_info, api_id: api_id, sign: sign, timestamp: timestamp}})
    return nil if !res
    res = eval(res.to_s)
    return nil if !res
    @data_hash = res
  end

  def get_city_info
    res = self.class.get("/traffic_violation/api/v1/cities")
    return nil unless res
    ok = res.code.to_i == 200
    return nil unless ok
    eval(res.to_s)
  end

  private
  def is_valid?
    @data_hash
  end
end

class Array
  def weizhang_provience_get_short_name name_
    each do |hash|
      name = hash.fetch :province_name, String.new
      name.force_encoding 'UTF-8'
      return hash.fetch :province_short_name, nil if name == name_
    end
    nil
  end
end

class Hash
  def weizhang_provience_match(pro, city)
    name = fetch :province_short_name, String.new
    name.force_encoding 'UTF-8'
    return nil unless name == pro
    cities = fetch :citys, nil
    return nil unless cities
    cities.each do |city_v|
      return city_v.fetch(:city_id, nil), city_v.fetch(:body_num, nil), city_v.fetch(:engine_num, nil) if city_v.weizhang_city_match city
    end
    nil
  end

  def weizhang_city_match city
    name = fetch :car_head, nil
    return false unless name && name.size > 1
    name.force_encoding 'UTF-8'
    name[1] == city
  end

  def weizhang_city_code
    fetch :city_id, nil
  end

  def weizhang_response_code
    code = fetch :rspcode, nil
    code
  end

  def weizhang_histories
    fetch :historys, []
  end
end