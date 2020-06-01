require 'spec_helper'

describe 'Welcome Kit', type: :feature do

  context 'test Welcome Kit' do
    before :each do
      setup_ast_environment
    end

    context 'Login' do
      before do
        login_as @user, @password
      end

      if ENV['AST_STACK'] == 'pie1'
        it 'search user and Welcome kit - standard time' do
          fill_in 'user-search', with: 'oliver_smith_test_1807@mailinator.com'
          click_on 'Search'
          click_link 'Oliver Smith'
          visit 'https://instantink-pie1.hpconnectedpie.com/ast/subscriptions/72404'
          welcome_kit
          @option = 'order-shipping-option-standard-welcome-kit'
          shipping_option
          @time = @standard_time
        end

        it 'search user and Welcome kit - express time' do
          fill_in 'user-search', with: 'oliver_smith_test_1807@mailinator.com'
          click_on 'Search'
          click_link 'Oliver Smith'
          visit 'https://instantink-pie1.hpconnectedpie.com/ast/subscriptions/72404'
          welcome_kit
          @option = 'order-shipping-option-express-welcome-kit'
          shipping_option
          @time = @express_time
        end

        it 'veryfing Welcome Kit in the Customer Transactions' do
          fill_in 'user-search', with: 'oliver_smith_test_1807@mailinator.com'
          click_on 'Search'
          click_link 'Oliver Smith'
          visit 'https://instantink-pie1.hpconnectedpie.com/ast/subscriptions/72404'
          click_on 'Historical'
          click_on 'accordion-section-customer-transactions'
          expect_content(['Cartridge', 'Welcome Kit', @standard_time, @expedite_time, @express_time])
        end
      end
    end
  end
end
