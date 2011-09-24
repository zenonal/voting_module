authorization do
  role :guest do
    has_permission_on [:comments,:arguments, :politicians, :parties, :referendums, :initiatives, :amendments, :categories], :to =>  [:index, :show, :new, :show_results]
    has_permission_on [:brainstorm, :user], :to => [:show]
  end
  role :admin do
    has_permission_on [:initiatives, :referendums, :amendments, :comments, :arguments, :users, :politicians, :parties, :categories, :ideas], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on [:initiatives, :referendums, :amendments, :ideas], :to => [:aye,:nay, :vote, :ranking, :show_results]
    has_permission_on [:initiatives, :amendments], :to => [:validate, :index_drafts]
    has_permission_on :user, :to => [:show]
    has_permission_on :arguments, :to => [:aye,:nay,:exclude_argument,:edit, :update,:destroy]
    has_permission_on :comments, :to => [:reply_to_comment, :create_reply,:exclude_comment,:edit, :update,:destroy]
    has_permission_on [:delegates, :delegations], :to => [:create, :update, :destroy, :index]
    has_permission_on [:brainstorms], :to => [:create, :show]
    has_permission_on [:ideas], :to => [:select_ideas, :index_all]
  end
  role :limited_user do
        has_permission_on [:comments,:arguments,:ideas], :to => [:index, :show, :new, :create]
        has_permission_on :referendums, :to => [:index, :show, :aye,:nay, :vote, :ranking, :show_results]
        has_permission_on [:politicians,:parties,:categories], :to => [:index, :show]
        has_permission_on :user, :to => [:show]
        has_permission_on [:arguments, :ideas], :to => [:aye,:nay,:exclude_argument]
        has_permission_on :comments, :to => [:reply_to_comment, :create_reply,:exclude_comment]
        has_permission_on [:comments,:arguments, :ideas], :to => [:edit, :update,:destroy] do
          if_attribute :user_id => is { user.id }
        end
        has_permission_on [:initiatives, :amendments], :to => [:index, :index_drafts, :show, :aye,:nay, :vote, :ranking, :show_results]
        has_permission_on [:initiatives, :amendments], :to => [:validate] do
          if_attribute :user_id => is_not { user.id }
        end
        has_permission_on [:users, :ideas], :to => [:edit, :update,:destroy] do
          if_attribute :id => is { user.id }
        end
        has_permission_on [:delegates], :to => [:index,:create] 
        has_permission_on [:delegates], :to => [:destroy] do
          if_attribute :user_id => is { user.id }
        end
        has_permission_on :delegations, :to => [:create, :update, :destroy]
        has_permission_on [:brainstorms], :to => [:create, :show, :index]
        has_permission_on [:ideas], :to => [:select_ideas, :index_all]
  end
  role :registered_user do
    includes :limited_user
    has_permission_on [:initiatives, :amendments], :to => [:create,:new]
    has_permission_on [:initiatives, :amendments], :to => [:edit, :update,:destroy] do
      if_attribute :user_id => is { user.id }
    end
  end
  
end