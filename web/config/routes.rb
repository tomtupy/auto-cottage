Rails.application.routes.draw do
  get 'cottage/index'
  root 'cottage#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'cottage/get_cottage_temps' => 'cottage#get_cottage_temps'
end
