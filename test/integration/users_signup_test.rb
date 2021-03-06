require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "invalid user information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {name: "", email: "mexample@wrong", password:"longpasserwd", password_confirmation:"longpasswd"}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    
  end

  test "valid user signup with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: {name: "Example User", email: "johndoe@gmail.com", password: "huehuehue", password_confirmation: "huehuehue" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    #try logging in before activation
    log_in_as user
    assert_not is_logged_in?
    #invalid token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    #valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: "wrong email")
    assert_not is_logged_in?
    #valid everything
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    #commented out from previous tests.
    #+++++++++++++
    #assert_template 'users/show'
    #assert_not flash.empty?
    #assert is_logged_in?
  end     
end
