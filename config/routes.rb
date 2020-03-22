Rails.application.routes.draw do
  scope '/api' do
    post '/webhooks', to: 'webhooks#create'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
