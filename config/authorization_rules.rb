authorization do
  role admin do
    has_permission_on [:referendums, :comments], :to => [:index, :show, :new, :create, :edit, :update]
  end
end