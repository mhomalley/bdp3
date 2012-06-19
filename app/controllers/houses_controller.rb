class HousesController < ApplicationController

  session :off

  #No password for any method in this controller
  def secure?
    false
  end


  def index
  end

  def sales
  end

  def open
  end

  def zoning
  end

  def open_map
  end

  def sales_map
  end
end
