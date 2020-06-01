Feature: Check if the Inactive Promo Codes can be retrieved and validated on Promo Code API
  In order to make sure the Inactive Promo Codes can be retrieved and validated on Promo Code API
  As an agena client
  I want to validates all seeds promo codes based on type

  @ready @agena @promo_codes @kit_and_kitless
  Scenario Outline: Check if all the invalid promo codes (that today's date is before start date) with kit_and_kitless type (the ones that need to be validated using only the plan_guid) returns "inactive" when validated
    Given an agena client uses all the kit_and_kitless seeds promo codes on <environment>
    When a promo code start date is after today
    Then this promo code is marked as inactive

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena @promo_codes @kit_only
  Scenario Outline: Check if all the invalid promo codes (that today's date is before start date) with kit_only type (the ones that need to be validated using a plan EK and the plan_guid) returns "inactive" when validated
    Given an agena client uses all the kit_only seeds promo codes on <environment>
    When a promo code start date is after today
    Then this promo code is marked as inactive

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |