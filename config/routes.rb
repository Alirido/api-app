Rails.application.routes.draw do
    root to: redirect('/swagger/dist/index.html?url=/apidocs')
    resources :apidocs, only: [:index]
    scope :admin do
        root to: 'admin#index'
        resources :users, controller: 'admin/users' do
            get 'delete', on: :member # http://guides.rubyonrails.org/routing.html#adding-more-restful-actions
            put 'update', on: :collection
        end
    end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
