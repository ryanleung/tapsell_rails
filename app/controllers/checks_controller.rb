class ChecksController < ApplicationController

  def create
    @user = current_user
    @check = @user.checks.build(check_params)
    @address = @check.addresses.build(address_params)
  end

  private

  def check_params
    params.permit(:first_name, :last_name)
  end

  def address_params
    params.permit(:street_address, :extended_address, :locality, :region, :postal_code)
  end

end
