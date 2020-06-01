module Features

  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  private

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

  public

  def wait_page_with content
    expect(page).to have_content content
  end

  def wait_ids list
    list.each do |field|
      expect(page).to have_field(field)
    end
  end

  def wait_us_page
    wait_page_with 'Agent Support'
  end

  def wait_login_page
    wait_ids ['user-email', 'user-password']
  end

  def login_as(username, password)
    visit AST::Router.login_url
    wait_login_page
    fill_in 'user-email', with: username
    fill_in 'user-password', with: password
    click_button 'Sign in'
  end

  module UserActionsHelpers
    def click_select(element, option_name)
      element.click
      option = first('a', text: option_name)
      option.click
    end
  end

  module IntegrationActionsHelpers
    def expect_content(args)
      args.each do |arg|
        expect(page).to have_content("#{arg}")
      end
    end

    def expect_no_content(args)
      args.each do |arg|
        expect(page).not_to have_content("#{arg}")
      end
    end

    def account_details()
      fill_in 'user-search', with: @printer
      click_on 'Search'
      wait_for_ajax
      click_link @printer_return
      expect(page).to have_content 'Instant Ink Accounts'
      first('.glyphicon-chevron-right').click
      expect(page).to have_content 'Account Details'
    end

    def send_ink_cartridge()
      click_on 'Cartridge'
      expect(page).to have_content 'Ink Cartridge'
      click_on 'Send Ink Cartridge'
      wait_for_ajax
    end

    def billing()
      account_details
      click_on 'Billing'
      expect_content(['Payment Information', 'Billing History', 'PGS'])
      click_on 'btn-billing-history'
    end

    def search_promo()
      unless @country =='us' #When country is US, click is not needed (default value).
        find(".selectpicker[data-id='promocode-search-country']").click
        wait_for_ajax
        find("#promocode-search .flag-#{@country}").click
        wait_for_ajax
      end

      fill_in 'promocode-search-key', with: @promo_test
      click_on 'btn-promocode-search'
      expect_content([@country, 'More detail', 'Promo Code'])
      click_button 'More detail'
      wait_for_ajax
      expect_content(['Details of Promocode', @promo_test, @country.upcase])
    end

    def shipping_option()
      expect_content(['All regions', 'Shipping Option'])
      choose (@option)
      wait_for_ajax
      click_button 'Send'
      @time = Time.now.utc.strftime("%m/%d/%Y - %H:%M")
      expect(page).to have_content 'successfully sent'
    end

    def welcome_kit()
      click_on 'Cartridge'
      expect(page).to have_content 'Welcome Kit'
      click_on 'Send Welcome Kit'
      wait_for_ajax
    end

    def search_user()
      fill_in 'user-search', with: @search_user
      click_select(find(".selectpicker[data-id='customer-filter-method']"), @filter)
      click_on 'Search'
      click_link @printer_return
      wait_for_ajax
      expect(page).to have_content 'Instant Ink Accounts'
    end

    def page_tally()
      click_link 'Admins'
      expect(page).to have_content 'List of Admins'
      click_link 'Billing cycles'
      expect(page).to have_content 'List of Billing cycles'
      @billing_cycle = (@billing_cycle.to_i) - 1
      fill_in 'query', with: @billing_cycle
      click_button 'Refresh'
      find('.id_field', text: @billing_cycle).click
      expect(page).to have_content 'Details for Billing cycle'
      find('.icon-file').click
    end

    def access_gemini()
      visit @url_gemini
      expect(page).to have_content 'Connected'
      fill_in 'admin_email', with: Credential.username
      fill_in 'admin_password', with: Credential.password
      click_button 'Log in'
      expect(page).to have_content('Gemini Admin')
    end

    def access_agena()
      visit @url_agena
      expect(page).to have_content 'Log in'
      fill_in 'admin_user_email', with: Credential.username
      fill_in 'admin_user_password', with: Credential.password
      click_button 'Log in'
      expect(page).to have_content('Agena Admin')
    end

    def create_new_subscription()
      visit 'https://instantink-pie1.hpconnectedpie.com'
      expect(page).to have_content 'Connected'
      click_link 'Sign In'
      fill_in 'signinEmail', with: @email_hp
      fill_in 'signinPassword', with: 'password'
      click_button 'Sign In'
      expect(page).to have_content 'I have an enrollment card.'
      find('.continue').click
      expect(page).to have_content 'Your Printer'
      click_on 'Add New Local-Only Printer'
      expect(page).to have_content 'Pick Your Printer Model'
      fill_in 'printer_serial', with: '123456'
      fill_in 'printer_device_immutable_id', with: '1234'
      fill_in 'printer_cloud_identifier', with: '123'
      click_button 'Add printer'
      expect(page).to have_content 'Enroll'
      find('.blue-button').click
      within_frame find('#edit-billing-inline-frame') do
        find('#saveUpdate').click
      end
      expect_content(['Your Billing Information', 'Enroll', 'Enter your payment information', 'Shipping & Billing'])
      click_on 'save-and-continue'
      expect(page).to have_content 'You are almost done!'
      find(:css, '#subscription_accepted_terms_and_conditions').set(true)
      click_on 'enroll-button'
      expect(page).to have_content 'You’re enrolled!'
    end

    def customer_transactions()
      click_link 'System Admin'
      expect(page).to have_content 'Access Requests'
      fill_in 'user_search', with: 'Admin'
      click_on 'btn-user-search'
      wait_for_ajax
      first('.user-credentials').click
    end
  end
end
