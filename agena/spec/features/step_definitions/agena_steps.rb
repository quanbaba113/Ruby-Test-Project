#encoding: utf-8
include Request

Transform /^table:guid,pages,price_cents,currency,waiver,rollover,allow_plan_change_back$/ do |table|
  @table_columns = ["pages", "price_cents", "region", "incentiveMonths"]
  table.map_column!(:pages) {|pages| pages.to_i }
  table.map_column!(:priceCents) {|priceCents| priceCents.to_i }
  table.map_column!(:incentiveMonths) {|incentiveMonths| incentiveMonths.to_i }
  table
end

Transform /^table:guid,pages,priceCents,region,incentiveMonths$/ do |table|
  @table_columns = ["pages", "priceCents", "region", "incentiveMonths"]
  table.map_column!(:pages) {|pages| pages.to_i }
  table.map_column!(:priceCents) {|priceCents| priceCents.to_i }
  table.map_column!(:incentiveMonths) {|incentiveMonths| incentiveMonths.to_i }
  table
end

Transform /^table:guid,pages,price_cents,currency$/ do |table|
  @table_columns = ["pages", "price_cents", "currency"]
  table.map_column!(:pages) {|pages| pages.to_i }
  table.map_column!(:price_cents) {|price_cents| price_cents.to_i }
  table
end

Transform /^table:guid,pages,price_cents,currency,waiver,rollover,allow_plan_change_back$/ do |table|
  @table_columns = ["pages", "price_cents", "currency", "waiver", "rollover", "allow_plan_change_back"]
  table.map_column!(:pages) {|pages| pages.to_i }
  table.map_column!(:price_cents) {|price_cents| price_cents.to_i }
  table.map_column!(:waiver) {|waiver| waiver.to_i }
  table.map_column!(:rollover) {|rollover| rollover.to_i }
  table.map_column!(:allow_plan_change_back) {|allow_plan_change_back| allow_plan_change_back == "true" ? true : false }
  table
end

Transform /^table:unit,amount,plan$/ do |table|
  @table_columns = ["unit", "amount", "plan"]
  table.map_column!(:amount) {|amount| amount.to_i }
  table
end

Transform /^table:plan_guid,amount$/ do |table|
  @table_columns = ["amount"]
  table.map_column!(:amount) {|amount| amount.to_i }
  table
end

Given(/^an agena client requests a new enrollment code for (.*) on (.*)$/) do |offer_name, environment|
  @environment = environment
  step "an agena client requests the offer with name #{offer_name} on #{environment}"
  step "the system requests a new enrollment code using the current offer on #{environment}"
  step "the system saves the current offer information if an enrollment code exists"
end

Given(/^an agena client requests the offer with name (.*) on (.*)$/) do |offer_name, environment|
  @environment = environment
  step "an agena client requests for all the offers on #{environment}"
  offers = @json.select { |offer_by_name| offer_by_name['name'] == offer_name }
  if offers.nil? or offers.length == 0
    fail "No offer found with name #{offer_name} after calling agena's /offers"
  elsif offers.length != 1
    fail "Multiple offers found with name #{offer_name} after calling agena's /offers"
  end
  @offers_eks = []
  @current_offer = offers[0]
end

Given(/^an agena client requests the offer with identifier (.*) on (.*)$/) do |offer_identifier, environment|
  @environment = environment
  step "an agena client requests for all the offers on #{environment}"
  offers = @json.select { |offer_by_identifier| offer_by_identifier['identifier'] == offer_identifier.to_i }
  if offers.nil? or offers.length == 0
    fail "No offer found with identifier #{offer_identifier} after calling agena's /offers"
  elsif offers.length != 1
    fail "Multiple offers found with identifier #{offer_identifier} after calling agena's /offers"
  end
  @offers_eks = []
  @current_offer = offers[0]
end

Given(/^an agena client requests for (.*) on (.*)$/) do |endpoint_raw, environment|
  @environment = environment
  endpoint = agena_map_str_to_endpoint(endpoint_raw)
  @response = get(stack: environment, endpoint: endpoint, v2: true)#/offers v2
  step "they're returned safelly"
  @json = JSON.parse(@response.body)
end

Given(/^an agena client uses all the (kit_only|kit_and_kitless) seeds promo codes on (.*)$/) do |type, environment|
  step "an agena client requests for all the promo codes on #{environment}"
  @json_temp = @json
  @json = []
  @promo_codes_validation_type = type
  @json_temp.each do |promo|
    if type == 'kit_and_kitless' or type == 'kitless_only'
      @json.push(promo) if AGENA_SEEDS_PROMO_CODES_VALIDATES_GUID_ONLY.include?(promo["code"] + ' ' + promo["region"])
    elsif type == 'kit_only'
      @json.push(promo) if AGENA_SEEDS_PROMO_CODES_VALIDATES_GUID_EK.include?(promo["code"] + ' ' + promo["region"])
    end
  end
end

Given(/^today's date is after (.*)$/) do |date|
  pending "Today's date is #{Date.today} and not after #{date}" unless Date.today > Date.parse(date)
end

When(/^they're returned safelly$/) do
  expect(@response.status).to eq 200
end

When(/^an agena client requests a new enrollment code using an offer with identifier (.*) on (.*)$/) do |identifier, environment|
  @environment = environment
  @response = post(stack: environment, endpoint: "codes/" + identifier)#/codes v1 is used by Gemini and AST to create a single EK
  if @response.status == 201
    @json = JSON.parse(@response.body)
    if @json.key?("posaCodes")
      @ek = @json["posaCodes"][0]["code"]
    else
      @ek = ""
    end
  else
    @ek = ""
  end
end

When(/^an agena client requests a new enrollment code using an offer with identifier (.*) and plan guid (.*) on (.*)$/) do |identifier, guid, environment|
  @environment = environment
  @response = post(stack: environment, endpoint: "codes/", v2:true, payload:"plan_guid=#{guid}&offer_id=#{identifier}")#/codes v2
  if @response.status == 201
    @json = JSON.parse(@response.body)
    @ek = @json["code"]
  else
    @ek = ""
  end
end

When(/^an agena client requests a new enrollment code based on each offer on(.*)$/) do |environment|
  internal_log("Starting the request for all offers")
  @environment = environment
  step "an agena client requests for all the offers on #{environment}"
  internal_log("Ended the request for all offers and starting to create enrollment codes")
  @offers_eks = {}
  @all_offers = @json
  AGENA_SEEDS_DISTINCT_OFFERS_BY_NAME.each do |seeds_offer_name|
    offer = @all_offers.find{ |offer_by_name| offer_by_name['name'] == seeds_offer_name }
    if not offer.nil?
      @current_offer = offer
      step "the system requests a new enrollment code using the current offer on #{environment}"
      step "the system saves the current offer information if an enrollment code exists"
    end
  end
  internal_log("ended the creation of all enrollment codes")
end

When(/^an agena client requests a new enrollment code based on each offer on (.*) in the same way AST does$/) do |environment|
  internal_log("Starting the request for all offers")
  @environment = environment
  step "an agena client requests for all the offers on #{environment}"
  internal_log("Ended the request for all offers and starting to create enrollment codes")
  @offers_eks = {}
  @all_offers = @json
  AGENA_SEEDS_DISTINCT_OFFERS_BY_NAME.each do |seeds_offer_name|
    offer = @all_offers.find{ |offer_by_name| offer_by_name['name'] == seeds_offer_name }
    if not offer.nil?
      @current_offer = offer
      step "the system requests a new enrollment code using the current offer on #{environment} in the same way AST does"
      step "the system saves the current offer information if an enrollment code exists"
    end
  end
  internal_log("Ended the creation of all enrollment codes")
end

When(/^an agena client requests enrollment codes based on an offer from (.*) on (.*) in the same way AST does$/) do |region, environment|
  internal_log("starting the request for all offers")
  @environment = environment
  @region = region
  step "an agena client requests for all the offers on #{environment}"
  internal_log("Ended the request for all offers and starting to create enrollment codes")
  @offers_eks = {}
  @all_offers = @json
  count = AGENA_SEEDS_DISTINCT_OFFERS_BY_NAME.length#use it for testing purposes if you want to check a single EK or just 10 of them
  AGENA_SEEDS_DISTINCT_OFFERS_BY_NAME.each do |seeds_offer_name|
    offer = @all_offers.find{ |offer_by_name| offer_by_name['name'] == seeds_offer_name }
    if count > 0 and not offer.nil?
      next unless region == agena_extract_plans_region_info(offer)
      @current_offer = offer
      step "the system requests a new enrollment code using the current offer on #{environment}"
      step "the system saves the current offer information if an enrollment code exists"
      count -= 1
    end
  end
  internal_log("Ended the creation of all enrollment codes")
end

When(/^an agena client retrieves the promo code (.*) on (.*)$/) do |promo_code, environment|
  step "an agena client requests for all the promo codes on #{environment}"
  @all_promo_codes = @json
  @current_promo_code = @all_promo_codes.find{ |promo_by_code| promo_by_code['code'] == promo_code}
  fail "No promo code found with code as #{promo_code}" if @current_promo_code.nil?
end

When(/^a promo code (start|end) date is (before|after) today$/) do |is_start, is_before|
  @promo_codes_to_validate = []
  @json.each do |promo|
    to_validate = {}
    add = false
    if is_start == "start" and is_before == "before"
      add = Date.parse(promo['start_date']) < Date.today
    elsif is_start == "start" and is_before == "after"
      add = Date.parse(promo['start_date']) > Date.today
    elsif is_start == "end" and is_before == "before"
      add = Date.parse(promo['end_date']) < Date.today
    elsif is_start == "end" and is_before == "after"
      add = Date.parse(promo['end_date']) > Date.today
    end

    if add and promo['promo_plan_incentives'].length > 0
      to_validate['code'] = promo['code']
      to_validate['region'] = promo['region']
      to_validate['guid'] = agena_guid_by_title(promo['promo_plan_incentives'][0]['plan'], promo['region'])
      @promo_codes_to_validate.push(to_validate)
    end
  end
end

When(/^a promo code start and end dates are good ones compared to today$/) do
  @promo_codes_to_validate = []
  @json.each do |promo|
    if Date.parse(promo['start_date']) < Date.today and Date.parse(promo['end_date']) > Date.today - 1 and promo['promo_plan_incentives'].length > 0
      to_validate = {}
      to_validate['code'] = promo['code']
      to_validate['region'] = promo['region']
      begin
        to_validate['guid'] = agena_guid_by_title(promo['promo_plan_incentives'][0]['plan'], promo['region'])
      rescue
      end
      @promo_codes_to_validate.push(to_validate)
    end
  end
end

When(/^each enrollment code is used on Gemini for the current region$/) do
  @fail_message = ''
  gemini_open_main_page(@environment, @region)
  step "each enrollment code is used on Gemini for region #{@region}"
end

When(/^each enrollment code is used on Gemini for region (.*)$/) do |region|
  internal_log("Starting to use all enrollment codes on Gemini")
  @offers_eks.each do |offer_identifier, data|
    if data['region'] == region
      begin
        @current_offer_ek_info = data
        step "the system clicks on enroll button on responsive or non-responsive flow"
        step "the system sign up the user on non responsive flow if needed"
        step "the system uses the enrollment code and verify the plans on responsive or non-responsive flow"
        internal_log("#{offer_identifier} #{data['name']} OK")
      rescue Exception => e
        byebug
        @fail_message += "\n#{offer_identifier} #{data['name']} failed: " + e.message
        gemini_open_main_page(@environment, region)
      end
    end
  end
  gemini_non_responsive_logout_if_needed()
  internal_log("Ended the usage of all enrollment codes on Gemini")
end

Then(/^they're applied correctly, including with the correct plans$/) do
  if @fail_message.length > 0
    fail @fail_message
  end
end

Then(/^this promo code is marked as (.*)/) do |status|
  step "this #{@promo_codes_validation_type} promo code is marked as #{status}"
end

Then(/^this kit_only promo code is marked as (.*)/) do |status|
  step "an agena client requests for all the offers on #{@environment}"
  @all_offers = @json
  fail_message = ''
  @promo_codes_to_validate.each do |promo|

    offer_by_guid = agena_offers_find_by_plan_guid(@all_offers, promo['guid'])

    if offer_by_guid.nil?
      fail "No offer found for guid name #{promo['guid']} after calling agena's /offers "
    end
    step "an agena client requests a new enrollment code using an offer with identifier #{offer_by_guid['identifier']} on #{@environment}"
    fail unless @ek.length > 0

    endpoint = "promo_codes/#{promo['code']}/validate?plan_guid=#{promo['guid']}&signup_code=#{@ek}"
    response = get(stack: @environment, endpoint: endpoint, v2: true)
    json = JSON.parse(response.body)
    if json["state"] != status
      fail_message += "#{promo['code']} #{promo['region']} status was #{json["state"]} | "
    else
      internal_log("#{promo['code']} #{promo['region']} OK")
    end
  end
  if fail_message.length > 0
    fail fail_message
  end
end

Then(/^this kit_and_kitless promo code is marked as (.*)/) do |status|
  fail_message = ''
  @promo_codes_to_validate.each do |promo|
    endpoint = "promo_codes/#{promo['code']}/validate?plan_guid=" + promo['guid']
    response = get(stack: @environment, endpoint: endpoint, v2: true)
    json = JSON.parse(response.body)
    if json["state"] != status
      fail_message += "#{promo['code']} #{promo['region']} status was #{json["state"]} | "
    else
      internal_log("#{promo['code']} #{promo['region']} OK")
    end
  end
  if fail_message.length > 0
    fail fail_message
  end
end

Then(/^they're not empty$/) do
  expect(@response.body.length).to be > 0
end

Then(/^only one register is returned$/) do
  expect(@json.kind_of?(Array)).to be true
  expect(@json.length).to eq 1
end

Then(/^only one offer is returned$/) do
  step "only one register is returned"
end

Then(/^the gemini fields are all there$/) do
  #incentiveMonths is optional on plans
  #printerModels is optional on offers
  fail_message = agena_offers_response_validation(
      ["identifier", "name", "vendor", "isCommercial", "shipWelcomeKit", "allowAllPrinterModels", "offerType", "hasTrialPeriod", "additionalPaymentRequired", "plans"],
      ["guid", "sku", "region", "priceCents", "currency", "pages", "overageBlockPriceCents", "overageBlockSize", "description", "isDefault"]
  )
  if fail_message.length > 0
    fail fail_message
  end
end

Then(/^an enrollment code is returned for every offer$/) do

  fail_message = ''
  @offers_eks.each do |offer_identifier, data|
    ek = data['ek']
    if ek.length == 0
      fail_message += "\nNo EK returned for identifier #{offer_identifier}"
    end
  end

  if fail_message.length > 0
    fail fail_message
  end
end

Then(/^all the enrollment code state are (.*)$/) do |state|
  fail_message = ''
  internal_log("Starting to get status of every enrollment code generated")
  @offers_eks.each do |offer_identifier, data|
    ek = data['ek']
    endpoint = "codes/#{ek}"
    response = get(stack: @environment, endpoint: endpoint, v2: true)
    json = JSON.parse(response.body)
    if json["state"] != state
      fail_message += "\nEK returned with state #{json["state"]} for identifier #{offer_identifier}"
    end
  end
  internal_log("Ended to get status of every enrollment code generated")

  if fail_message.length > 0
    fail fail_message
  end
end

Then(/^all the below plans should be returned from the current offer, as follows:$/) do |table|
  fail_message = agena_plans_check(@current_offer, table, @table_columns)
  if fail_message.length > 0
    fail fail_message
  end
end

Then(/^all the below plans should be returned from agena only offer, as follows:$/) do |table|
  expect(@json.length).to eq 1
  fail_message = agena_plans_check(@json[0], table, @table_columns)
  if fail_message.length > 0
    fail fail_message
  end
end

Then(/^all the below plans should be returned from agena, as follows:$/) do |table|
  fail_message = agena_plans_check(@json, table, @table_columns)
  if fail_message.length > 0
    fail fail_message
  end
end

Then(/^'(.*)' is listed (with|without) a valid expiration date$/) do |promo_code, valid|
  promo = @json.find { |promo_by_name| promo_by_name['name'] == promo_code }
  if promo.nil?
    fail "No Promo Code found with name #{promo_code} after calling agena's /promo_code"
  end

  if valid == 'with' and (Date.parse(promo['start_date']) > Date.today or Date.parse(promo['end_date']) < Date.today - 1)
    fail "Promo Code #{promo_code} was expected to be valid but today-date #{Date.today} seems to be outside start_date #{promo['start_date']} and end_date #{promo['end_date']}"
  elsif valid == 'without' and Date.parse(promo['start_date']) <= Date.today and Date.parse(promo['end_date']) >= Date.today - 1
    fail "Promo Code #{promo_code} was expected to NOT be valid but today-date #{Date.today} seems to be inside start_date #{promo['start_date']} and end_date #{promo['end_date']}"
  end
end

Then(/^this promo code start date is (.*)$/) do |date|
  expect(Date.parse(@current_promo_code['start_date'])).to eq Date.parse(date)
end

Then(/^this promo code end date is (.*)$/) do |date|
  expect(Date.parse(@current_promo_code['end_date'])).to eq Date.parse(date)
end

Then(/^this promo code region is (.*)$/) do |region|
  expect(@current_promo_code['region']).to eq region
end

Then(/^this promo code state is (.*) when validated with all above plans/) do |state|
  fail_message = ""
  @promo_code_table.hashes.each do |row|
    endpoint = "promo_codes/#{@current_promo_code['code']}/validate?plan_guid=#{row['plan_guid']}"
    response = get(stack: @environment, endpoint: endpoint, v2: true)
    json = JSON.parse(response.body)
    if json["state"] != state
      fail_message += "#{@current_promo_code['code']} with guid #{row['guid']} actual state is #{json["state"]} and expected it to be #{state}\n"
    else
      puts "\n#{@current_promo_code['code']} with guid #{row['plan_guid']} OK"
    end
    fail_message += agena_promo_code_plans_incentives_check(json, @promo_code_table, @table_columns)
  end
  if fail_message.length > 0
    fail fail_message
  end
end

Then(/^all the below plans should be returned from the promo code, as follows:$/) do |table|
  @promo_code_table = table
  fail_message = agena_promo_code_plans_check(@current_promo_code, table, @table_columns)
  if fail_message.length > 0
    fail fail_message
  end
end

Then(/^all the below plans details should be returned from the promo code validation, as follows:$/) do |table|
  @promo_code_table = table
end

Then(/^count offer names$/) do
  @all_offers = @json
  @offer_names_count = {}
  @all_offers.each do |offer|
    if @offer_names_count.key?(offer['name'])
      @offer_names_count[offer['name']] += 1
    else
      @offer_names_count[offer['name']] = 1
    end
  end
end

Then(/^list all the offers with duplicated names$/) do
  step "count offer names"
  offer_count = 0
  @offer_names_count.each do |offer, count|
    if count > 1
      puts "Duplicated offer: #{offer}\n"
      offer_count += 1
    end
  end
  puts "Duplicated offer count = #{offer_count}"
end

Then(/^list all the offers with unique names$/) do
  step "count offer names"
  offer_count = 0
  @offer_names_count.each do |offer, count|
    if count == 1
      puts "Unique offer: #{offer}\n"
      offer_count += 1
    end
  end
  puts "Unique offer count = #{offer_count}"
end