# factories let use create objects from models for use in testing controllers

# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

# expects to be called in a sequence
Factory.sequence :email do |n|
  "person-#{n}@example.com"
end