require 'spec_helper'

describe 'Settings Feature', type: :feature do
  context 'test settings feature' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do

      xit 'changing password' do
        @test = rand 10**2
        @new_password = "P@ssw0rd" + @test.to_s
        login_as @user, @password
        click_link 'Settings'
        wait_for_ajax
        fill_in 'user_password', with: @new_password
        fill_in 'user_password_confirmation', with: @new_password
        click_button 'Save Changes'
        expect(page).to have_content 'Your account has been updated successfully'
        click_link 'Sign Out'
        expect(page).to have_content 'have an account?'
      end

      xit 'rechanging password' do
        login_as @user, @new_password
        wait_for_ajax
        expect(page).to have_content 'Service Support'
        click_link 'Settings'
        wait_for_ajax
        fill_in 'user_current_password', with: @new_password
        fill_in 'user_password', with: @password
        fill_in 'user_password_confirmation', with: @password
        click_button 'Save Changes'
        expect(page).to have_content 'Password was used previously'
        wait_for_ajax
        fill_in 'user_current_password', with: @new_password
        fill_in 'user_password', with: @new_password
        fill_in 'user_password_confirmation', with: @new_password
        click_button 'Save Changes'
        expect(page).to have_content 'Password must be different than the current password'
      end
    end
  end
end
