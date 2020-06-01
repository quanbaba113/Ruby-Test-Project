require 'spec_helper'

describe 'New Enrollment Code', type: :feature do
  context 'test new enrollment code' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do

      if ENV['AST_TEST_ROLE'] == 'agent'
        it 'if agent user' do
          login_as @user, @password
          expect(page).to_not have_css '#btn-new-enrollment-code'
        end
      else
        it 'generate, search, deactivate and apply enrollment code' do
          login_as @user, @password
          click_on 'btn-new-enrollment-code'
          wait_for_ajax
          expect(page).to have_css ('.offer-path')
          click_on 'btn-search-code' # Code to first offer path works on chrome
          wait_for_ajax
          first('.glyphicon-chevron-right').click
          wait_for_ajax
          click_on 'btn-generate-code'
          expect(page).to have_content 'Done'
          code = find('.code').native.text
          click_on 'btn-done-generate-code'
          fill_in 'enrollment-search-key', with: code
          click_on 'btn-enrollment-search'
          expect(page).to have_content 'Activated'
          click_button 'Deactivate Code'
          expect(page).to have_content 'Please confirm that you are deactivating the enrollment code'
          click_on 'btn-deactivate-code'
          expect(page).to have_content 'deactivated successfully'
          click_on 'btn-close-modal'
          click_on 'btn-new-enrollment-code'
          wait_for_ajax
          click_on 'btn-old-enrollment-code'
          expect(page).to have_content 'Create New Enrollment Code by the Old Enrollment Code'
          fill_in 'old-enrollment-code', with: code
          expect(page).to have_css ('.offer-path')
          click_on 'btn-search-code'
          wait_for_ajax
          first('.glyphicon-chevron-right').click
          wait_for_ajax
          click_on 'btn-generate-code'
          expect(page).to have_content 'Error - Old Code is already deactivated'
        end

        it 'verifying Enrollment Code dialog in the System Admin option menu' do
          login_as 'user@example.com', 'P@ssw0rd'
          click_link 'System Admin'
          expect(page).to have_content 'Access Requests'
          fill_in 'user_search', with: @user
          click_on 'btn-user-search'
          expect(page).to have_content 'Active'
          page.find(:css, '.user-credentials').click
          expect(page).to have_content 'AST Transactions'
          #deactivated code modal
        end

        it 'search by country and vendor' do
          login_as @user, @password
          click_on 'btn-new-enrollment-code'
          wait_for_ajax
          click_on 'btn-country-vendor'
          expect_content(['Country', 'Offer', 'Enrollment', 'Name','Type', 'Tax Paid'])
          click_select(find(".selectpicker[data-id='country-filter-enrollments']"), 'US')
          expect_content(['Country', 'Offer', 'Enrollment', 'Name','Type', 'Tax Paid'])
          click_select(find(".selectpicker[data-id='vendor-filter-enrollments']"), 'HP Support')
          wait_for_ajax
          click_on 'btn-search-code'
          expect(page).to have_content 'HP Support 50pg Plan'
        end

        it 'validate Offer ID and Old Enrollment Code' do
          login_as @user, @password
          click_on 'btn-new-enrollment-code'
          wait_for_ajax
          fill_in 'offer_id', with: '09'
          click_on 'btn-search-code'
          expect(page).to have_content 'Offers not found'
          click_on 'btn-old-enrollment-code'
          expect(page).to have_content 'Create New Enrollment Code by the Old Enrollment Code'
          fill_in 'old-enrollment-code', with: 'abcdABCD1234@#$%'
          click_on 'btn-search-code'
          expect(page).to have_content 'Invalid old enrollment code. Please try again.'
        end

        it 'Verifying pagination - Offer ID' do
          login_as @user, @password
          click_on 'btn-new-enrollment-code'
          wait_for_ajax
          find('#table-offers-enrollment-code_paginate').click
          expect(page).to have_css ('.offer-path')
          click_on 'btn-search-code' # Code to first offer path works on chrome
          wait_for_ajax
          click_on 'btn-offer-details-10'
          expect(page).to have_content 'Back to List'
          click_on 'btn-back-to-list-offers'
          wait_for_ajax
          find('#table-offers-enrollment-code_paginate').click
          expect(page).to have_css ('.offer-path')
          click_on 'btn-search-code' # Code to first offer path works on chrome
          wait_for_ajax
          click_on 'btn-offer-details-10'
          expect(page).to have_content 'Back to List'
          click_on 'btn-back-to-list-offers'
          click_on 'btn-close-modal'
        end

        it 'Verifying pagination - Country/Vendor' do
          login_as @user, @password
          click_on 'btn-new-enrollment-code'
          wait_for_ajax
          click_on 'btn-country-vendor'
          expect_content(['Country', 'Offer', 'Enrollment', 'Name','Type', 'Tax Paid'])
          find('#table-offers-enrollment-code_paginate').click
          expect(page).to have_css ('.offer-path')
          click_on 'btn-search-code' # Code to first offer path works on chrome
          wait_for_ajax
          click_on 'btn-offer-details-10'
          expect(page).to have_content 'Back to List'
          click_on 'btn-back-to-list-offers'
          wait_for_ajax
          find('#table-offers-enrollment-code_paginate').click
          expect(page).to have_css ('.offer-path')
          click_on 'btn-search-code' # Code to first offer path works on chrome
          wait_for_ajax
          click_on 'btn-offer-details-10'
          expect(page).to have_content 'Back to List'
          click_on 'btn-back-to-list-offers'
          click_on 'btn-close-modal'
        end

        it 'Verifying pagination - Old Enrollment Code' do
          login_as @user, @password
          click_on 'btn-new-enrollment-code'
          wait_for_ajax
          click_on 'btn-old-enrollment-code'
          expect(page).to have_content 'Create New Enrollment Code by the Old Enrollment Code'
          find('#table-offers-enrollment-code_paginate').click
          expect(page).to have_css ('.offer-path')
          click_on 'btn-search-code' # Code to first offer path works on chrome
          wait_for_ajax
          click_on 'btn-offer-details-10'
          expect(page).to have_content 'Back to List'
          click_on 'btn-back-to-list-offers'
          wait_for_ajax
          find('#table-offers-enrollment-code_paginate').click
          expect(page).to have_css ('.offer-path')
          click_on 'btn-search-code' # Code to first offer path works on chrome
          wait_for_ajax
          click_on 'btn-offer-details-10'
          expect(page).to have_content 'Back to List'
          click_on 'btn-back-to-list-offers'
          click_on 'btn-close-modal'
        end
      end
    end
  end
end
