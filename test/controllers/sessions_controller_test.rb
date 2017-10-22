require "test_helper"

describe SessionsController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      # Count the users, to make sure we're not (for example) creating
      # a new user every time we get a login request
      start_count = User.count

      login(users(:dan))
      must_redirect_to root_path

      # Since we can read the session, check that the user ID was set as expected
      session[:user_id].must_equal users(:dan).id

      # Should *not* have created a new user
      User.count.must_equal start_count
    end

    it "should not create a new user on repeated logins" do

      proc{
        3.times do
          login(users(:dan))
        end
      }.wont_change "User.count"

    end

    it "creates an account for a new user and redirects to the root route" do

      start_count = User.count
      user = User.new(provider: "github", uid: 99999, username: "test_user", email: "test@user.com")

      login(user)
      must_redirect_to root_path

      # Should have created a new user
      User.count.must_equal start_count + 1

      # The new user's ID should be set in the session
      session[:user_id].must_equal User.last.id
    end

    it "responds with bad request if given invalid user data" do

      start_count = User.count
      user = User.new(uid: 99999, username: "test_user", email: "test@user.com")

      login(user)
      must_respond_with :internal_server_error
      User.count.must_equal start_count

    end
  end
end
