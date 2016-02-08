require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "invalid user information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path user: {name: "", email: "me@wrong", password:"longpasswd", password_confirmation:"longerpasswd"}
    end
    assert_template 'users/new'
  end

  test "valid user signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path user: {name: "John Doe", email: "johndoe@gmail.com", password: "huehuehue", password_confirmation: "huehuehue" }
    end
    assert_template 'users/show'
  end     
end
