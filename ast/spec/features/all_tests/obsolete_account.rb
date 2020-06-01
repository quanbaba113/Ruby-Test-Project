require 'spec_helper'

describe 'Obsolete Account', type: :feature do
  context 'test obsolete accounts' do
    before(:each) do
      setup_ast_environment
    end

    context 'Obsolete' do

      it 'verifying obsolete account' do
        login_as @user, @password
        @printer = 'oliver_smith_test_1807@mailinator.com'
        @printer_return = 'Oliver Smith'
        account_details
        click_on 'btn-obsolete-account'
        expect(page).to have_content 'Please confirm that you are obsoleting the Instant Ink account for'
        click_on 'btn-obsolete-account-discard'
        expect(page).to have_content 'Account Details'
        click_on 'btn-back'
        wait_for_ajax
        expect(page).to have_css ('.subscription-path')
        first('.subscription-path').click
        expect(page).to have_content 'Activation'
        click_on 'btn-obsolete-account'
        expect(page).to have_content 'Please confirm that you are obsoleting the Instant Ink account for'
        click_on 'btn-modal-obsolete-account'
        expect(page).to have_content 'The account has been obsoleted successfully'
      end

      it 'activating account again' do
        @email_hp = 'oliver_smith_test_1807@mailinator.com'
        visit 'https://instantink-pie1.hpconnectedpie.com'
        expect(page).to have_content 'HP Instant Ink'
        click_link 'Sign In'
        fill_in 'signinEmail', with: @email_hp
        fill_in 'signinPassword', with: 'password'
        click_button 'Sign In'
        expect(page).to have_content 'HP Instant Ink Account for'
        find('.add-printer').click
        expect(page).to have_content 'Choose Your Plan'
        click_on 'plan-1'
        expect(page).to have_content 'Your Printer'
        click_on 'Add Local Printer'
        expect(page).to have_content 'Pick Your Printer Model'
        fill_in 'printer_serial', with: '123456'
        fill_in 'printer_device_immutable_id', with: '1234'
        fill_in 'printer_cloud_identifier', with: '123'
        click_button 'Add printer'
        expect(page).to have_content 'Enroll'
        find('.blue-button').click
        within_frame find('#edit-billing-inline-frame') do
          find('#saveUpdate').click
        end
        expect_content(['Your Billing Information', 'Enroll', 'Enter your payment information', 'Shipping & Billing'])
        click_on 'save-and-continue'
        expect(page).to have_content 'You are almost done!'
        find(:css, '#subscription_accepted_terms_and_conditions').set(true)
        click_on 'enroll-button'
        expect(page).to have_content 'You’re enrolled!'
      end
    end
  end
end
