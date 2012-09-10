Ryte::Application.routes.draw do
  devise_for :admins, :class_name => "Ryte::Admin", :controllers => { :sessions => "ryte/admin/sessions" }

  match '/dashboard', to: 'ryte/admin/cms#dashboard', as: 'admin_root'

  root to: 'ryte/public/posts#index'
end
