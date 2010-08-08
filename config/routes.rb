Posse::Application.routes.draw do
  match '/' => redirect('/projects')

  resources :builds, :only => [:show]

  resources :commits, :only => []

  resources :branches, :only => [:show]

  resources :projects, :only => [:index, :new, :create, :show] do
    resources :clusters, :only => [:index, :new, :create]
  end

  resources :clusters, :only => [:show] do
    resources :deploys, :only => []
  end

  resources :deploys, :only => []
end
