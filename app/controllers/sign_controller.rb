class SignController < ApplicationController
  def sign
    if params.has_key?(:phone)
      params.require(:sms_ver_code)

      ver_code_sms = SmsMessage.where(phone: params[:phone], ver_code: params[:sms_ver_code]).order(created_at: :desc).first
      render json: { message: 'Verification code is invalid' }, status: 400 and return if ver_code_sms.nil?
      render json: { message: 'Verification code expired' }, status: 400 and return if (Time.now - ver_code_sms[:created_at]) > 60 * 5

      @user = User.find_by(phone: params[:phone])
      @user = User.new(phone: params[:phone], air_auth_token: SecureRandom.uuid) if @user.nil?

    elsif params.has_key?(:wechat_openid)
      params.require(:wechat_access_token)

      url = URI.parse("https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{params[:wechat_access_token]}&openid=#{params[:wechat_openid]}&lang=en_US")
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port, use_ssl: true) {|http|
        http.request(req)
      }
      res_json = JSON.parse(res.body)

      render json: res_json, status: 400 and return if res_json.has_key? 'errcode'

      @user = User.find_by(wechat_openid: params[:wechat_openid])
      @user = User.new(wechat_openid: params[:wechat_openid], air_auth_token: SecureRandom.uuid, wechat_userinfo: res_json) if @user.nil?

    else
      logger.error 'Client sign with either phone or wechat'
      render json: { message: 'Sign with unsupported parameter' }, status: 400 and return
    end

    @user.save! if @user[:id].nil?
    render json: { air_auth_token: @user[:air_auth_token] }
  end
end
