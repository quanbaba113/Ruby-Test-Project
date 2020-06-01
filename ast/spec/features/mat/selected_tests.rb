require 'spec_helper'
describe 'Selected Tests', type: :feature do

  before(:each) do
    setup_ast_environment
  end

  context 'MAT' do
    before do
      login_as @user, @password
    end

    it 'verifying basic test scenarios' do

      #Search by user email
      fill_in 'user-search', with: @printer
      click_on 'Search'
      click_link @printer_return
      expect(page).to have_content 'Instant Ink Accounts'
      click_link 'Service Support'

      #Search for a valid promocode
      @country = 'us'
      @promo_test = @promo_us
      search_promo
      click_button 'Done'

      #Welcome Kit
      account_details
      welcome_kit
      @option = 'order-shipping-option-standard-welcome-kit'
      shipping_option
      click_on 'btn-close-modal'
      click_link 'Service Support'

      #Generate New Enrollment Code
      click_on 'btn-new-enrollment-code'
      wait_for_ajax
      expect(page).to have_css ('.offer-path')
      click_on 'btn-search-code' # Code to first offer path works on chrome
      wait_for_ajax
      first('.offer-path').click
      wait_for_ajax
      click_on 'btn-generate-code'
      expect(page).to have_content 'Done'
      code = find('.code').native.text
      click_on 'btn-done-generate-code'
      fill_in 'enrollment-search-key', with: code
      click_on 'btn-enrollment-search'
      expect(page).to have_content 'Activated'

      #Credit Free Month
      fill_in 'user-search', with: @printer
      click_on 'Search'
      click_link @printer_return
      wait_for_ajax
      expect(page).to have_css ('.subscription-path')
      first('.subscription-path').click
      expect(page).to have_content 'Activation'
      click_on 'Credit & Promo'
      wait_for_ajax
      click_on 'Credit Free Month'
      expect(page).to have_content 'You are about to credit a Free Month'
      click_button 'btn-credit-free-month-credit'
      expect(page).to have_content ('Free Month applied successfully')
      click_on 'btn-close-modal'

      #Credit Pages
      click_button 'btn-credit-pages'
      expect(page).to have_content 'Select the number of pages to credit'
      click_button 'btn-credit-pages-credit'
      expect(page).to have_content ('15 free pages credit')
      click_on 'btn-close-modal'

      #Historical
      click_on 'Historical'
      click_on 'accordion_section_customer_transactions'
      expect(page).to have_content ('Free Month')
      expect(page).to have_content ('Credit Pages')
    end
  end
end
