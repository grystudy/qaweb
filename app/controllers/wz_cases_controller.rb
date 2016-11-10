require 'FileHelper'
require 'query_helper'
require 'json'
class WzCasesController < ApplicationController
  @@res_hash = {}
  @@same = []
  @@contain = []
  @@diff = []

  def index
    @res_hash = @@res_hash
    per_page = 10
    items = []
    case params[:type]
      when "0"
        items = @@same
      when "1"
        items = @@contain
      when "2"
        items = @@diff
      else
        items = WzCase.all.page(params[:page]).per_page(per_page)
    end
    @wz_cases = items
  end

  def create
    file_input = params[:fileMain]
    if file_input
      lst_vehicle = ::FileHelper.try_save_and_parse_data(file_input, "vehicle", request.remote_ip(), 4)
      if lst_vehicle
        lst_vehicle.each do |v_|
          new_v = Vehicle.create({cityname: v_[0], plate: v_[1], frame: v_[3], engine: v_[2]})
          new_c = WzCase.create
          new_c.vehicle = new_v
          new_c.save
        end
        redirect_to wz_cases_path, notice: "上传成功!"
        return
      end
    end
    redirect_to wz_cases_path, notice: "上传失败!"
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
    @item = WzCase.find(params[:id])
    @item.destroy
    redirect_to wz_cases_path, notice: "删除成功!"
  end

  def begin
    res_hash = QueryHelper.loop WzCase.all
    @@res_hash = res_hash
    WzCase.all.each do |wzcase|
      res_ = res_hash.fetch(wzcase.id, nil)
      unless res_
        @@diff << wzcase
        next
      end
      base = wzcase.get_wz_items
      if base == res_
        @@same << wzcase
        next
      end

      unless base.index { |e_| !res_.index { |sub_e| sub_e == e_ } }
        @@contain << wzcase
        next
      end

      @@diff << wzcase
    end
    redirect_to wz_cases_path, notice: "ok!"
  end

  def confirm
    @@res_hash.each do |res|
      wz = WzCase.find(res[0])
      wz.create_wz_item(info: res[1].to_json)
      wz.save
    end
    redirect_to wz_cases_path, notice: "ok!"
  end
end
