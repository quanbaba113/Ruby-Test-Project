require 'spec_helper'

describe 'Settings Feature', type: :feature do
  context 'test settings feature' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do

      it 'password validations' do
        @long_password = rand 10**130
        @short_password = '1234'
        login_as @user, @password
        click_link 'Settings'
        wait_for_ajax

        #long password validation
        fill_in 'user_current_password', with: @password
        fill_in 'user_password', with: @long_password
        fill_in 'user_password_confirmation', with: @long_password
        click_button 'Save Changes'
        expect(page).to have_content 'is too long'

        #short password validation
        fill_in 'user_current_password', with: @password
        fill_in 'user_password', with: @short_password
        fill_in 'user_password_confirmation', with: @short_password
        click_button 'Save Changes'
        expect(page).to have_content 'Password is too short'

        fill_in 'user_current_password', with: @password
        @incorrect_password = 'test1234'
        fill_in 'user_password', with: @incorrect_password
        fill_in 'user_password_confirmation', with: @incorrect_password
        click_button 'Save Changes'
        expect(page).to have_content 'Password must contain big, small letters, digits and symbols'
      end
    end
  end
end
