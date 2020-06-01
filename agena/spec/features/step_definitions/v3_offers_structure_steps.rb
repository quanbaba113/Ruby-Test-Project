require 'json'

REMOVED_FIELDS_LISTS_V3_OFFER = ["identifier", "hasTrialPeriod", "prepaidAmount", "currency", "isTaxPaid", "additionalPaymentRequired", "allowAllPrinterModels"]
REMOVED_FIELDS_LISTS_V3_PLAN = ["sku", "isDefault", "incentiveMonths"]
REMOVED_FIELDS_LISTS_V3_CODES = ["offerNumber", "currency", "offerType", "hasTrialPeriod", "welcomeKit", "additionalPaymentRequired", "promo_code", "plans", "default_plans"]

Given(/^a v2 offer is read from file (.*)$/) do |file|
  items = File.read(file)
  @current_offer = JSON.parse(items)
end

Given(/^a v2 enrollment code status is read from file (.*)$/) do |file|
  items = File.read(file)
  @current_ek_status = JSON.parse(items)
end

Then(/^the payload of this offer is shown on console$/) do
  @current_json_to_output = @current_offer
  step "output json on section v2 offer #{@current_offer['name']}"
end

Then(/^the payload of this enrollment code status is shown on console$/) do
  @current_json_to_output = @current_ek_status
  step "output json on section v2 enrollment_kit_codes/get_enrollment_kit_information #{@current_ek_status['code']}"
end

Then(/^output json on section (.*)$/) do |section_message|
  puts "> #{section_message}"
  puts ""
  puts JSON.pretty_generate(@current_json_to_output)
  puts ""
end

Then(/^the payload for v3 offers\/:offer_sku is shown on console$/) do
  step "convert current v2 offer to v3 offer"
  @current_json_to_output = @current_v3_offer
  step "output json on section v3 offers/:offer_sku #{@current_offer['name']}"
end

Then(/^the payload for v3 offers\/signup\/enrollment_key\/:enrollment_key is shown on console$/) do
  step "convert current v2 offer to v3 offer"
  @current_offer["plans"].each do |p|
    @current_v2_plan = p
    step "extract lups incentives from v2 plan if needed"
    step "extract hups incentives from v2 plan if needed"
  end
  step "extract trial period incentives if needed"
  step "extract promo code incentive from enrollment code if needed"
  @current_v3_offer["incentives"] = @current_v3_incentives
  @current_json_to_output = @current_v3_offer
  step "output json on section v3 offers/:offer_sku #{@current_offer['name']}"
end

Then(/^convert current v2 offer to v3 offer$/) do
  @current_v3_offer = {
      "offer_sku" => "ABC123"
  }
  @current_offer.each do |key, data|
    if not REMOVED_FIELDS_LISTS_V3_OFFER.include? key
      if key == "offerType"
        @current_v3_offer["type"] = data
      elsif key == "vendor"
        @current_v3_offer["retailer"] = data
      elsif key == "shipWelcomeKit" and @current_offer[key] == "true"
        @current_v3_offer["kitShipment"] = "welcomeKit"
      elsif key == "shipWelcomeKit" and @current_offer[key] == "false"
        @current_v3_offer["kitShipment"] = "none"
      elsif key == "isCommercial" and @current_offer[key] == "true"
        @current_v3_offer["planType"] = "commercial"
      elsif key == "isCommercial" and @current_offer[key] == "false"
        @current_v3_offer["planType"] = "consumer"
      elsif key == "plans"
        @current_v3_offer["plans"] = []
        @current_offer[key].each do |p|
          @current_v2_plan = p
          step "convert current v2 plan to v3 plan"
          @current_v3_offer["plans"].push(@current_v3_plan)
        end
        @current_v3_offer["incentives"] = []
        @current_v3_incentives = []
        if @current_offer["offerType"] != "prepaid"
          @current_offer[key].each do |p|
            @current_v2_plan = p
            step "extract month incentives from v2 plan"
          end
        end
        @current_v3_offer["incentives"] = @current_v3_incentives
      else
        @current_v3_offer[key] = data
      end
    end
  end
end

Then(/^the payload for v3 codes\/:code is shown on console$/) do
  @current_v3_codes = {}

  if @current_offer["type"] == "prepaid"
    @current_v3_codes["type"] = "prepaid"
    @current_v3_codes["currency"] = @current_offer["currency"]
    @current_v3_codes["additionalPaymentRequired"] = @current_offer["additionalPaymentRequired"]
    @current_v3_codes["isTaxPaid"] = @current_offer["isTaxPaid"]
  else
    @current_v3_codes["type"] = "enrollment"
  end

  @current_ek_status.each do |key, data|
    if not REMOVED_FIELDS_LISTS_V3_CODES.include? key
      @current_v3_codes[key] = data
    end
  end

  @current_json_to_output = @current_v3_codes
  step "output json on section v3 codes/:code #{@current_v3_codes['code']}"
end

Then(/^convert current v2 plan to v3 plan$/) do
  @current_v3_plan = {}
  @current_v2_plan.each do |key, data|
    if not REMOVED_FIELDS_LISTS_V3_PLAN.include? key
      @current_v3_plan[key] = data
    end
  end
end

Then(/^the payload for v3 plans for every plan is shown on console$/) do
  @current_offer["plans"].each do |p|
    @current_v2_plan = p
    step "convert current v2 plan to v3 plan"
    @current_json_to_output = @current_v3_plan
    step "output json on section v3 plans/:guid #{p['guid']}"
  end
end

Then(/^extract month incentives from v2 plan$/) do
  v3_months_incentive = {}
  v3_months_incentive["guid"] = @current_v2_plan["guid"]
  v3_months_incentive["name"] = "incentiveMonths"
  v3_months_incentive["months"] = @current_v2_plan["incentiveMonths"]
  @current_v3_incentives.push(v3_months_incentive)
end

Then(/^extract lups incentives from v2 plan if needed$/) do
  if @current_v2_plan["priceCents"] == 99 and @current_v2_plan["pages"] == 15
    v3_lups_incentive = {}
    v3_lups_incentive["guid"] = @current_v2_plan["guid"]
    v3_lups_incentive["name"] = "lups-trial"
    v3_lups_incentive["months"] = 3
    @current_v3_incentives.push(v3_lups_incentive)
  end
end

Then(/^extract hups incentives from v2 plan if needed$/) do
  if @current_v2_plan["pages"] == 500
    v3_hups_incentive = {}
    v3_hups_incentive["guid"] = @current_v2_plan["guid"]
    v3_hups_incentive["name"] = "hups-trial"
    v3_hups_incentive["pages"] = 500
    v3_hups_incentive["rollover"] = true
    @current_v3_incentives.push(v3_hups_incentive)
  end
end

Then(/^extract trial period incentives if needed$/) do
  if @current_offer["hasTrialPeriod"]
    @current_offer["plans"].each do |p|
      v3_xmod__incentive = {}
      v3_xmod__incentive["guid"] = p["guid"]
      v3_xmod__incentive["name"] = "xmod-trial"
      v3_xmod__incentive["months"] = 6
      @current_v3_incentives.push(v3_xmod__incentive)
    end
  end
end

Then(/extract promo code incentive from enrollment code if needed$/) do
  if @current_ek_status and @current_ek_status.key? "promo_code"
    @current_offer["plans"].each do |p| #yeah, I'm assuming the promo code will apply to all plans, ever
      v3_promo__incentive = {}
      v3_promo__incentive["guid"] = p["guid"]
      v3_promo__incentive["name"] = @current_ek_status['promo_code']['code']
      v3_promo__incentive["months"] = 1
      @current_v3_incentives.push(v3_promo__incentive)
    end
  end
end