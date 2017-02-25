Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/account/sign', to: 'sign#sign'
  post '/account/sms-ver-code', to: 'sms_ver_code#push'
end
