require 'spec_helper'

describe 'Login', type: :feature do

  before(:each) do
    setup_ast_environment
  end

  context 'Verifying Login feature' do
    before {
      login_as @invalid_user, @invalid_password
      expect(page).to have_content 'Invalid email or password'
      login_as @user, @password
    }

    if ENV['AST_TEST_ROLE'] == 'admin'
      it 'verifying login as admin' do
        click_link 'System Admin'
        click_link 'Service Support'
        click_on 'New Enrollment Code'
        expect(page).to have_content 'Create a New Enrollment Code by Old Enrollment Code, by Country/Vendor or Offer ID.'
      end

    elsif ENV['AST_TEST_ROLE'] == 'operations' || ENV['AST_TEST_ROLE'] == 'agent_lead'
      it 'verifying login as agent or agent_lead or operations' do
        click_link 'Service Support'
        click_on 'New Enrollment Code'
        wait_for_ajax
        page.find(:css, '#btn-close-modal').click
        wait_for_ajax
        click_link 'Sign Out'
        expect(page).to have_content 'Signed out successfully.'
      end

      it 'verifying components loging as agent_lead or operations' do
        expect(page).to_not have_content 'System Admin'
        click_link 'Sign Out'
        expect(page).to have_content 'Signed out successfully.'
      end

    else  ENV['AST_TEST_ROLE'] == 'agent'
    it 'verifying components loging as agent' do
      click_link 'Service Support'
      expect_content(['Settings', 'Provide feedback', 'Promo Code', 'Enrollment Code', 'Search'])
    end
    end

  end
end
