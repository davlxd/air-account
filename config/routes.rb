Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/sign', to: 'sign#sign'
  post '/sms-ver-code', to: 'sms_ver_code#push'
end
