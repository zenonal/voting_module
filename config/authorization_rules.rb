authorization do
  role :admin do
    has_permission_on [:referendums, :comments, :arguments, :users, :politicians], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on :referendums, :to => [:aye,:nay]
    has_permission_on :arguments, :to => [:aye,:nay,:exclude_argument,:edit, :update,:destroy]
    has_permission_on :comments, :to => [:reply_to_comment, :create_reply,:exclude_comment,:edit, :update,:destroy]
  end
  role :registered_user do
    has_permission_on [:comments,:arguments], :to => [:index, :show, :new, :create]
    has_permission_on :referendums, :to => [:index, :show, :aye,:nay]
    has_permission_on :politicians, :to => [:index, :show]
    has_permission_on :arguments, :to => [:aye,:nay,:exclude_argument]
    has_permission_on :comments, :to => [:reply_to_comment, :create_reply,:exclude_comment]
    has_permission_on [:comments,:arguments], :to => [:edit, :update,:destroy] do
      if_attribute :user_id => is { user.id }
    end
  end
  role :guest do
    has_permission_on [:comments,:arguments, :politicians, :referendums], :to =>  [:index, :show]
  end
end