
Then(/^the system saves the current offer information if an enrollment code exists$/) do
  fail if @current_offer.nil?
  if @ek.length > 0
    amount = @current_offer.key?('prepaidAmount') ? @current_offer['prepaidAmount'] : ''
    @offers_eks[@current_offer['identifier']] = { 'ek' => @ek,
                                                  'name' => @current_offer['name'],
                                                  'plans' => agena_extract_gemini_plans_info(@current_offer),
                                                  'region' => agena_extract_plans_region_info(@current_offer),
                                                  'type' => @current_offer['offerType'],
                                                  'amount' => amount}
  else
    puts "\n#{@current_offer['identifier']} #{@current_offer['name']} failed to generate an enrollment code"
  end
end

Then(/^the system requests a new enrollment code using the current offer on (.*)$/) do |environment|
  fail if @current_offer.nil?
  step "an agena client requests a new enrollment code using an offer with identifier #{@current_offer['identifier']} on #{environment}"
end

Then(/^the system requests a new enrollment code using the current offer on (.*) in the same way AST does$/) do |environment|
  fail if @current_offer.nil?
  step "an agena client requests a new enrollment code using an offer with identifier #{@current_offer['identifier']} and plan guid #{@current_offer['plans'][0]['guid']} on #{environment}"
end

Then(/^the system clicks on enroll button on responsive or non-responsive flow$/) do
  if gemini_main_page_sign_up_is_possible()
    gemini_main_page_sign_up()
    @is_on_responsive_flow = true
  elsif
    gemini_non_responsive_main_page_sign_up()
    @is_on_responsive_flow = false
  end
end

Then(/^the system sign up the user on non responsive flow if needed$/) do
  fail "No @current_offer_ek_info to hold region data" if @current_offer_ek_info.nil?
  if gemini_non_responsive_sign_up_is_possible
    gemini_non_responsive_sign_up(@current_offer_ek_info['region'], @environment)
    @is_on_responsive_flow = false
  else
    @is_on_responsive_flow = true
  end
end

Then(/^the system uses the enrollment code and verify the plans on responsive or non-responsive flow$/) do
  fail if @current_offer_ek_info.nil?
  @is_on_responsive_flow = gemini_plan_page_is_responsive()
  if @message_to_check.nil?
    @message_to_check = ''
  end
  if @is_on_responsive_flow
    step "the system uses the enrollment code and verify the plans on responsive flow"
  else
    step "the system uses the enrollment code and verify the plans on non-responsive flow"
  end
end

Then(/^the system uses the enrollment code and verify the plans on responsive flow$/) do
  fail if @current_offer_ek_info.nil?

  gemini_plan_page_enter_ek(@current_offer_ek_info['ek'])
  step "the system verify the enrollment code success message on responsive flow"

  #purchased offers or others with one plan go straight to login screen
  if @current_offer_ek_info['type'] != "purchased" and @current_offer_ek_info['plans'].length > 1
    gemini_plan_page_check(@current_offer_ek_info['plans'])
  end
  gemini_open_main_page(@environment, @current_offer_ek_info['region'])
end

Then(/^the system verify the enrollment code success message on responsive flow$/) do
  if @current_offer_ek_info['type'] == "prepaid"
    gemini_enrollment_page_check_success_balance_continue(@current_offer_ek_info['amount'].to_s)
  else
    gemini_enrollment_page_check_success_continue(@message_to_check)
  end
end

Then(/^the system uses the enrollment code and verify the plans on non-responsive flow$/) do
  fail if @current_offer_ek_info.nil?
  gemini_non_responsive_plan_page_enter_ek(@current_offer_ek_info['ek'])
  gemini_non_responsive_plan_page_check(@current_offer_ek_info['plans'])
  step "the system verify the enrollment code success message on non-responsive flow and go back"
end

Then(/^the system verify the enrollment code success message on non-responsive flow and go back$/) do
  fail if @current_offer_ek_info.nil?
  if @current_offer_ek_info['type'] == "prepaid"
    gemini_non_responsive_check_success_balance_ek_back(@current_offer_ek_info['amount'].to_s)
  else
    gemini_non_responsive_check_success_ek_back(@message_to_check)
  end
end

Then(/^the system verify the enrollment code success message on non-responsive flow$/) do
  fail if @message_to_check.nil? or @message_to_check.length == 0
  if @current_offer_ek_info['type'] == "prepaid"
    gemini_non_responsive_check_success_balance_ek(@message_to_check)
  else
    gemini_non_responsive_check_success_ek(@message_to_check)
  end
end