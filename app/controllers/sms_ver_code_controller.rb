class SmsVerCodeController < ApplicationController
  def push
    params.require(:phone)
    render status: 200
  end
end
