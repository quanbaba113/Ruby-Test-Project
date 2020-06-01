require 'spec_helper'

describe 'Promocode', type: :feature do

  context 'test Promocode in Credit & Promo' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do

      if ENV['AST_TEST_ROLE'] == 'agent'
        it 'applied promocode test' do
          login_as @user, @password
          account_details
          click_on 'Credit & Promo'
          expect(page).to_not have_content ('Promocode')
        end
      else
        it 'applied promocode test' do
          login_as @user, @password
          account_details
          click_on 'Credit & Promo'
          fill_in 'promocode', with: @promo_expired
          click_on 'btn-promo-code'
          click_on 'Apply'
          if ENV['AST_STACK'] == 'test1'
            expect(page).to have_content ('could not be applied')
          else
            expect(page).to have_content ('code already applied')
          end
        end

        it 'Historical - verifying Promocode log' do
          access_agena
          click_link 'Create Promo Code'
          expect(page).to have_content 'Create a New Promo Code'
          o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
          @test = (0...6).map { o[rand(o.length)] }.join
          fill_in 'promo_code_name', with: @test
          fill_in 'promo_code_code', with: @test.upcase
          fill_in 'promo_code_start_date_display', with: '01/01/2016'
          fill_in 'promo_code_end_date_display', with: '12/31/2020'
          find(:css, '#region-2').set(true)
          find(:css, '#promo_code_valid_for_any_retailer').set(true)
          click_on 'Create'
          expect(page).to have_content 'Successfully created 1 Promo Code(s)!'
          login_as @user, @password
          account_details
          click_on 'credit-tab'
          fill_in 'promocode', with: @test
          click_on 'btn-promo-code'
          expect(page).to have_content 'Details of Promo code'
          click_on 'Apply'
          expect(page).to have_content 'code already applied'
          @date = Time.new.strftime("%m/%d/%Y %H:%M:%S")
          click_on 'btn-close-modal'
          click_on 'historical-tab'
          expect(page).to have_content 'Customer Transactions'
          click_on 'accordion-section-customer-transactions'
          expect(page).to have_content 'Credit&Promo'
          find('.sorting_desc').click
          @element = first('.sorting_1').text
          if @element != @date
            puts 'Sorting is ok'
          else
            raise 'Sorting is not functional'
          end
        end
      end
    end
  end
end
