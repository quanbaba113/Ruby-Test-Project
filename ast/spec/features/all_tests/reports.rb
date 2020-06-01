require 'spec_helper'

describe 'Reports', type: :feature do

  context 'transactions report' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do
      before do
        login_as @user, @password
      end

      it 'generate transactions report' do
        expect(page).to have_content 'Agent Support Tool'
        click_link 'Reports'
        expect(page).to have_content 'Export Report'
        click_on 'btn-reports-search'
        expect(page).to have_css '.table-bordered'
        fill_in 'start_date', with: '01/01/2016'
        click_on 'btn-reports-search'
        expect(page).to have_content 'Credit&Promo'
      end

      it 'filter All Actions based on All Sections' do
        expect(page).to have_content 'Agent Support Tool'
        click_link 'Reports'
        expect(page).to have_content 'Export Report'
        click_select(find(".selectpicker[data-id='transaction_section']"), 'Cartridge')
        wait_for_ajax
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Welcome Kit')
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Send Recycle Cartridge Envelope')
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Ink Cartridges')
        wait_for_ajax
        click_select(find(".selectpicker[data-id='transaction_section']"), 'Account')
        wait_for_ajax
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Customer Account Page')
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Cancel')
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Obsolete')
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Change Email')
        wait_for_ajax
        click_select(find(".selectpicker[data-id='transaction_section']"), 'Credit&Promo')
        wait_for_ajax
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Credit Pages')
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Promo Code')
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Free Month')
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Psccode')
        click_select(find(".selectpicker[data-id='transaction_action']"), 'RaF Code')
        wait_for_ajax
        click_select(find(".selectpicker[data-id='transaction_section']"), 'Enrollment Key Code')
        wait_for_ajax
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Creation')
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Replacement')
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Deactivate')
        wait_for_ajax
        click_select(find(".selectpicker[data-id='transaction_section']"), 'Billing')
        wait_for_ajax
        click_select(find(".selectpicker[data-id='transaction_action']"), 'Refund')
        click_on 'btn-reports-search'
        expect(page).to_not have_content 'Promo Code'
      end

      it 'reports - access denied' do
        click_link 'Sign Out'
        expect(page).to have_content 'Forgot your password?'
        login_as @operations, @password
        expect(page).to have_content 'Agent Support Tool'
        expect(page).to_not have_content 'Reports'
      end

      it 'generate report' do
        account_details
        click_on 'cartridge-tab'
        fill_in 'start-date', with: '08/02/2016'
        fill_in 'end-date', with: '08/03/2016'
        wait_for_ajax
        click_on 'see-report'
      end

      it 'generate report - System Admin' do
        expect(page).to have_content 'Agent Support Tool'
        click_link 'Reports'
        expect(page).to have_content 'Export Report'
        click_on 'btn-reports-search'
        wait_for_ajax
        expect(page).to have_css '.table-reports'
      end
    end
  end
end
