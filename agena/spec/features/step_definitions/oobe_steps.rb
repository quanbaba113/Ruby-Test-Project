
Transform /^table:pages,priceCents$/ do |table|
  @table_columns = ["pages", "priceCents"]
  table.map_column!(:pages) {|pages| pages.to_i }
  table
end

Given(/^model number (.*) belongs to a (.*) printer on (.*)$/) do |model_number, classification, country|
  @printer_model_number = model_number
  @printer_classification = classification
  if country.include? '/'
    @printer_country = country.split('/')[0]
    @printer_language = country.split('/')[1]
  else
    @printer_country = country
    @printer_language = ''
  end
end

Given(/^model number (.*), the serial number (.*) and the jump ID (.*) belongs to a (.*) printer on (.*)$/) do |model_number, serial_number, jump_id, classification, country|
  @printer_model_number = model_number
  @printer_serial_number = serial_number
  @printer_jump_id = jump_id
  @printer_classification = classification
  if country.include? '/'
    @printer_country = country.split('/')[0]
    @printer_language = country.split('/')[1]
  else
    @printer_country = country
    @printer_language = ''
  end
end

Given(/^the model number (.*) and the jump ID (.*) belongs to a (.*) printer on (.*)$/) do |model_number, jump_id, classification, country|
  @printer_model_number = model_number
  @printer_serial_number = internal_rand_string()
  @printer_jump_id = jump_id
  @printer_classification = classification
  @printer_country = country
end

Given(/^this printer is used on OOBE simulator for (.*)$/) do |environment|
  oobe_open_simulator(environment, @printer_country, @printer_language, @printer_serial_number, @printer_model_number, @printer_jump_id)
end

When(/^the user enrolls with that printer$/) do
  if @printer_classification == "XMOC"
    click_on "XMOC"
    internal_wait_for_ajax
    find('#btn-activate').click()
    internal_wait_for_ajax
  #elsif @printer_classification == "XMO2"
  #  oobe_xmod_flow_start()
  else
    puts "Printer classification #{@printer_classification} need to be coded yet"
    pending
  end
end

When(/^an agena client enrolls that printer using OOBE flow on (.*)$/) do |environment|
  @environment = environment
  endpoint = "oobe_registrations"
  payload = {
      "serial_number" => "#{@printer_serial_number}",
      "model_number" => "#{@printer_model_number}",
      "country" => "#{@printer_country}",
      "jump_id" => "#{@printer_jump_id}",
      "sku" => "",
      "ink_declaration" => "",
      "supply_types" => "",
      "supply_levels" => "",
      "supply_states" => "",
      "unenrolled_pages" => ""
  }
  @response = post(stack: environment, endpoint: endpoint, v2: true, payload: payload, headers: {"Content-Type" => "application/json"})#/oobe_registrations
  fail @response.body + " obtained and not expected." if @response.body != "Printer successfully registered" && @response.body != "Printer is already registered"
end

When(/^an agena client get the offers for that printer using OOBE flow on (.*)$/) do |environment|
  @environment = environment
  endpoint = "oobe_registrations/offers"
  endpoint += "?serial_number=#{@printer_serial_number}"
  endpoint += "&model_number=#{@printer_model_number}"
  endpoint += "&country=#{@printer_country}"
  endpoint += "&jump_id=#{@printer_jump_id}"
  @response = get(stack: environment, endpoint: endpoint, v2: true)#/oobe_registrations/offers v2
  @json = JSON.parse(@response.body)
end

When(/^an agena client get the offers for that printer and enrollment code using OOBE flow on (.*)$/) do |environment|
  @environment = environment
  fail unless @ek.length > 0
  endpoint = "oobe_registrations/offers"
  endpoint += "?serial_number=#{@printer_serial_number}"
  endpoint += "&model_number=#{@printer_model_number}"
  endpoint += "&country=#{@printer_country}"
  endpoint += "&jump_id=#{@printer_jump_id}"
  endpoint += "&enrollment_kit=#{@ek}"
  @response = get(stack: environment, endpoint: endpoint, v2: true)#/oobe_registrations/offers v2
  @json = JSON.parse(@response.body)
end

When(/^an agena client retrieves that printer incentives using OOBE API on (.*)$/) do |environment|
  @environment = environment
  endpoint = "/oobe_registrations/printer_benefits?query=#{@printer_model_number}&country=#{@printer_country}"
  @response = get(stack: environment, endpoint: endpoint, v2: true)#/oobe_registrations/printer_benefits v2
  @json = JSON.parse(@response.body)
end

When(/^the ones with model number are used on OOBE flow$/) do
  @printer_skus = {}
  @defaults_per_region = {}
  @all_offers = @json
  @all_offers.each do |offer|
    if offer.key? 'printerModels' and offer['printerModels'].length > 0
      offer_plans = agena_extract_gemini_plans_info(offer)
      region = agena_extract_plans_region_info(offer)
      if not @defaults_per_region.key? region
        step "an agena client requests for the default offers for #{region} customers on #{@environment}"
        @defaults_per_region[region] = agena_extract_gemini_plans_info(@json[0])
      end
      offer['printerModels'].each do |model|
        key = model['sku'] + " " + region
        @printer_skus[key] = @defaults_per_region[region] unless @printer_skus.include? key
        @printer_skus[key] = (@printer_skus[key] + offer_plans).uniq
      end
    end
  end
end

Then(/^all plans are returned correcly$/) do
  @printer_skus.each do |sku, plans|
    plans.each do |p|
      puts @environment, sku, [p['guid'],p['pages'],p['priceCents']].join("_"), "||"
    end
    #oobe_plans_check(offer, plans)#to the future, once we know what each printer expects to see on oobe
  end
end

Then(/^all the below offers should be seen on OOBE screen, as follows:$/) do |table|
  oobe_plan_page_check(table, @printer_country)
end

Then(/^the default plans are shown on the left$/) do
  oobe_plan_page_check_default_on_left(@printer_country)
end

Then(/^all the oobe fields should be present on the response$/) do
  fail_message = agena_single_offer_response_validation(
      @json,
      0,
      ["classification", "oobe_incentive_eligible", "enrollment_kit_incentive_eligible", "kit_shipment"],
      ["guid", "price_cents", "currency", "pages", "has_overage", "overage_block_price_cents", "overage_block_size", "oobe_incentive_free_months", "enrollment_kit_incentive_free_months", "enrollment_kit_offer_free_months", "enrollment_kit_offer_purchased_months"]
  )
  if fail_message.length > 0
    fail fail_message
  end
end

Then(/^all the oobe incentive fields should be present on the response$/) do
  step 'only one register is returned'
  fail_message = agena_printer_incentives_response_validation(@json[0])
  if fail_message.length > 0
    fail fail_message
  end
  @json = @json[0]
end

Then(/^printer classification should be (.*) on the response$/) do |expected_classification|
  expect(@json['classification']).to eq expected_classification
end

Then(/^no incentive should be on the response$/) do
  expect(@json['oobe_incentive_eligible']).to be false
  expect(@json['enrollment_kit_incentive_eligible']).to be false
end

Then(/^only oobe incentive should be on the response$/) do
  expect(@json['oobe_incentive_eligible']).to be true
  expect(@json['enrollment_kit_incentive_eligible']).to be false
end

Then(/^(\d+) months of printer incentive should be on the response$/) do |months_on_response|
  expect(@json['oobe_incentive_free_months']).to eq months_on_response.to_i
  expect(@json['enrollment_kit_incentive_free_months']).to eq 0
end

Then(/^no printer incentive should be on the response$/) do
  step "0 months of printer incentive should be on the response"
end

Then(/^printer incentive days should be (\d+)$/) do |expected_incentive_days|
  expect(@json['oobe_incentive_eligibility_days']).to eq expected_incentive_days.to_i
end

