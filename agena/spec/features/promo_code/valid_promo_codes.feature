Feature: Check if the Valid Promo Codes can be retrieved and validated on Promo Code API
  In order to make sure the Valid Promo Codes can be retrieved and validated on Promo Code API
  As an agena client
  I want to validates all seeds promo codes based on type

  @ready @agena @promo_codes @kit_and_kitless
  Scenario Outline: Check if all the valid promo codes (that today's date is between start and end dates + 1 day) with kit_and_kitless type (the ones that need to be validated using only the plan_guid) returns "valid" when validated
    Given an agena client uses all the kit_and_kitless seeds promo codes on <environment>
    When a promo code start and end dates are good ones compared to today
    Then this promo code is marked as valid

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena @promo_codes @kit_only
  Scenario Outline: Check if all the valid promo codes (that today's date is between start and end dates + 1 day) with kit_only type (the ones that need to be validated using a plan EK and the plan_guid) returns "valid" when validated
    Given an agena client uses all the kit_only seeds promo codes on <environment>
    When a promo code start and end dates are good ones compared to today
    Then this promo code is marked as valid

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @promo_codes @agena
  Scenario Outline: Check FREEINK US date validation at TEST1, PIE1 and STAGE1
    When an agena client requests for all the US promo codes on <environment>
    Then 'FREEINK' is listed with a valid expiration date

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |