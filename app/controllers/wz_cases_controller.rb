class WzCasesController < ApplicationController
  def index
    @wz_cases = WzCase.page(params[:page]).per_page(50)
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def begin

  end
end
