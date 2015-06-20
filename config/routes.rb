##
# routes.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

Rails.application.routes.draw do
    mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    get 'admin', to: 'admin#index'

    root 'map#index'

    devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }

    match 'user/:username', to: 'user#show', via: :get, as: :profile

    match 'users', to: 'user#index', constraints: { format: 'json' }, via: :get

    resources :resources, only: [:index, :show, :new, :edit, :update, :destroy], as: :media do
        member { post :vote }
        member { get :status, constraints: { format: 'json' } }
        resources :comments, only: [:create, :edit, :update, :destroy]
    end

    get 'tags/:tag', to: 'map#index', as: :tag

    resources :resource_steps, only: [:index, :show, :update, :create]

    post 'resource_steps/media', to: 'resource_steps#create'

    resources :messages, only: [:index, :new, :create, :destroy]
    match 'messages/:username', to: 'messages#index', via: :get, as: :usermessage

    resources :tags, only: [:index], constraints: { format: 'json' }

    get 'about', to: 'static#about'

    get 'imprint', to: 'static#imprint'

    %w(404 422 500).each do |error_code|
        get error_code, to: 'errors#show', code: error_code
    end

end
