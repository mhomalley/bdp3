Bdp3::Application.routes.draw do
  
  # The priority is based upon order of creation:
  # first created -> highest priority.
  root :to => 'public#cur_issue', :as => :empty
    
  match 'issue/:issue_id' => 'public#index', :as => :public_issue, :constraints => {:issue_id => /latest|(20\d\d-[01]?\d-\d\d)/}
  match 'issue/:issue_id/article/:storyID' => 'public#article', :as => :public_article, :constraints => {:issue_id => /latest|(20\d\d-[01]?\d-\d\d)/, :storyID => /\d+/}
  #match 'issue/:issue_id/article/:storyID' => 'public#article' #, :as => :public_article, :constraints => {:issue_id => /latest|(20\d\d-[01]?\d-\d\d)/, :storyID => /\d+/}
  #match 'article/:storyID' => 'public#article', :as => :public_article, :constraints => {:storyID => /\d+/}
  match 'issue/:issue_id/:action' => 'public#action', :constraints => {:issue_id => /(20\d\d-[01]?\d-\d\d)/} , :as => :public_action #, fixit?:constraints => {:issue_id => /latest|(20\d\d-[01]?\d-\d\d)/, :action => /\w+/}
  match 'issue/archives(/yr/:mo)' => 'public#archives', :as => :public_archives, :constraints => {:yr => /\d\d/, :mo => /[01]?\d/}
 
  #Admin routes
  match 'admin/issues/:id/kill_cache' => 'issues#kill_cache', :as => 'kill_cache'
  match 'admin/issues/:id/kill_issue_cache' => 'issues#kill_issue_cache', :as => 'kill_issue_cache'
  #match 'admin/articles/new' => 'articles#new'
 
  scope "/admin" do
    resources :users do
      collection do
        get 'login'
        get 'logout'
        post 'do_login'
      end
    end
    resources :issues do
      member do
        get 'publish'
        get 'upload'
        post 'do_upload'
      end
      resources :articles
      resources :images
    end
  end

  match 'admin' => 'articles#new'
  
  match 'subscribe' => 'public#subscribe', :as => 'subscribe'
  match 'fund' => 'public#fund', :as => 'fund'
 
  get 'supporters/thanks', :as => :thanks_supporters
  resources :supporters
  
  match 'sitemap_index' => 'feeds#sitemap_index', :as => :sitemap_index, :defaults => {:format => 'xml'}
  match 'sitemap_old' => 'feeds#sitemap_old', :as => :sitemap_old, :defaults => {:format => 'xml'}
  match 'sitemap_news' => 'feeds#sitemap_news', :as => :sitemap_news, :defaults => {:format => 'xml'}
  match 'sitemap' => 'feeds#sitemap', :as => :sitemap, :defaults => {:format => 'xml'}
  match 'feeds/:action' => 'feeds#:action', :as => :feeds_action

  # fixit match '*junk' => 'public#unknown'

  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'  
  
  # See how all your routes lay out with "rake routes"
end

