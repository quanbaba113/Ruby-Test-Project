require 'spec_helper'

describe 'Credit Card', type: :feature do

  context 'test Credit Card' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do
      before do
        login_as @user, @password
      end

      it 'verify Credit Free Month functionality only for agent' do
        fill_in 'user-search', with: @printer
        click_on 'Search'
        click_link @printer_return
        wait_for_ajax
        click_on 'btn-credit-card-info'
        expect_content(['Status', 'Date', 'Order Id', 'LastFour', 'CC Expiration Date'])
        first('.glyphicon-plus').click
        expect_content(['RCode', 'ResponseTime', 'CustomerID', 'CardType'])
      end
    end
  end
end
