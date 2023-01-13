Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "emails#index"
  mount Sidekiq::Web => '/sidekiq'
  resources 'emails'
  
end
