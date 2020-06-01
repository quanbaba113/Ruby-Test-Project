require 'spec_helper'

describe 'Welcome', type: :feature do

  context 'test search option in Welcome Page' do
    before(:each) do
      setup_ast_environment
    end

    context 'Verifying Search' do
      before do
        login_as @user, @password
      end

      it 'search by user email' do
        fill_in 'user-search', with: @printer
        click_select(find(".selectpicker[data-id='customer-filter-method']"), 'Customer Email')
        click_on 'Search'
        click_link @printer_return
        expect(page).to have_content 'Instant Ink Accounts'
      end

      it 'search by Customer Account' do
        @search_user = @account
        @filter = 'Customer Account'
        @printer_return = 'lv yugui'
        search_user
      end

      it 'search by Printer Serial' do
        fill_in 'user-search', with: '123456789'
        click_select(find(".selectpicker[data-id='customer-filter-method']"), 'Printer Serial')
        click_on 'Search'
        expect(page).to have_content 'No results found'
        click_link 'Sign Out'
        expect(page).to have_content 'have an account?'
        login_as @user, @password
        fill_in 'user-search', with: @printerserial
        click_select(find(".selectpicker[data-id='customer-filter-method']"), 'Printer Serial')
        click_on 'Search'
        expect(page).to have_css '.odd'
      end

      it 'search modal instant ink account' do
        fill_in 'user-search', with: @printer
        click_on 'Search'
        wait_for_ajax
        click_link @printer_return
        expect(page).to have_content 'Instant Ink Accounts'
      end

      it 'search by name' do
        click_select(find(".selectpicker[data-id='customer-filter-method']"), 'Customer Name')
        fill_in 'user-search', with: 'test'
        fill_in 'last-name-search', with: 'testqa'
        click_on 'Search'
        wait_for_ajax
        expect_content(['Customer Name', 'Email', 'Phone Number', 'Shipping Address'])
        expect(page).to have_css '#user-search-table'
        expect(page).to have_css '#user-search-table_next'
        expect(page).to have_css '#user-search-table_previous'
      end
    end
  end
end
