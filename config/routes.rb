Rapidfire::Engine.routes.draw do
  resources :question_groups do
    get 'results', on: :member
    post "update_positions", on: :member
    get 'duplicate', on: :member
    get :final, :on => :member
    resources :questions
    resources :fieldsets
    resources :answer_groups, only: [:new, :show, :create, :edit, :update]
  end
  root :to => "question_groups#index"
end
