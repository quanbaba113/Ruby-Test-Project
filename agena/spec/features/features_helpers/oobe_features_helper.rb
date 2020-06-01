include Request

def oobe_plans_check(offer, expected_plans)
  fail_message = ""
  if expected_plans.length != offer['plans'].length
    fail_message = "Expected length to be #{expected_plans.length} but was #{offer['plans'].length}.\nBelow is the obtained data:"
    offer['plans'].each do |row|
      fail_message += "\n\t" + row.to_s
    end
    fail_message += "\nBelow is the expected data:"
    expected_plans.each do |plan|
      fail_message += "\n\t" + plan.to_s
    end
  else
    #convert data to format "<page>_<price>_<guid>" and the same sort criteria
    actual_plans = agena_extract_gemini_plans_info(offer)
    elements_data = []
    actual_plans.each do |row|
      elements_data.push(row['pages'].to_s + "_" + row['priceCents'].to_s + "_" + row['guid'].to_s)
    end
    elements_data.sort!
    elements_data = elements_data.join(",")

    #convert data to the same format "<page>_<price>_<guid>" and the same sort criteria
    elements_expected = []
    expected_plans.each do |row|
      elements_expected.push(row['pages'].to_s + "_" + row['priceCents'].to_s + "_" + row['guid'].to_s)
    end
    elements_expected.sort!
    elements_expected = elements_expected.join(",")

    #finally, compare - different orders are not errors to us, just different combinations of pages vs price
    fail_message = "Expected => #{elements_expected}, Actual => #{elements_data}" unless elements_expected == elements_data
  end
  fail_message
end

def oobe_open_simulator(environment, country, language, serialNo, modelID, jumpID)

  page.driver.browser.manage.window.maximize
  request_url = gemini_url(environment, "NO_LANGUAGE", "gemini")

  visit 'https://oss.hpconnectedpie.com/emulate/'
  internal_wait_for_ajax

  internal_set_value('input[name=\"gemini-base-uri\"]', request_url)
  fill_in "serialNo", with: serialNo
  fill_in "modelID", with: modelID
  fill_in "pr_cc", with: country
  fill_in "lang", with: language
  fill_in "user_email", with: internal_new_user_email(country, environment)
  fill_in "jumpID", with: jumpID
end

def oobe_plan_page_check_default_on_left(country)
  expect(page).to have_selector("#enter_ek_image[ng-src*='#{country}/EnrCards_default']")
end

def oobe_plan_page_check(table, country)
  expect(page).to have_selector '.choose_plan'
  i = 0
  expect(page).to have_selector('.rate-per-month', visible: true)
  expect(page).to have_selector('.plan-details', visible: true)
  prices_per_month = all(:css, '.rate-per-month')
  details_per_month = all(:css, '.plan-details')
  expect(prices_per_month.length).to eq table.hashes.length
  expect(details_per_month.length).to eq table.hashes.length
  table.hashes.each do |row|
    expected_price = coin_per_region(country) + (row['priceCents'].to_f/100).to_s + ' per month'
    expected_pages = row['pages'].to_s + ' pages per month'
    expect(prices_per_month[i]).to have_content expected_price
    expect(details_per_month[i]).to have_content expected_pages
    i+=1
  end
end