include Request
include Printers

def gemini_open_main_page(environment, region)
  pending "Should not run on this stack" if ENV.key?('AGENA_STACKS') and not ENV['AGENA_STACKS'].split(",").include?(environment)
  request_url = gemini_url(environment, region, "gemini_login")
  gemini_open_url request_url
end

def gemini_open_url(request_url)
  visit request_url
  begin
    page.driver.browser.switch_to.alert.accept
  rescue Selenium::WebDriver::Error::NoAlertPresentError
  end
  internal_wait_for_ajax
  @last_visited_url = request_url
end

def gemini_revisit_url()
  fail unless @last_visited_url
  gemini_open_url @last_visited_url
end

def gemini_main_page_sign_up()
  expect(page).to have_css('.sign-up-link')
  find('.sign-up-link.link.omniture-click').click()
  internal_wait_for_ajax
end

def gemini_main_page_sign_up_is_possible()
  internal_interaction_is_possible('.sign-up-link.link.omniture-click')
end

def gemini_plan_page_is_responsive()
  internal_interaction_is_possible('.plan-selector')
end

def gemini_plan_page_enter_ek(ek)
  expect(page).to have_css '.plan-selector'
  find("a[href*='enrollment_code']").click
  expect(page).to have_css "#code-box"
  find('#code').set(ek)
  internal_wait_for_ajax
end

def gemini_enrollment_page_check_success_continue(message)
  expect(page).to have_css "#code-box"
  expect(page).to have_css('.g-check-mark.success')
  expect(find('#code-message')).to have_content message
  find('.responsive-blue-button.continue').click()
  internal_wait_for_ajax
end

def gemini_enrollment_page_check_success_balance_continue(expected_balance)
  expect(page).to have_css "#code-box"
  expect(page).to have_css('.g-check-mark.success')
  internal_gemini_check_numbers_on_selector_text('#code-message', expected_balance)
  find('.responsive-blue-button.continue').click()
  internal_wait_for_ajax
end

def gemini_enrollment_page_check_success_back()
  expect(page).to have_css "#code-box"
  expect(page).to have_css('.g-check-mark.success')
  gemini_back()
end

def gemini_back()
  find('.back-arrow').click()
  internal_wait_for_ajax
end

def gemini_plan_page_check(table)
  expect(page).to have_css '.plan-selector'
  internal_gemini_plans_table_check('.plan-info', table)
end

def gemini_plan_page_select(index)
  expect(index).to be > 0
  elements = all(".responsive-blue-button.select")
  elements[index-1].click
  internal_wait_for_ajax
end

def gemini_account_page_add_default_continue(region, stack)
  expect(find '.signup-page-container').to have_selector '.hpc-iframe'
  within_frame(find '.hpc-iframe') do
    expect(page).to have_selector '#signupForm'
    fill_in 'First Name', with: 'Joao'
    fill_in 'Last Name', with: 'Santo Cristo'
    fill_in 'Email Address', with: internal_new_user_email(region, stack)
    fill_in 'Password', with: 'password'
    find("#termsOptin").click()
    find("#signupSubmit").click()
    expect(page).to have_css ('.mod-dialog.webauth-popup')
    find(".console-btn-confirm").click()
  end
end

def gemini_printer_page_add_default_continue()
  check_success = gemini_printer_page_add_default
  if check_success
    gemini_printer_page_check_continue
  end
end

def gemini_printer_page_add_new_selection_screen()
  printer_request_payload = create_simulated_printer_payload(@environment, 'Instant Ink')
  response = execute_request(:post, printer_request_payload['url'], printer_request_payload['body'], printer_request_payload['headers'])
  printer_data = parse_simulated_printer_response(response)
  find('#code').set(printer_data['email'].split("@")[0])
  internal_wait_for_ajax
  if page.driver.current_url.include? "printer_selection/new?step=4"#we are still here ? ok, we need to click on apply then
    find('#code-apply').click()
    internal_wait_for_ajax
  end
end

def gemini_printer_page_add_default()
  expect(page).to have_css '#printer-selection-step'
  check_success = true
  if page.driver.current_url.include? "printer_selection/new?step=4"
    gemini_printer_page_add_new_selection_screen
    check_success = false
  else
    find('.local-printer-button').click()
    expect(page).to have_css '.new_printer'
    find('.gray-button').click()
    internal_wait_for_ajax
    check_success = true
  end
  check_success
end

def gemini_printer_page_check_continue()
  expect(page).to have_css '.printer-state .glyphicon-ok'
  find('#printer-submit').click()
  internal_wait_for_ajax
end

def gemini_shipping_page_add_address_continue(region)
  expect(page).to have_selector('#shipping-step')
  expect(find '#shipping-step').to have_selector '.shipping-iframe'
  within_frame(find('.shipping-iframe')) do
    internal_gemini_shipping_page_add_address_continue(region)
  end
end

def gemini_billing_page_add_default_local()
  #sometimes, the billing step is skipped altogether...still don't know the rules for it, so I will drop this ugly way to handle it
  if page.driver.current_url.include? "/billing/"
    expect(page).to have_selector('#billing-step')
    expect(page).to have_selector('.responsive-blue-button.local-button')
    find('.responsive-blue-button.local-button').click()
    internal_wait_for_ajax
    expect(page).to have_selector('.credit-card-summary')
    find('.responsive-blue-button.continue').click()
    internal_wait_for_ajax
  end
end

def gemini_summary_page_add_promo_code(promo_name)
  expect(page).to have_css '#summary-offers'
  find('#code').set(promo_name)
  find('#code-apply').click()
end

def gemini_summary_page_check_content_offers(message)
  expect(find('#summary-offers')).to have_content message
end

def gemini_summary_page_check_content_total(message)
  expect(find('#summary-total')).to have_content message
end

def gemini_summary_page_check_numbers_offer(pages, price)
  elements_data = internal_pages_price_from_selector_all_elements('#summary-plan')
  actual_pages_price = elements_data[0]
  expected_pages_price = pages.to_s + "_" + price.to_s
  raise "Expected pages/price => #{expected_pages_price}, Actual pages/price => #{actual_pages_price}" unless expected_pages_price == actual_pages_price
  puts "Pages/Price as expected: #{expected_pages_price}"
end

def gemini_summary_page_check_numbers_total_enrollment_key(month, pages, price)
  expect(page).to have_css "#ek-total"
  expected_total = []
  if month.to_i > 0 and price.to_s != "FREE"
    expected_total = [price.to_s, month.to_s, pages.to_s].join("_")
  elsif price.to_s == "FREE" or month.to_i <= 0
    expected_total = [price.to_s, pages.to_s].join("_")
  end
  gemini_summary_page_check_numbers_total(expected_total)
end

def gemini_summary_page_check_numbers_prepaid_enrollment_key(prepaid_cents)
  expect(page).to have_css "#prepaid-total"
  elements_data = internal_extract_numbers_from_text(find('#prepaid-total').text())
  actual_total = elements_data.join("_")
  raise "Expected prepaid total => #{prepaid_cents}, Actual total => #{actual_total}" unless prepaid_cents == actual_total
  puts "Prepaid Total as expected (<price in cents>): #{prepaid_cents}"
end

def gemini_summary_page_check_numbers_total_promo_code(month, pages, price)
  expect(page).to have_css "#promo-code-total"
  expected_total = [price.to_s, month.to_s, pages.to_s].join("_")
  gemini_summary_page_check_numbers_total(expected_total)
end

def gemini_summary_page_no_total_promo_code()
  fail if internal_interaction_is_possible("#promo-code-total")
end

def gemini_summary_page_no_total_enrollment_key()
  fail if internal_interaction_is_possible("#ek-total")
end

def gemini_summary_page_check_numbers_total_promo_code_and_enrollment_key(month_ek, month_promo, pages, price)
  expect(page).to have_css "#promo-code-total"
  expect(page).to have_css "#ek-total"
  expected_total = [price.to_s, month_ek.to_s, pages.to_s, month_promo.to_s, pages.to_s].join("_")
  gemini_summary_page_check_numbers_total(expected_total)
end

def gemini_summary_page_check_numbers_total(expected_total)
  elements_data = internal_extract_numbers_from_text(find('#summary-total').text())
  actual_total = elements_data.join("_")
  raise "Expected total => #{expected_total}, Actual total => #{actual_total}" unless expected_total == actual_total
  puts "Total as expected (<price>_<months>_<pages> or <price>_<pages>): #{expected_total} "
end

def gemini_summary_page_accept_terms_enroll()
  expect(page).to have_css '#summary-enroll'
  page.execute_script "$('#accept-terms').click()"
  page.execute_script "$('#accept-prepaid').click()"
  find('.responsive-blue-button.enroll').click()
  expect(page).to have_css '#thank-you'
  puts page.driver.current_url
end
