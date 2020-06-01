require 'spec_helper'

describe 'Customer Account Page', type: :feature do
  context 'test customer account page' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do
      before do
        login_as @user, @password
      end

      it 'verifying customer account page' do
        account_details

        if Capybara.javascript_driver == :selenium
          page.find("#btn-view-account-page-url").click
        else
          page.find("#btn-view-account-page-url").trigger("click")
        end

        wait_for_ajax
        within_window(windows.last) do
          expect(page).to have_content('Instant Ink')
        end
      end

      it 'validate special characters' do
        click_link 'System Admin'
        expect(page).to have_content 'New User'
        fill_in 'user-email-field', with: 'feger324234@#$%%¨@hp.com'
        click_select(find(".selectpicker[data-id='user_role']"), 'Agent')
        expect(page).to have_content 'Invalid email format'
      end
    end
  end
end
