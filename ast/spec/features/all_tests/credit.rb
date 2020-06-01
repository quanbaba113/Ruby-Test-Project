require 'spec_helper'

describe 'Credit', type: :feature do

  context 'test Credit Free Month and Credit Pages' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do
      before do
        login_as @user, @password
      end

      if ENV['AST_TEST_ROLE'] == 'agent'
        it 'verify Credit Free Month functionality only for agent' do
          account_details
          click_button 'credit-tab'
          expect(page).to_not have_content 'Credit Free Month'
        end
      else
        it 'verify Credit Free Month functionality' do
          account_details
          click_button 'credit-tab'
          wait_for_ajax
          expect(page).to have_content 'Credit Free Month'
          click_button 'btn-credit-free-month'
          expect(page).to have_content 'You are about to credit a Free Month'
          click_button 'btn-credit-free-month-cancel'
          expect(page).to have_content 'Credit Free Month'
          click_button 'btn-credit-free-month'
          expect(page).to have_content 'You are about to credit a Free Month'
          click_button 'btn-credit-free-month-credit'
          expect(page).to have_content ('successfully')
        end

        it 'credit a RaF Free Month' do
          account_details
          click_button 'credit-tab'
          expect(page).to have_content 'Credit Refer-a-Friend Free Month'
          click_on 'btn-credit-raf-free-month'
          expect(page).to have_content 'You are about to credit a Refer-a-Friend Free Month'
          click_on 'btn-credit-raf-free-month-cancel'
          expect(page).to have_content 'Credit Refer-a-Friend Free Month'
          click_on 'btn-credit-raf-free-month'
          expect(page).to have_content 'You are about to credit a Refer-a-Friend Free Month'
          click_button 'Credit'
          expect(page).to_not have_content 'RaF Free Month applied successfully'
        end
      end

      it 'verify Credit 15 Pages functionality ' do
        account_details
        click_button 'credit-tab'
        expect(page).to have_content 'Credit Pages to Account'
        click_button 'btn-credit-pages'
        expect(page).to have_content 'Select the number of pages to credit'
        click_button 'btn-credit-pages-credit'
        expect(page).to have_content ('successfully')
      end

      it 'verify Credit 30 Pages functionality ' do
        account_details
        click_button 'credit-tab'
        expect(page).to have_content 'Credit Pages to Account'
        click_button 'btn-credit-pages'
        expect(page).to have_content 'Select the number of pages to credit'
        choose('pages_30')
        click_button 'btn-credit-pages-credit'
        expect(page).to have_content ('successfully')
      end
    end
  end
end
