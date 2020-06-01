require 'spec_helper'

describe 'Shipping History', type: :feature do

  context 'test Shipping History' do
    before :each do
      setup_ast_environment
    end

    context 'Login' do
      before do
        login_as @user, @password
      end

      if ENV['AST_STACK'] == 'pie1'
        it 'search user and Shipping History' do
          account_details
          visit 'https://instantink-pie1.hpconnectedpie.com/ast/subscriptions/72404'
          welcome_kit
          @option = 'order-shipping-option-standard-welcome-kit'
          shipping_option
        end

        it 'Pending Shipping Order' do
          account_details
          visit 'https://instantink-pie1.hpconnectedpie.com/ast/subscriptions/72404'
          send_ink_cartridge
          click_on 'btn-close-modal'
          #After send Ink Cartridge, it generates a Pending Shipping Order for few minutes
          click_on 'Historical'
          click_on 'accordion-section-shipping'
          expect_content(['Date', 'Color', 'Shipped', 'Tracking', 'Pending Shipping Order'])
        end

        it 'Shipping History Tracking URL' do
          account_details
          visit 'https://instantink-pie1.hpconnectedpie.com/ast/subscriptions/72404'
          click_on 'Historical'
          click_on 'accordion-section-shipping'
          visit 'http://webtrack.dhlglobalmail.com/?trackingnumber=123456'
          expect(page).to have_content('DHL')
        end
      end
    end
  end
end
