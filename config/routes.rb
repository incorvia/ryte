Ryte::Application.routes.draw do
  devise_for :admins, :class_name => "Ryte::Admin", :controllers => { :sessions => "ryte/admin/sessions" }

  root to: 'ryte/public/posts#index'
end
