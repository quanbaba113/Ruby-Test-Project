
Transform /^table:pages,priceCents$/ do |table|
  @table_columns = ["pages", "priceCents"]
  table.map_column!(:pages) {|pages| pages.to_i }
  table
end

Given(/^an (.*) gemini user opens the landing page on (.*)$/) do |region, environment|
  gemini_open_main_page(environment, region)
  @environment = environment
  @region = region
end

Given(/^a gemini user expects to see the message '(.*)' on a successful usage of it$/) do |message|
  @success_ek_message = message
end

Given(/^wants to see expected plans on a successful usage of it$/) do
  @check_expected_plans = true
end

When(/^uses the enrollment code received$/) do
  @current_offer_ek_info = @offers_eks[@current_offer['identifier']]
  step "the system clicks on enroll button on responsive or non-responsive flow"
  step "the system sign up the user on non responsive flow if needed"
  if @is_on_responsive_flow
    gemini_plan_page_enter_ek(@current_offer_ek_info['ek'])
  else
    gemini_non_responsive_plan_page_enter_ek(@current_offer_ek_info['ek'])
  end
end

When(/^uses the enrollment code received successfully$/) do
  step "uses the enrollment code received"
  step "a success message should be seen with the message '#{@success_ek_message}'"
  if @check_expected_plans
    step "the correct plans are shown"
  end
end


When(/^the user hits Sign Up$/) do
  @current_offer_ek_info = {'region' => @region}
  step "the system clicks on enroll button on responsive or non-responsive flow"
  step "the system sign up the user on non responsive flow if needed"
end

When(/^the user enrolls with the (first|second|third|fourth) plan$/) do |plan_selected|
  plan_mapping = {
    'first' => 1,
    'second' => 2,
    'third' => 3,
    'fourth' => 4,
  }
  if @is_on_responsive_flow
    gemini_plan_page_select(plan_mapping[plan_selected])
  else
    gemini_non_responsive_plan_page_select(plan_mapping[plan_selected])
  end
  step "the enroll continues successfully with default printer and credit card"
end

When(/^the user enrolls with the first default plan$/) do
  step "the user hits Sign Up"
  if @is_on_responsive_flow
    gemini_plan_page_select(1)
  else
    gemini_non_responsive_plan_page_select(1)
  end
  step "the enroll continues successfully with default printer and credit card"
end

When(/^applies '(.*)' promo code to the summary page$/) do | promo_code |
  if @is_on_responsive_flow
    gemini_summary_page_add_promo_code(promo_code)
  else
    gemini_non_responsive_summary_page_add_promo_code(promo_code)
  end
end

Then(/^all the below offers should be seen on screen, as follows:$/) do |table|
  @is_on_responsive_flow = gemini_plan_page_is_responsive()
  plans = agena_extract_gemini_plans_info_from_table(table)
  if @is_on_responsive_flow
    gemini_plan_page_check(plans)
  else
    gemini_non_responsive_plan_page_check(plans)
  end
end

Then(/^a success message should be seen with the message '(.*)'$/) do |message|
  @message_to_check = message
  if @is_on_responsive_flow
    step "the system verify the enrollment code success message on responsive flow"
  else
    step "the system verify the enrollment code success message on non-responsive flow"
  end
end

Then(/^the correct plans are shown$/) do
  if @is_on_responsive_flow and @current_offer_ek_info['type'] != "purchased"#purchased offers have only one plan and go straight to login screen
    gemini_plan_page_check(@current_offer_ek_info['plans'])
  else
    gemini_non_responsive_plan_page_check(@current_offer_ek_info['plans'])
  end
end

Then(/^the enroll continues successfully with default printer and credit card$/) do
  if @is_on_responsive_flow
    gemini_account_page_add_default_continue(@region, @environment)
  else
    gemini_non_responsive_continue()
  end

  #We may have bugs on that flow on gemini due to new printer selection page. Once they're resolved, this detour no longer be necessary
  @is_on_responsive_flow = internal_gemini_select_printer(@is_on_responsive_flow)

  if @is_on_responsive_flow
    gemini_shipping_page_add_address_continue(@region)
    gemini_billing_page_add_default_local()
  else
    gemini_non_responsive_shipping_page_add_address_continue(@region)
    gemini_non_responsive_billing_page_add_default_local()
  end
end

Then(/^the summary for that offer should contain (.*) pages per month and the amount of (.*) cents$/) do |pages, amount|
  @expected_summary_pages = pages
  @expected_summary_price = amount
  if @is_on_responsive_flow
    gemini_summary_page_check_numbers_offer(pages, amount)
  else
    gemini_non_responsive_summary_page_check_numbers_offer(pages, amount)
  end
end

Then(/^the summary for that offer should contain (.*) free months due to promo code and (.*) free months due to enrollment key$/) do |month_promo, month_ek|
  if @is_on_responsive_flow
    gemini_summary_page_check_numbers_total_promo_code_and_enrollment_key(month_ek, month_promo, @expected_summary_pages, @expected_summary_price)
  else
    gemini_non_responsive_summary_page_check_numbers_promo_code_and_enrollment_key(month_ek, month_promo, @expected_summary_pages, @expected_summary_price)
  end
end

Then(/^the summary for that offer should contain (.*) free months due to promo code$/) do |month|
  if @is_on_responsive_flow
    gemini_summary_page_check_numbers_total_promo_code(month, @expected_summary_pages, @expected_summary_price)
  else
    gemini_non_responsive_summary_page_check_numbers_promo_code(month, @expected_summary_pages, @expected_summary_price)
  end
end

Then(/^the summary for that offer should contain (.*) free months due to enrollment key$/) do |month|
  if @is_on_responsive_flow
    gemini_summary_page_check_numbers_total_enrollment_key(month, @expected_summary_pages, @expected_summary_price)
  else
    gemini_non_responsive_summary_page_check_numbers_enrollment_key(month, @expected_summary_pages, @expected_summary_price)
  end
end

Then(/^the summary should not have any promo code applied$/) do
  if @is_on_responsive_flow
    gemini_summary_page_no_total_promo_code
  else
    gemini_non_responsive_summary_page_no_total_promo_code
  end
end

Then(/^the summary should not have any enrollment key incentive applied$/) do
  if @is_on_responsive_flow
    gemini_summary_page_no_total_enrollment_key
  else
    gemini_non_responsive_summary_page_no_total_enrollment_key
  end
end

Then(/^the enroll should end successfully on 'Thank You' page$/) do
  if @is_on_responsive_flow
    gemini_summary_page_accept_terms_enroll
  else
    gemini_non_responsive_summary_page_accept_terms_enroll
  end
end

Then(/^the summary for that offer should have the message '(.*)'$/) do |message|
  if @is_on_responsive_flow
    gemini_summary_page_check_content_offers(message)
  else
    gemini_non_responsive_summary_page_check_content_offers(message)
  end
end

Then(/^the summary total should have the message '(.*)'$/) do |message|
  if @is_on_responsive_flow
    gemini_summary_page_check_content_total(message)
  else
    gemini_non_responsive_summary_page_check_content_total(message)
  end
end

Then(/^the summary for that offer should contain (.*) prepaid cents due to enrollment key$/) do |prepaid_cents|
  if @is_on_responsive_flow
    gemini_summary_page_check_numbers_prepaid_enrollment_key(prepaid_cents)
  else
    pending
  end
end