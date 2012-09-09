Ryte::Application.routes.draw do
  devise_for :admins, :class_name => "Ryte::Admin", :controllers => { :sessions => "admin/sessions" }

  root to: 'posts#index'
end
