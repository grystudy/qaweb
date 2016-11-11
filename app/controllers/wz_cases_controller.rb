require 'FileHelper'
require 'query_helper'
require 'json'
class WzCasesController < ApplicationController
  def index
    per_page = 28
    items = nil
    t = params[:type]
    if t
      items = WzCase.where(status: t.to_i)
    else
      items = WzCase.all
    end
    @wz_cases = items.order(id: :asc).page(params[:page]).per_page(per_page)
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
    @item = WzCase.find(params[:id])
  end

  def edit
  end

  def update
    set_confirm WzCase.find(params[:id])
    redirect_to wz_cases_path, notice: "ok!"
  end

  def destroy
    @item = WzCase.find(params[:id])
    @item.destroy
    redirect_to wz_cases_path, notice: "删除成功!"
  end

  def begin
    same =0
    contain = 1
    diff = 2
    res_hash = QueryHelper.loop WzCase.all
    WzCase.all.each do |wzcase|
      res_ = res_hash.fetch(wzcase.id, nil)
      unless res_
        wzcase.status = diff
        wzcase.wz_query = nil
        wzcase.save
        next
      end
      base = wzcase.get_wz_items
      if base == res_
        wzcase.status = same
        wzcase.save
        next
      end
      wzcase.create_wz_query(info: res_.to_json)
      unless base.index { |e_| !res_.index { |sub_e| sub_e == e_ } }
        wzcase.status = contain
        wzcase.save
        next
      end
      wzcase.status = diff
      wzcase.save
    end
    redirect_to wz_cases_path, notice: "ok!"
  end

  def confirm
    WzCase.all.each do |cas|
      set_confirm cas
    end
    redirect_to wz_cases_path, notice: "ok!"
  end

  def set_confirm cas
    return unless cas
    return if cas.status == 0
    cas.status = 0
    cas.save
    if cas.wz_query.nil?
      cas.wz_item = nil
      cas.save
      return
    end
    cas.create_wz_item(info: cas.wz_query.info)
  end
end
