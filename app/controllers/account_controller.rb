class AccountController < ApplicationController
  def sign
    logger.info params
    render :json => '{foo: "bar"}'
  end
end
