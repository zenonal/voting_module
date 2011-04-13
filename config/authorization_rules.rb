authorization do
  role :admin do
    has_permission_on [:referendums, :comments], :to => [:index, :show, :new, :create, :edit, :update]
  end
  role :guest do
    has_permission_on :referendums, :to => [:index, :show]
    has_permission_on :comments, :to => [:index, :show, :new, :create]
    has_permission_on :comments, :to => [:edit, :update] do
      if_attribute :user => is { user }
    end
  end
end