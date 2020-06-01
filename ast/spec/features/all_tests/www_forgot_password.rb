require 'spec_helper'

describe 'Forgot my password', type: :feature do
  context 'test settings feature' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do
      before do
        visit AST::Router.login_url
        click_link 'Forgot your password?'
      end

      it 'reseting password' do
        expect(page).to have_content 'Password Recovery'
        fill_in 'user_email', with: 'johnsmith_adm_hp@mailinator.com'
        click_button 'Send'
        expect(page).to have_content 'You will receive an email'
        sleep 5
        visit 'https://mailinator.com/'
        expect(page).to have_content 'Free Public Email'
        fill_in 'inboxfield', with: 'johnsmith_adm_hp@mailinator.com'
        click_button 'Go!'
        expect(page).to have_content 'HOME PRICING FAQ API EMAIL LOGIN SIGNUP'
        find('.oddrow_public').click
        expect(page).to have_content 'HOME PRICING FAQ API EMAIL LOGIN SIGNUP'
        page.find('#public_showmaildiv')
        click_button 'public_delete_button'
      end
    end
  end
 end
