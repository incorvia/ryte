Ryte::Application.routes.draw do
  devise_for :admins, :class_name => "Ryte::Admin", :controllers => { :sessions => "ryte/admin/sessions" }

  scope module: :ryte do
    namespace :admin do
      resources :posts
      match '/dashboard', to: 'cms#dashboard', as: "root"
    end

    scope module: :public do
      resources :posts
    end
  end

  root to: 'ryte/public/posts#index'
end
