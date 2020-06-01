include Request

ADDRESSES_PER_REGION = {
    US: {
        UserStreetAddress: '149 New Montgomery St',
        UserCity: 'San Francisco',
        UserZipCode: '94105',
        UserState: '//*[@id="select2-results-4"]/li[6]',#California
    },
    UK: {
        UserStreetAddress: '400 Oxford St',
        UserCity: 'London',
        UserZipCode: 'W1A 1AB',
        UserState: '//*[@id="select2-results-4"]/li[66]',#London
    },
    DE: {
        UserStreetAddress: 'Friedrichstraße 96',
        UserCity: 'Berlin',
        UserZipCode: '10117'
    },
    ES: {
        UserStreetAddress: 'Av. de Concha Espina 1',
        UserCity: 'Madrid',
        UserZipCode: '28036',
        UserState: '//*[@id="select2-results-4"]/li[32]',#Madrid
    },
    FR: {
        UserStreetAddress: '16, rue Victor Hugo',
        UserCity: 'Châteauroux',
        UserZipCode: '36000'
    },
    CA: {
        UserStreetAddress: '2625 Airport Dr',
        UserCity: 'Saskatoon',
        UserZipCode: 'S7L 7L1',
        UserState: '//*[@id="select2-results-4"]/li[13]',#Saskatchewan
    }
}

def internal_log(str)
  puts "\n" + Time.now.to_s + ": " + str
end

def internal_address_per_region(region, str)
  ADDRESSES_PER_REGION[region.strip.to_sym][str.strip.to_sym]
end

def internal_finished_all_ajax_requests?
  page.evaluate_script('jQuery.active').zero?
end

def internal_wait_for_ajax
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until internal_finished_all_ajax_requests?
  end
end

def internal_set_value(selector, value)
  page.execute_script "$('#{selector}').val('#{value}')"
end

def internal_new_user_email(region, stack)
  return 'geremias_' + region.strip + '_' + stack.strip + '_' + internal_rand_string() + '@mailinator.com'
end

def internal_rand_string()
  return Time.now.inspect.split('+')[0].gsub(/\s/,'').gsub(/-/, '').gsub(/:/,'')+"#{rand(100)}"
end

def internal_interaction_is_possible(selector)
  selectors = all(selector)
  selectors.length > 0
end

def internal_gemini_plans_array_check(selector, data_array)
  elements_data = internal_pages_price_from_selector_all_elements(selector)
  elements_data.sort!
  elements_data = elements_data.join(",")

  elements_expected = []
  data_array.each do |row|
    elements_expected.push(row['pages'].to_s + "_" + row['priceCents'].to_s)
  end
  elements_expected.sort!
  elements_expected = elements_expected.join(",")

  #finally, compare - different orders are not errors to us, just different combinations of pages vs price
  raise "Expected => #{elements_expected}, Actual => #{elements_data}" unless elements_expected == elements_data
end

def internal_gemini_plans_table_check(selector, table)
  data = (table.is_a?(Array)) ? table : table.hashes

  elements_data = internal_pages_price_from_selector_all_elements(selector)
  elements_data.sort!
  elements_data = elements_data.join(",")

  #convert data to the same format "<page>_<price>" and the same sort criteria
  elements_expected = []
  data.each do |row|
    elements_expected.push(row['pages'].to_s + "_" + row['priceCents'].to_s)
  end
  elements_expected.sort!
  elements_expected = elements_expected.join(",")

  #finally, compare - different orders are not errors to us, just different combinations of pages vs price
  raise "Expected => #{elements_expected}, Actual => #{elements_data}" unless elements_expected == elements_data
  puts "Plans as expected: #{elements_expected}"
end

def internal_gemini_shipping_page_add_address_continue(region)

  current_url = page.driver.current_url
  expect(page).to have_selector '#shippingForm'

  fill_in 'city', with: internal_address_per_region(region, 'UserCity')
  fill_in 'address1', with: internal_address_per_region(region, 'UserStreetAddress')

  if ADDRESSES_PER_REGION[region.strip.to_sym].key? 'UserState'.to_sym
    #select state... yeah, ugly
    find('.select2-container').click()
    expect(page).to have_selector "#select2-drop"
    option = all(:xpath, internal_address_per_region(region, 'UserState'))
    selenium_webdriver = page.driver.browser
    selenium_webdriver.mouse.down(option[0].native)
    selenium_webdriver.mouse.up
  end

  fill_in 'zipCode', with: internal_address_per_region(region, 'UserZipCode')
  find('#saveUpdate').click
  internal_wait_for_ajax()

  #redo if needed
  begin
    if current_url == page.driver.current_url
      find('#saveUpdate').click
      internal_wait_for_ajax()
    end
  rescue Exception => e

  end
end

def internal_gemini_check_numbers_on_selector_text(selector, expected_number_as_str)
  elements = all(:css, selector)
  expect(elements.length).to be > 0
  numbers = internal_extract_numbers_from_text(elements[0].text())
  actual_number = numbers[0].to_i.to_s
  raise "Expected => #{expected_number_as_str}, Actual => #{actual_number}" unless expected_number_as_str == actual_number
  puts "#{selector} as expected => #{expected_number_as_str}"
end

def internal_extract_numbers_from_text(text)
  #Will return an array of strings with all the numbers (or 'FREE' word) found on text.
  #FREE1 was a problem with responsive flow so it have to be replaced directly.
  #gsub was needed to replace coin characters that got glued together with numbers...and it even helped to convert dollars to cents for free :)
  text.gsub(/[^a-zA-Z0-9 ]*/, "").sub("FREE1", "FREE").split().select{ |i| true if i == "FREE" or Float(i) rescue false}
end

def internal_pages_price_from_selector_all_elements(selector)
  #read screen elements to obtains elements in the format "<page>_<price>" and the same sort criteria
  separator = "_" #move it to parameter if needed
  elements = all(:css, selector)
  elements_data = []
  elements.each do |e|
    numbers = internal_extract_numbers_from_text(e.text())
    pages = numbers[1]
    price = numbers[0] == "FREE" ? numbers[0] : numbers[0].to_i.to_s #'099' should be '99', as well as '50.0' should be '50'
    elements_data.push(pages + separator + price)
  end
  elements_data
end

def internal_gemini_select_printer(is_on_responsive_flow)
  #We may have bugs on that flow on gemini due to new printer selection page. Once they're resolved, this method should be no longer necessary
  #Expected method after the bugs are solved follows below:
  #if is_on_responsive_flow
  # gemini_printer_page_add_default_continue()
  #else
  # gemini_non_responsive_printer_page_add_default_continue()
  internal_is_on_responsive_flow = is_on_responsive_flow
  if internal_interaction_is_possible('#printer-selection-step')
    check_success = gemini_printer_page_add_default()
    internal_is_on_responsive_flow = true
  else
    check_success = gemini_non_responsive_printer_page_add_default()
    internal_is_on_responsive_flow = false
  end

  if check_success
    if internal_interaction_is_possible('.printer-state .glyphicon-ok')
      gemini_printer_page_check_continue
      internal_is_on_responsive_flow = true
    else
      gemini_non_responsive_printer_page_check_continue
      internal_is_on_responsive_flow = false
    end
  end

  internal_is_on_responsive_flow
end