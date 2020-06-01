require 'spec_helper'

describe 'System Admin', type: :feature do
  context 'test system admin' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do
      before do
        login_as @user, @password
      end

      if ENV['AST_TEST_ROLE'] == 'admin'
        it 'verifying system admin' do
          click_link 'System Admin'
          expect(page).to have_content 'Access Requests'
          fill_in 'user_search', with: 'johnsmith_adm_hp@mailinator.com'
          expect(page).to_not have_css 'list-container'
        end

        it 'verifying system admin transactions' do
          customer_transactions
          fill_in 'account_number', with: '5217625236'
          click_on 'btn-filter'
          expect(page).to have_css '.table-bordered'
          customer_transactions
          click_select(find(".selectpicker[data-id='transactions_filter']"),'Promo Code')
          click_on 'btn-filter'
          expect(page).to have_content 'Promo Code'
          customer_transactions
          fill_in 'initial_date', with: '08/01/2015'
          fill_in 'final_date', with: '08/31/2015'
          click_on 'btn-filter'
          expect(page).to have_css '.table-bordered'
        end

        it 'select one account' do
          customer_transactions
          fill_in 'account_number', with: @account_number
          click_on 'btn-filter'
          wait_for_ajax
          first('.customer-path').click
          expect(page).to have_content 'Account Details'
          click_on 'credit-tab'
          expect(page).to have_content 'Apply a promotional code'
        end

        it 'add company admin role' do
          visit 'https://www.mohmal.com/pt/'
          expect(page).to have_content 'Descartável e-mail temporário'
          click_on 'Nome aleatória'
          expect(page).to have_content 'Seu e-mail temporário é criado'
          @mail = find('.email').text
          login_as @user, @password
          click_link 'System Admin'
          expect(page).to have_content 'New User'
          fill_in 'user-email-field', with: @mail
          click_select(find(".selectpicker[data-id='user_role']"), 'Company Admin')
          click_select(find(".selectpicker[data-id='user_company_id']"), 'HP')
          click_on 'btn-user-add'
          expect(page).to have_content 'User was successfully created'
        end

        it 'Validations for Company Admin' do
          login_as 'lud.varela@gmail.com', 'P@ssw0rd'
          click_link 'System Admin'
          expect(page).to have_content 'Access Requests'
          fill_in 'user_search', with: 'Andy'
          click_on 'btn-user-search'
          expect(page).to have_content 'Active'
          first('.user-credentials').click
          if click_select(find(".selectpicker[data-id='user_role']"), 'Admin') == false
            raise 'Admin must not be an option into this combobox'
          else
            click_on 'btn-back'
            expect(page).to have_content 'Access Requests'
            click_link 'Requests Pending'
            expect(page).to have_content 'Accept/Decline'
            expect(page).to_not have_content 'Sitel'
            expect(page).to_not have_content 'Stream'
          end
        end

        it 'AST users by Company information' do
          click_link 'System Admin'
          expect(page).to have_content 'Access Requests'
          find('.dropdown-label').click
          expect_content(['Agent', 'Agent Lead', 'Operations', 'Admin', 'Company Admin', 'Pending', 'Active', 'Inactive', 'No Company', 'HP', 'Stream', 'Sitel'])
          first('#role_filter').set(false)
          click_on 'btn-user-search'
          expect_content(['testqa1', 'Andy'])
          find('.dropdown-label').click
          expect_content(['Agent', 'Agent Lead', 'Operations', 'Admin', 'Company Admin', 'Pending', 'Active', 'Inactive', 'No Company', 'HP', 'Stream', 'Sitel'])
          first('#status_filter').set(false)
          click_on 'btn-user-search'
          expect_content(['Another Normal User', 'test'])
          find('.dropdown-label').click
          expect_content(['Agent', 'Agent Lead', 'Operations', 'Admin', 'Company Admin', 'Pending', 'Active', 'Inactive', 'No Company', 'HP', 'Stream', 'Sitel'])
          find('#no-company').set(false)
          click_on 'btn-user-search'
          expect_content(['Andy', 'test'])
        end
       end
    end
  end
end
