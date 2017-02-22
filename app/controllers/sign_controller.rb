class SignController < ApplicationController
  def sign
    if params.has_key?(:phone)
      params.require(:sms_ver_code)
      # TODO: sms_ver_cde validation
      @user = User.find_by(phone: params[:phone])
      @user = User.new(phone: params[:phone], air_auth_token: SecureRandom.uuid) if @user.nil?

    elsif params.has_key?(:wechat_openid)
      @user = User.find_by(wechat_openid: params[:wechat_openid])
      @user = User.new(wechat_openid: params[:wechat_openid], air_auth_token: SecureRandom.uuid) if @user.nil?

    else
      logger.error 'Client sign with either phone or wechat'
      render json: { message: 'Sign with unsupported parameter' }, status: 400 and return
    end

    @user.save! if @user[:id].nil?

    render json: { air_auth_token: @user[:air_auth_token] }
  end
end
