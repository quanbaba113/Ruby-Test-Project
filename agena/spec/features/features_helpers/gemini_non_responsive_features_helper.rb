include Request

def gemini_non_responsive_main_page_sign_up()
  expect(page).to have_css('.blue-button.get-started')
  find('.blue-button.get-started').click()
  internal_wait_for_ajax
end

def gemini_non_responsive_sign_up_is_possible()
  internal_interaction_is_possible('#create-account')
end

def gemini_non_responsive_sign_up(country, environment)
  expect(page).to have_css '#create-account'
  fill_in "email", with: internal_new_user_email(country, environment)
  fill_in "firstName", with: 'Joao de'
  fill_in "lastName", with: 'Santo Cristo'
  fill_in "password", with: 'password'
  fill_in "confirmPassword", with: 'password'
  page.driver.execute_script("document.getElementById('termsOptin').click()")
  find("#signupSubmit").click()
  expect(page).to have_css ('.mod-dialog.webauth-popup')
  find(".console-btn-confirm").click()
  internal_wait_for_ajax
end

def gemini_non_responsive_plan_page_enter_ek(ek)
  expect(page).to have_css '#enter-code-box'
  find('#code').set(ek)
  find('.code-submit').click
  internal_wait_for_ajax
end

def gemini_non_responsive_plan_page_select(index)
  expect(index).to be > 0
  elements = all(".plan-input.radio")
  elements[index-1].click
end

def gemini_non_responsive_plan_page_select_continue(index)
  expect(index).to be > 0
  elements = all(".plan-input.radio")
  elements[index-1].click
  gemini_non_responsive_continue()
end

def gemini_non_responsive_printer_page_add_default_continue()
  gemini_non_responsive_printer_page_add_default
  gemini_non_responsive_printer_page_check_continue
end

def gemini_non_responsive_printer_page_add_default()
  check_success = true
  expect(page).to have_selector ".close-modal"
  find(".close-modal").click()
  expect(page).to have_selector '.no-printers'
  find(".blue-button.no-confirm[href*=printers]").click()
  expect(page).to have_css '.new_printer'
  find('.gray-button').click()
  internal_wait_for_ajax
  check_success
end

def gemini_non_responsive_printer_page_check_continue()
  expect(page).to have_selector '.active-printer'
  find('.continue').click()
  internal_wait_for_ajax
end

def gemini_non_responsive_shipping_page_add_address_continue(region)
  expect(page).to have_selector('#inline-shipping-form')
  expect(find '#inline-shipping-form').to have_selector '#edit-billing-inline-frame'
  within_frame(find('#edit-billing-inline-frame')) do
    internal_gemini_shipping_page_add_address_continue(region)
  end
end

def gemini_non_responsive_billing_page_add_default_local()
  expect(page).to have_selector('.payment-method-title')
  find(".gray-button.no-confirm[href*=create_for_test]").click()
  internal_wait_for_ajax
  begin
    expect(page).to have_selector(".payment-method.pgs.entered")
  rescue
    fail "Virtual Credit Card not valid - maybe something is amiss on this stack"
  end
  find("#save-and-continue").click()
  internal_wait_for_ajax
end

def gemini_non_responsive_summary_page_add_promo_code(promo_name)
  expect(page).to have_css '.order-total'
  find('#promotion').set(promo_name)
  find('.promotion-submit').click()
  expect(page).to have_css '.promotion-code-applied-container'
end

def gemini_non_responsive_summary_page_check_content_offers(message)
  expect(find('.plan-details')).to have_content message
end

def gemini_non_responsive_summary_page_check_content_total(message)
  expect(find('.order-total')).to have_content message
end

def gemini_non_responsive_summary_page_accept_terms_enroll()
  expect(page).to have_css '.accepted-terms-and-conditions'
  find("#subscription_accepted_terms_and_conditions").click()
  if all("#prepaid-terms").length > 0
    find("#prepaid-terms").click()
  end
  find('#enroll-button').click()
  internal_wait_for_ajax
  expect(page).to have_css ".signup-flow.thanks"
  puts page.driver.current_url
end

def gemini_non_responsive_summary_page_check_numbers_offer(pages, price)
  elements_data = internal_pages_price_from_selector_all_elements('.plan-offer-details')
  actual_pages_price = elements_data[0]
  expected_pages_price = pages.to_s + "_" + price.to_s
  raise "Expected pages/price => #{expected_pages_price}, Actual pages/price => #{actual_pages_price}" unless expected_pages_price == actual_pages_price

  elements_data = internal_extract_numbers_from_text(find('.order-totals-row.order-plan-frequency').text())
  actual_price_per_month = elements_data[0]
  expected_price_per_month = price.to_s
  raise "Expected price/month => #{expected_price_per_month}, Actual price/month => #{actual_price_per_month}" unless expected_price_per_month == actual_price_per_month
end

def gemini_non_responsive_summary_page_check_numbers_promo_code(month, pages, price)
  expect(page).to have_css (".promotion-code-applied-container")
  expected_total = [price.to_s, month.to_s, pages.to_s].join("_")
  gemini_non_responsive_summary_page_check_numbers(expected_total)
end

def gemini_non_responsive_summary_page_no_total_promo_code()
  fail if internal_interaction_is_possible(".promotion-code-applied-container")
end

def gemini_non_responsive_summary_page_check_numbers_enrollment_key(month, pages, price)
  expect(page).to have_css (".enrollment-key-applied")
  expected_total = [price.to_s, month.to_s, pages.to_s].join("_")
  gemini_non_responsive_summary_page_check_numbers(expected_total)
end

def gemini_non_responsive_summary_page_no_total_enrollment_key()
  fail if internal_interaction_is_possible(".enrollment-key-applied")
end

def gemini_non_responsive_summary_page_check_numbers_promo_code_and_enrollment_key(month_ek, month_promo, pages, price)
  expect(page).to have_css (".promotion-code-applied-container")
  expect(page).to have_css (".enrollment-key-applied")
  expected_total = [price.to_s, month_ek.to_s, pages.to_s, month_promo.to_s, pages.to_s].join("_")
  gemini_non_responsive_summary_page_check_numbers(expected_total)
end

def gemini_non_responsive_summary_page_check_numbers(expected_total)
  actual_text = find(".order-plan-frequency").text() + " " + find(".enrollment-key-applied").text()
  elements_data = internal_extract_numbers_from_text(actual_text)
  actual_total = elements_data.join("_")
  raise "Expected total => #{expected_total}, Actual total => #{actual_total}" unless expected_total == actual_total
  puts "Totals as expected: #{expected_total}"
end

def gemini_non_responsive_check_success_ek_back(message)
  gemini_non_responsive_check_success_ek(message)
  gemini_revisit_url
end

def gemini_non_responsive_check_success_balance_ek_back(expected_balance)
  gemini_non_responsive_check_success_balance_ek(expected_balance)
  gemini_revisit_url
end

def gemini_non_responsive_back()
  find('.no-confirm').click()
  internal_wait_for_ajax
end

def gemini_non_responsive_continue()
  find('.continue').click()
  internal_wait_for_ajax
end

def gemini_non_responsive_check_success_ek(message)
  expect(page).to have_css '.green-checkmark'
  expect(find('.status-success-text')).to have_content message
end

def gemini_non_responsive_check_success_balance_ek(expected_balance)
  expect(page).to have_css '.green-checkmark'
  internal_gemini_check_numbers_on_selector_text('.status-success-text', expected_balance)
end

def gemini_non_responsive_plan_page_check(table)
  expect(page).to have_css '#select-plan'
  internal_gemini_plans_table_check(".plan-details:not(.grayed-out)", table)
end

def gemini_non_responsive_logout_if_needed()
  if internal_interaction_is_possible('#logout')
    find('#logout').click()
  end
end
