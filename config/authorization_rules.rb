authorization do
  role :admin do
    has_permission_on [:referendums, :comments], :to => [:index, :show, :new, :create, :edit, :update]
  end
  role :guest do
    has_permission_on :referendums, :to => [:index, :show]
  end
end