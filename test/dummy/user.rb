TestDummy.declare(User) do
  dummy :email do
    Faker::Internet.email
  end

  dummy :password do
    'passpass'
  end

  dummy :role do
    User::ROLES[0]
  end
end
