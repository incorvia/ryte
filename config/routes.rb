Ryte::Application.routes.draw do
  devise_for :admins

  root to: 'posts#index'
end
