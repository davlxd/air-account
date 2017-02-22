class SmsVerCodeController < ApplicationController
  def push
    params.require(:phone)

    ver_code = rand(10000).to_s.rjust(4, '0')
    @sms_message = SmsMessage.new(phone: params[:phone], ver_code: ver_code, body: ver_code_sms_body(ver_code))

    @sms_message.save
    # Push to SMS service

    render status: 200
  end

  private
  def ver_code_sms_body (ver_code)
    "大哥大嫂过年好！您的验证码是【#{ver_code}】"
  end
end
