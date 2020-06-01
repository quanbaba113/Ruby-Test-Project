require 'spec_helper'

describe 'Search Enrollment Key', type: :feature do

  before(:each) do
    setup_ast_environment
  end

  context 'test search enrollment key ' do
    before do
      login_as @user, @password
    end

    it 'search by activated enrollment key' do
      fill_in 'enrollment-search-key', with: @key_activated
      click_on 'btn-enrollment-search'
      expect(page).to have_content('Activated')
    end

    it 'search by redeemed enrollment key' do
      fill_in 'enrollment-search-key', with: @key_redeemed
      click_on 'btn-enrollment-search'
      expect(page).to have_content('Redeemed')
    end

    it 'search by deactivated enrollment key' do
      fill_in 'enrollment-search-key', with: @key_deactivated
      click_on 'btn-enrollment-search'
      expect(page).to have_content('Deactivated')
    end

    it 'search by deactivated enrollment key' do
      fill_in 'enrollment-search-key', with: '123456'
      click_on 'btn-enrollment-search'
      expect(page).to have_content 'Enrollment key not found'
    end
  end
end
