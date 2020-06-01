require 'spec_helper'


describe 'Billing Cycle', type: :feature do

  context 'test Billing functionality' do
    before(:each) do
      setup_ast_environment
    end

    context 'Login' do
      before do
        login_as @user, @password
      end

      it 'accessing Gemini' do
        access_gemini
        click_link 'Subscriptions'
        expect(page).to have_content('List of Subscriptions')
        fill_in 'query', with: '13788'
        click_button 'Refresh'
        find('.icon-info-sign').click
        expect(page).to have_content 'Details for Subscription'
        find('.icon-pencil').click
        expect(page).to have_content 'Edit Subscription'
        fill_in 'subscription_rollback', with: '93'
        click_button 'Save'
        expect(page).to have_content 'Subscription successfully updated'
        find('.icon-list').click
        expect(page).to have_content 'Billing Summary'
        @billing_cycle = all('.id').last.text
        @billing_cycle = @billing_cycle.delete('#')
        click_link 'Rails Admin'
        page_tally
        expect(page).to have_content 'Successfully calculated page tally and processed the savings for Billing Cycle'
        page_tally #for second billing cycle
        expect(page).to have_content 'Successfully calculated page tally and processed the savings for Billing Cycle'
        visit @resque_url
        click_link 'Schedule'
        page.find(:xpath, "/html/body/div[@id='main']/div/table/tbody/tr[16]/td[2]/form/input[2]").click
        click_link 'Schedule'
        find(:xpath, "/html/body/div[@id='main']/div/table/tbody/tr[11]/td[2]/form/input[2]").click
        click_link 'Overview'
        expect(page).to have_content 'The list below contains all the registered queues with the number of jobs currently in the queue'
        while page.has_css? ('.icon') == false do
            redirect_to @resque_url
        end
        sleep 70
        expect(page).to have_css ('.no-data')
      end

      it 'verify Billing Details' do
        @printer = 'test.georgea@gmail.com'
        @printer_return = 'test Gemini'
        account_details
        click_on 'Billing'
        expect_content(['Payment Information', 'Billing History', 'Prepaid Information'])
        click_on 'btn-billing-history'
        @time = Time.now.utc.strftime("%m/%d/%Y")
        expect_content(['$3.23', 'Prepaid', @time])
        expect(page).to have_css ('.btn-billing-details')
        first('.btn-billing-details').click
        expect_content(['Billing Details', 'Billing Cycle', 'Refund', 'success', '$3.23', 'Prepaid'])
        click_on 'btn-refund'
        expect_content(['Refund Payments', 'Are you sure you want to refund?', '$3.23'])
        click_on 'btn-back-to-biling-cycle-details'
        click_on 'btn-refund'
        click_on 'btn-apply-refund'
        expect_content(['PEGASUS-REFUNDED', 'Refund Request', '-$3.23', @time, 'Prepaid'])
        click_button 'Done'
      end
    end
  end
 end