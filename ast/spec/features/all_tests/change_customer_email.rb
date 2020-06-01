require 'spec_helper'

describe 'Change Email', type: :feature do
  context 'test change customer email' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do
      before do
        login_as @user, @password
      end

      unless ENV['AST_TEST_ROLE'] == 'agent'
        it 'verifying change email' do
          @printer = 'oliver_smith_test_1807@mailinator.com'
          @printer_return = 'Oliver Smith'
          fill_in 'user-search', with: @printer
          click_on 'Search'
          wait_for_ajax
          click_link @printer_return
          wait_for_ajax
          expect(page).to have_content '300 South Spring Street'
          click_on 'btn-edit-email'
          expect(page).to have_content 'Use the form below to edit'
          @field = page.find(:css, '#user_new_email')
          expect(@field[:disabled]).to eq 'true'
          find(:css, '#chk-verify-identity').set(true)
          expect(@field[:visible])
          @counter_text = 'r45t454g4t4tt45tfjenviniwhiurthwhgwbnwirtubw4ijg3ybgrw3@gmail.co'
          fill_in 'user_new_email', with: 'r45t454g4t4tt45tfjenviniwhiurthwhgwbnwirtubw4ijg3ybgrw3@gmail.com'
          if find('#user_new_email').value == @counter_text
            fill_in 'user_new_email', with: 'test@ia.com'
            fill_in  'user_re_enter_new_email', with: 'test2@ia.com'
            click_on 'btn-edit-email-apply'
            expect(page).to have_content 'E-mails must match'
            fill_in 'user_new_email', with: '12345678'
            fill_in  'user_re_enter_new_email', with: '12345678'
            click_on 'btn-edit-email-apply'
            expect(page).to have_content 'Invalid e-mail format'
            click_on 'btn-close-modal'
            expect(page).to have_content '300 South Spring Street'
            click_on 'btn-edit-email'
            expect(page).to have_content 'Use the form below to edit'
            find(:css, '#chk-verify-identity').set(true)
            @test = rand 10**6
            $test_email = "test_qa" + @test.to_s + "@gmail.com"
            fill_in 'user_new_email', with: 'test@ia.com'
            fill_in  'user_re_enter_new_email', with: 'test@ia.com'
            click_on 'btn-edit-email-apply'
            expect(page).to have_content 'User already exists'
            click_on 'btn-close-modal'
            wait_for_ajax
            click_on 'btn-edit-email'
            expect(page).to have_content 'Use the form below to edit'
            find(:css, '#chk-verify-identity').set(true)
            fill_in 'user_new_email', with: $test_email
            fill_in  'user_re_enter_new_email', with: $test_email
            click_on 'btn-edit-email-apply'
            expect(page).to have_content 'User e-mail successfully updated.'
            click_on 'btn-close-modal'
            expect(page).to have_content '300 South Spring Street'
          else
            raise 'accept only 64 chars'
          end

        end

        it 'change email again' do
          @printer = $test_email
          @printer_return = 'Oliver Smith'
          fill_in 'user-search', with: @printer
          click_on 'Search'
          wait_for_ajax
          click_link @printer_return
          wait_for_ajax
          expect(page).to have_content '300 South Spring Street'
          click_on 'btn-edit-email'
          expect(page).to have_content 'Use the form below to edit'
          find(:css, '#chk-verify-identity').set(true)
          expect(page).to have_css('#user_new_email')
          fill_in 'user_new_email', with: 'oliver_smith_test_1807@mailinator.com'
          fill_in  'user_re_enter_new_email', with: 'oliver_smith_test_1807@mailinator.com'
          click_on 'btn-edit-email-apply'
          expect(page).to have_content 'User e-mail successfully updated.'
          click_on 'btn-close-modal'
          expect(page).to have_content '300 South Spring Street'
        end

        it 'change email - Historical' do
          @printer = 'oliver_smith_test_1807@mailinator.com'
          @printer_return = 'Oliver Smith'
          fill_in 'user-search', with: @printer
          click_on 'Search'
          wait_for_ajax
          click_link @printer_return
          wait_for_ajax
          click_on 'historical-tab'
          click_on 'accordion-section-customer-transactions'
          expect(page).to have_content 'Change Email'
          first('.glyphicon-eye-open').click
          expect(page).to have_content 'Details of Edit Customer'
          expect_content(['Details of Edit Customer', $test_email, 'oliver_smith_test_1807@mailinator.com', 'Old Email', 'Replaced Email'])
        end
      end
    end
  end
end
