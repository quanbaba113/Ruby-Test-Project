Feature: Check if the Expired Promo Codes can be retrieved and validated on Promo Code API
  In order to make sure the Expired Promo Codes can be retrieved and validated on Promo Code API
  As an agena client
  I want to validates all seeds promo codes based on type

  @ready @agena @promo_codes @kit_and_kitless
  Scenario Outline: Check if all the expired promo codes (that today's date is after end date) with kit_and_kitless type (the ones that need to be validated using only the plan_guid) returns "expired" when validated
    Given an agena client uses all the kit_and_kitless seeds promo codes on <environment>
    When a promo code end date is before today
    Then this promo code is marked as expired

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena @promo_codes @kit_only
  Scenario Outline: Check if all the expired promo codes (that today's date is after end date) with kit_only type (the ones that need to be validated using a plan EK and the plan_guid) returns "expired" when validated
    Given an agena client uses all the kit_only seeds promo codes on <environment>
    When a promo code end date is before today
    Then this promo code is marked as expired

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena
  Scenario Outline: Check 3MONTHSFREE US date validation at TEST1, PIE1 and STAGE1
    When an agena client requests for all the US promo codes on <environment>
    Then '3MONTHSFREE' is listed without a valid expiration date

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @promo_codes @ui_gemini_responsive
  Scenario Outline: Check '3MONTHSFREE' on US client at TEST1, PIE1 and STAGE1 as it has expired
    Given an US gemini user opens the landing page on <environment>
    When the user enrolls with the first default plan
    And  applies '3MONTHSFREE' promo code to the summary page
    Then the summary for that offer should have the message 'Oops! This code has expired'

    Examples:
      |environment|
      | test1     |
      | pie1      |
      #| stage1    | #stage1 tests are not able to add default printers or cards :(