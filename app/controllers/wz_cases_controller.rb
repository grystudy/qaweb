require 'FileHelper'
require 'query_helper'
class WzCasesController < ApplicationController
  @@res_hash = {}
  def index
    @res_hash = @@res_hash
    @wz_cases = WzCase.page(params[:page]).per_page(50)
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
    @@res_hash = QueryHelper.loop WzCase.all
    redirect_to wz_cases_path, notice: "ok!"
  end
end
