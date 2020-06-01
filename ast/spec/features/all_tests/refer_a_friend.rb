require 'spec_helper'

describe 'Refer a Friend', type: :feature do

  context 'test RaF' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do
      before do
        login_as @user, @password
      end

      xit 'apply a RaF code on a subscription - first part and case sensitive verification' do
        @email_hp = 'oliver_smith_test_1807@mailinator.com'
        visit 'https://instantink-pie1.hpconnectedpie.com'
        expect(page).to have_content 'Connected'
        click_link 'Sign In'
        fill_in 'signinEmail', with: @email_hp
        fill_in 'signinPassword', with: 'password'
        click_button 'Sign In'
        expect(page).to have_content 'HP Instant Ink Account for'
        $raf_code = find(:css, '#refer_a_friend_link').value
        $raf_code = $raf_code.gsub("http://try.hpinstantink.com/", '').strip
        expect($raf_code).to have_content 'fzRMm'
      end

      xit 'apply a RaF code on a subscription - second part' do
        @email_hp = 'pietra_smith_test_1807@mailinator.com'
        visit 'https://instantink-pie1.hpconnectedpie.com'
        expect(page).to have_content 'Connected'
        click_link 'Sign In'
        fill_in 'signinEmail', with: @email_hp
        fill_in 'signinPassword', with: 'password'
        click_button 'Sign In'
        expect(page).to have_content 'HP Instant Ink Account for'
        $test_code = find(:css, '#refer_a_friend_link').value
        $test_code = $test_code.gsub("http://try.hpinstantink.com/", '').strip
        puts $test_code
        @printer = 'pietra_smith_test_1807@mailinator.com'
        @printer_return = 'Pietra Smith'
        login_as @user, @password
        fill_in 'user-search', with: @printer
        click_on 'Search'
        wait_for_ajax
        click_link @printer_return
        wait_for_ajax
        expect(page).to have_css ('.subscription-path')
        first('.subscription-path').click
        expect(page).to have_content 'Activation'
        click_on 'credit-tab'
        expect(page).to have_content 'Refer-a-Friend Code'
        fill_in 'raf_code_txt', with: $test_code
        click_on 'btn-raf-code'
        expect(page).to have_content 'Details of Refer-a-Friend Code'
        click_button 'Apply'
        expect(page).to have_content 'You cannot apply your own short code'
        click_on 'btn-close-modal'
        fill_in 'raf_code_txt', with: 'aaaaa'
        click_on 'btn-raf-code'
        expect(page).to have_content 'Invalid Refer-a-Friend Code. Please try again.'
        click_on 'btn-close-modal'
        fill_in 'raf_code_txt', with: $raf_code
        click_on 'btn-raf-code'
        expect(page).to have_content 'Details of Refer-a-Friend Code'
        click_button 'Apply'
        expect(page).to have_content 'code successfully applied'
        click_on 'btn-close-modal'
        expect(page).to have_content 'Account Details'
        click_on 'btn-obsolete-account'
        expect(page).to have_content 'Please confirm that you are obsoleting the Instant Ink account for'
        click_on 'btn-modal-obsolete-account'
        expect(page).to have_content 'The account has been obsoleted successfully'
      end

      it 'create a specific subscription' do
        @email_hp = 'pietra_smith_test_1807@mailinator.com'
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





        #click_on 'printer-submit'
        #wait_for_ajax
        #click_on 'saveUpdate'
        #expect(page).to have_content 'Billing Information'
        #find(:css,'.continue').click
        #expect(page).to have_content 'Submit Order'
        #find(:css,'.checkbox-image').set(true)
        #find(:css, '.enroll').click
        #expect(page).to have_content 'Thank You'
      end

      xit 'check the status of a RaF code' do
        expect(page).to have_content 'Refer-a-Friend Codes'
        fill_in 'raf-search-key', with: $raf_code
        click_on 'btn-raf-search'
        expect(page).to have_content 'N/A N/A'
      end

      xit 'RaF inside Historical tab' do
        @printer = 'pietra_smith_test_1807@mailinator.com'
        @printer_return = 'Pietra Smith'
        account_details
        click_on 'historical-tab'
        expect(page).to have_content 'View the Refer-a-Friend Program history'
        click_on 'accordion_section_enrollment'
        if find('.accordion-enrollment-content').find('label', text: 'Refer-a-Friend recruiter code').find(:xpath, '..').find('div').text.empty?
          raise_error('RaF code was not applicated')
        else
          access_gemini
          click_link 'Refer a friends'
          expect(page).to have_content 'List of Refer a friends'
          fill_in 'query', with: $raf_code
          click_button 'Refresh'
          expect(page).to have_content '1 refer a friend'
          find('.icon-info-sign').click
          expect(page).to have_content 'Basic info'
        end
      end

      xit 'validate ckeck code' do
        @printer = 'pietra_smith_test_1807@mailinator.com'
        @printer_return = 'Pietra Smith'
        account_details
        click_on 'credit-tab'
        expect(page).to have_content 'Refer-a-Friend Code'
        if find('#btn-raf-code').visible?
          raise_error('The check code button is available')
        else
          expect(page).to have_content 'Apply a refer-a-friend code to a customer'
        end
      end

      xit 'list all subscribers that has used the RaF code' do
        @printer = 'oliver_smith_test_1807@mailinator.com'
        @printer_return = 'Oliver Smith'
        account_details
        click_on 'historical-tab'
        click_on 'accordion_section_refer_a_friend_program'
        expect_content(['ENROLLS BY REFER-A-FRIEND CODE', 'Pietra Smith'])
      end
    end
  end
end
