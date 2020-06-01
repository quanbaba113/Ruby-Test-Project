#encoding: utf-8
include Request

def new_offer_extract_gemini_plans_info(offer)
  plans = []
  offer['plans'].each do |p|
    price = p['priceCents'].to_i == 0? "FREE" : p['priceCents']
    incentives = p.key?('incentiveMonths') ? p['incentiveMonths'].to_s : "0"
    plans.push({'guid' => p['guid'], 'pages' => p['pages'], 'priceCents' => price, 'originalPriceCents' => p['priceCents'], 'incentives' => incentives})
  end
  plans
end

def new_offer_extract_oobe_plans_info(offer_type, offer)
  plans = {}
  offer['plans'].each do |p|
    price = p['price_cents'].to_i == 0? "FREE" : p['price_cents']
    incentives = "0"
    if offer_type == "purchased"
      incentives = p['enrollment_kit_offer_purchased_months'].to_s
    elsif offer_type == "free"
      incentives = p['enrollment_kit_offer_free_months'].to_s
    end
    plans[p['guid']] = {'guid' => p['guid'], 'pages' => p['pages'], 'priceCents' => price, 'originalPriceCents' => p['price_cents'], 'incentives' => incentives}
  end
  plans
end

def new_offer_extract_plans_region_info(offer)
  if offer['plans'].length > 0
    region = offer['plans'][0]['region']
    offer['plans'].each do |p|
      if p['region'] != region
        fail "Plans regions should be the same, but offer #{offer['identifier']} doesn't follow this rule"
      end
    end
  else
    puts "Beware, offer #{offer['identifier']} has 0 plans!"
    region = ''
  end
  region
end

def new_offer_rand_string()
  return Time.now.inspect.split('+')[0].gsub(/\s/,'').gsub(/-/, '').gsub(/:/,'')+"#{rand(100)}"
end

def new_offer_oobe_plans_check(offer_type, offer, expected_plans)
  fail_message = ""
  actual_plans = new_offer_extract_oobe_plans_info(offer_type, offer)
  expected_plans.each do |row|
    expected = row['pages'].to_s + "_" + row['priceCents'].to_s + "_" + row['guid'].to_s + "_" + row['incentives'].to_s
    data = "<none>"
    if actual_plans.key?(row['guid'])
      data = actual_plans[row['guid']]['pages'].to_s + "_" + actual_plans[row['guid']]['priceCents'].to_s + "_" + actual_plans[row['guid']]['guid'].to_s + "_" + actual_plans[row['guid']]['incentives'].to_s
    end
    if expected == data
      puts "Plans as Expected (<page>_<price>_<guid>_<incentives>) => #{expected}"
    else
      fail_message += "Expected => #{expected}\n Actual => #{data}\n"
    end
  end
  fail_message
end

def new_offer_gemini_plan_page_check(data_array)
  expect(page).to have_css '.plan-selector'
  new_offer_internal_gemini_plans_array_check('.plan-info', data_array)
end

def new_offer_gemini_non_responsive_plan_page_check(data_array)
  expect(page).to have_css '#select-plan'
  new_offer_internal_gemini_plans_array_check(".plan-details:not(.grayed-out)", data_array)
end

def new_offer_gemini_plan_page_select(index)
  expect(index).to be >= 0
  elements = all(".responsive-blue-button.select")
  elements[index].click
  internal_wait_for_ajax
end

def new_offer_gemini_non_responsive_plan_page_select(index)
  expect(index).to be >= 0
  elements = all(".plan-input.radio")
  elements[index].click
end

def new_offer_internal_gemini_plans_array_check(selector, data_array)
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
  puts "Plans as expected (<pages>_<priceCents>): #{elements_expected}"
end

Given(/^an agena client requests a new enrollment code using the given offer on the given environment$/) do
  step "an agena client requests the given offer on a given environment"
  step "an agena client requests a new enrollment code using an offer with identifier #{@current_offer['identifier']} on #{ENV['environment']}"
end

Given(/^an agena client requests new enrollment codes for all the plans using the given offer on the given environment$/) do
  step "an agena client requests the given offer on a given environment"
  @current_offer_plans = new_offer_extract_gemini_plans_info(@current_offer)
  @all_generated_eks = []
  @current_offer_plans.length.times do
    step "an agena client requests a new enrollment code using an offer with identifier #{@current_offer['identifier']} on #{ENV['environment']}"
    @all_generated_eks.push(@ek)
    puts "EK: #{@ek}"
  end
end

Given(/^an agena client requests the given offer on a given environment$/) do
  fail "We need environment!" unless ENV['environment']
  puts "Given environment: #{ENV['environment']}"

  if ENV['eks']
    endpoint = "codes/" + ENV['eks']
    response = get(stack: ENV['environment'], endpoint: endpoint, v2: true)
    json = JSON.parse(response.body)
    step "an agena client requests the offer with identifier #{json['offerNumber']} on #{ENV['environment']}"
  else
    fail "We need new offer name!" unless ENV['new offer name']
    puts "Given offer: #{ENV['new offer name']}"
    step "an agena client requests the offer with name #{ENV['new offer name']} on #{ENV['environment']}"
  end
end

Given(/^the printers characteristics$/) do
  pending "We need printer!" unless ENV['printer']
  puts "Given printer: #{ENV['printer']}"
  pending "We need serial number!" unless ENV['serial number']
  puts "Given serial number: #{ENV['serial number']}"
  pending "We need classification!" unless ENV['classification']
  puts "Given classification: #{ENV['classification']}"
  @printer_serial_number = ENV['serial number']
  @printer_model_number = ENV['printer']
  @printer_jump_id = "easystartwin_oobe_ows_" + ENV['printer']
  @printer_classification = ENV['classification']
end

Given(/^the default model number (.*) is used$/) do |model|
  @printer_serial_number = new_offer_rand_string()
  @printer_model_number = model
  @printer_jump_id = "easystartwin_oobe_ows_" + model
end

When(/^a gemini client uses an enrollment code/) do
  @uses_an_ek = true
end

When(/^system: a gemini client uses an enrollment code/) do
  step "an #{@region} gemini user opens the landing page on #{@environment}"

  if gemini_main_page_sign_up_is_possible()
    gemini_main_page_sign_up()
    @is_on_responsive_flow = true
  else
    gemini_non_responsive_main_page_sign_up()
    @is_on_responsive_flow = false
  end

  if gemini_non_responsive_sign_up_is_possible()
    gemini_non_responsive_sign_up(@region, @environment)
    @is_on_responsive_flow = false
  end

  if @is_on_responsive_flow
    gemini_plan_page_enter_ek(@all_generated_eks[@current_plan_index])
  else
    gemini_non_responsive_plan_page_enter_ek(@all_generated_eks[@current_plan_index])
  end
end

Then(/^incentives or cents amount are obtained from the success message$/) do
  @ek_success_message_check = true
end

Then(/^system: incentives or cents amount are obtained from the success message$/) do
  @message_to_check = ''
  if @current_offer['offerType'] == 'purchased'
    @message_to_check = @current_plan['incentives']
  elsif @current_offer['offerType'] == 'prepaid'
    @message_to_check = @current_offer['prepaidAmount'].to_s
  end

  if @is_on_responsive_flow
    if @current_offer['offerType'] == "prepaid" or @current_offer['offerType'] == "purchased"
      gemini_enrollment_page_check_success_balance_continue(@message_to_check)
    else
      gemini_enrollment_page_check_success_continue(@message_to_check)
    end
  else
    if @current_offer['offerType'] == "prepaid" or @current_offer['offerType'] == "purchased"
      gemini_non_responsive_check_success_balance_ek(@message_to_check)
    else
      gemini_non_responsive_check_success_ek(@message_to_check)
    end
  end
end

Then(/^the correct plans are shown on the plans page$/) do
  @plan_step_check = true
end

Then(/^system: the correct plans are shown on the plans page$/) do
  #Checks plans page and select one of them, if the offer has more than one plan
  if @current_offer_plans.length > 1
    if @is_on_responsive_flow
      new_offer_gemini_plan_page_check(@current_offer_plans)
      new_offer_gemini_plan_page_select(@current_plan_index)
    else
      new_offer_gemini_non_responsive_plan_page_check(@current_offer_plans)
      new_offer_gemini_non_responsive_plan_page_select(@current_plan_index)
    end
  end
end

Then(/^each plan pages and prices are shown correctly on the summary page$/) do
  @plan_page_price_summary_check = true
end

Then(/^system: each plan pages and prices are shown correctly on the summary page$/) do
  if @environment == "test1" or @environment == "pie1"
    step "the enroll continues successfully with default printer and credit card"
    step "the summary for that offer should contain #{@current_plan['pages']} pages per month and the amount of #{@current_plan['priceCents']} cents"
  end
end

Then(/^the incentives are listed correctly on the summary page$/) do
  @incentives_summary_check = true
end

Then(/^system: the incentives are listed correctly on the summary page$/) do
  if @environment == "test1" or @environment == "pie1"
    if @current_offer['offerType'] == "prepaid"
      step "the summary for that offer should contain #{@message_to_check} prepaid cents due to enrollment key"
    else
      step "the summary for that offer should contain #{@current_plan['incentives']} free months due to enrollment key"
    end
  end
end

Then(/^system: thank you page is shown$/) do
  if @environment == "test1" or @environment == "pie1"
    step "the enroll should end successfully on 'Thank You' page"
  end
end

Then(/^thank you page is shown$/) do
  @region = new_offer_extract_plans_region_info(@current_offer)
  plan_index = 0
  @current_offer_plans.each do |plan|
    @current_plan = plan
    @current_plan_index = plan_index
    if @uses_an_ek
      step "system: a gemini client uses an enrollment code"
    end
    if @ek_success_message_check
      step "system: incentives or cents amount are obtained from the success message"
    end
    if @plan_step_check
      step "system: the correct plans are shown on the plans page"
    end
    if @plan_page_price_summary_check
      step "system: each plan pages and prices are shown correctly on the summary page"
    end
    if @incentives_summary_check
      step "system: the incentives are listed correctly on the summary page"
    end
    step "system: thank you page is shown"
    plan_index += 1
    page.driver.quit
    page.driver.switch_to_window(page.driver.current_window_handle)
  end
end

When(/^a gemini client performs a full enrollment flow which each plan$/) do
  @region = new_offer_extract_plans_region_info(@current_offer)
  plan_index = 0
  @current_offer_plans.each do |plan|
    @current_plan = plan
    @current_plan_index = plan_index
    step "a gemini client uses an enrollment code"
    step "incentives or cents amount are obtained from the success message"
    step "the correct plans are shown on the plans page"
    step "each plan pages and prices are shown correctly on the summary page"
    step "the incentives are listed correctly on the summary page"
    step "no errors are found"
    plan_index += 1
    page.driver.quit
    page.driver.switch_to_window(page.driver.current_window_handle)
  end
end

When(/^an agena client enrolls that printer using OOBE flow$/) do
  @printer_country = new_offer_extract_plans_region_info(@current_offer)
  @printer_language = ''
  step "an agena client enrolls that printer using OOBE flow on #{@environment}"
end

When(/^an agena client get the offers for that printer and enrollment code using OOBE flow$/) do
  step "an agena client get the offers for that printer and enrollment code using OOBE flow on #{@environment}"
  @oobe_offer = @json
end

When(/^an agena client get the offers for that printer using OOBE flow$/) do
  step "an agena client get the offers for that printer using OOBE flow on #{@environment}"
end

Then(/^printer classification should match the given classification on the oobe response$/) do
  step "printer classification should be #{@printer_classification} on the response"
end

Then(/^all the plans from the given offer should be returned from agena on the oobe response$/) do
  offer_plans = new_offer_extract_gemini_plans_info(@current_offer)

  @oobe_offer['plans'].each do |p|
    puts "Guid/Pages/Price/EK_Incentives_Purchased/EK_Incentives_Free: " + ([p["guid"], p["pages"], p["price_cents"], p["enrollment_kit_offer_purchased_months"], p["enrollment_kit_offer_free_months"]].join("_"))
  end

  fail_message = new_offer_oobe_plans_check(@current_offer['offerType'], @oobe_offer, offer_plans)
  if fail_message.length > 0
    fail fail_message
  end
end

Then(/^the plans are shown as expected$/) do
  @current_offer['plans'].each do |p|
    puts "Guid/Pages/Price/Incentives: " + ([p["guid"], p["pages"], p["priceCents"], p["incentiveMonths"]].join("_"))
  end
end