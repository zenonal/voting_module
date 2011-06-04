authorization do
  role :admin do
    has_permission_on [:referendums, :comments, :arguments, :users, :politicians, :parties], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on :referendums, :to => [:aye,:nay]
    has_permission_on :user, :to => [:show]
    has_permission_on :arguments, :to => [:aye,:nay,:exclude_argument,:edit, :update,:destroy]
    has_permission_on :comments, :to => [:reply_to_comment, :create_reply,:exclude_comment,:edit, :update,:destroy]
    has_permission_on [:delegates, :delegations], :to => [:create, :update, :destroy, :index]
  end
  role :registered_user do
    has_permission_on [:comments,:arguments], :to => [:index, :show, :new, :create]
    has_permission_on :referendums, :to => [:index, :show, :aye,:nay]
    has_permission_on [:politicians,:parties], :to => [:index, :show]
    has_permission_on :user, :to => [:show]
    has_permission_on :arguments, :to => [:aye,:nay,:exclude_argument]
    has_permission_on :comments, :to => [:reply_to_comment, :create_reply,:exclude_comment]
    has_permission_on [:comments,:arguments], :to => [:edit, :update,:destroy] do
      if_attribute :user_id => is { user.id }
    end
    has_permission_on [:users], :to => [:edit, :update,:destroy] do
      if_attribute :id => is { user.id }
    end
    has_permission_on [:delegates], :to => [:index,:create] 
    has_permission_on [:delegates], :to => [:destroy] do
      if_attribute :user_id => is { user.id }
    end
    has_permission_on :delegations, :to => [:create, :update, :destroy]
  end
  role :guest do
    has_permission_on [:comments,:arguments, :politicians, :parties, :referendums], :to =>  [:index, :show]
    has_permission_on :user, :to => [:show]
  end
end