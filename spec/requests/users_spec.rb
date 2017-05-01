require 'spec_helper'

describe "Users" do

  before(:each) { @user = FactoryGirl.create(:user) }

  describe "signup " do

    describe "failure should not make a new user" do
      it "if email field is empty" do
        lambda do
          visit new_user_registration_path
          fill_in "Email",        with: ""
          fill_in "Password",     with: @user.password
          fill_in "Password confirmation",   with: @user.password
          click_button 'Sign up'
          page.html.should match("Email can&#39;t be blank")
        end.should_not change(User, :count)
      end

      it "if password field doesn't equal password_confirmation" do
        lambda do
          visit new_user_registration_path
          fill_in "Email",        with: "admin@mail.ru"
          fill_in "Password",     with: @user.password
          fill_in "Password confirmation",   with: "wrong_password"
          click_button 'Sign up'
          page.html.should match("Password confirmation doesn&#39;t match Password")
        end.should_not change(User, :count)
      end

      it "if email format doesn't equal certain pattern" do
        lambda do
          visit new_user_registration_path
          fill_in "Email",        with: "admin@mail.ru3213"
          fill_in "Password",     with: @user.password
          fill_in "Password confirmation",   with: @user.password
          click_button 'Sign up'
          page.html.should match("Email is invalid")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should make a new user" do
        lambda do
          visit new_user_registration_path
          fill_in "Email",        with: "admin@mail.ru"
          fill_in "Password",     with: @user.password
          fill_in "Password confirmation", with: @user.password
          click_button 'Sign up'
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "sign in/out " do

    describe "failure should not sign a user in" do
      it "with wrong email" do
        visit new_user_session_path
        fill_in "Email",    with: "wrong@email.net"
        fill_in "Password", with: @user.password
        click_button 'Log in'
        page.html.should match("Invalid email or password.")
      end

      it "with wrong password" do
        visit new_user_session_path
        fill_in "Email",    with: @user.email
        fill_in "Password", with: "wrong password"
        click_button 'Log in'
        page.html.should match("Invalid email or password.")
      end
    end

    describe "success" do
      it "should sign a user in" do
        visit new_user_session_path
        fill_in "Email",    with: @user.email
        fill_in "Password", with: @user.password
        click_button 'Log in'
        page.html.should match("Signed in successfully.")
      end
    end
  end
end