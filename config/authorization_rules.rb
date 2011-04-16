authorization do
  role :admin do
    has_permission_on [:referendums, :comments, :arguments, :users], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on :referendums, :to => [:aye,:nay]
    has_permission_on :comments, :to => [:reply_to_comment, :create_reply]
  end
  role :registered_user do
    has_permission_on [:comments,:arguments], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on :referendums, :to => [:index, :show, :aye,:nay]
    has_permission_on [:comments,:arguments], :to => [:edit, :update,:destroy] do
      if_attribute :user => is { user }
    end
    has_permission_on :users, :to => [:index, :show, :new, :create]
    has_permission_on :users, :to => [:edit, :update, :destroy] do
      if_attribute :user => is { user }
    end
    
  end
  role :guest do
    has_permission_on [:comments,:arguments], :to =>  [:index, :show]
    has_permission_on :referendums, :to => [:index, :show, :aye,:nay]
    has_permission_on [:comments,:arguments], :to => [:edit, :update,:destroy] do
      if_attribute :user => is { user }
    end
    has_permission_on :users, :to => [:index, :show, :new, :create]
  end
end