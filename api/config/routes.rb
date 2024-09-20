Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_scope :users do
        post "sign_up", to: "registrations#create"
      end
    end
  end
end
