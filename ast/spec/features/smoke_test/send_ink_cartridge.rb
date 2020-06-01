require 'spec_helper'

describe 'Send Ink Cartridge', type: :feature do

  context 'test Send Ink Cartridge' do
    before :each do
      setup_ast_environment
    end

    context 'Login' do
      before do
        login_as @user, @password
      end

      unless ENV['AST_STACK'] == 'test1'
        xit 'Send Ink Cartridge with shipping option standard and K color type' do
          account_details
          send_ink_cartridge
          expect_content(['shipping information', 'Color Type'])
          find('#K-option').click
          @option = 'order-shipping-option-standard-ink-cartridge'
          shipping_option
          @time = @standard_time
        end

        xit 'Send Ink Cartridge with priority option and K color type' do
          account_details
          send_ink_cartridge
          expect_content(['shipping information', 'Color Type'])
          find('#K-option').click
          @option = 'order-shipping-option-priority-ink-cartridge'
          shipping_option
          @time = @expedite_time
        end

        xit 'Send Ink Cartridge with express option and K color type' do
          account_details
          send_ink_cartridge
          expect_content(['shipping information', 'Color Type'])
          find('#K-option').click
          @option = 'order-shipping-option-express-ink-cartridge'
          shipping_option
          @time = @express_time
        end

        xit 'Veryfing Ink Cartridges in the Customer Transactions' do
          account_details
          click_on 'Historical'
          click_on 'accordion_section_customer_transactions'
          wait_for_ajax
          expect_content(['Cartridge', 'Ink Cartridges', @standard_time, @expedite_time, @express_time])
        end
      end
    end
  end
end
