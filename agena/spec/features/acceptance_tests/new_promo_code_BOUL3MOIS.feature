Feature: New promo code validation
  In order to make sure a given promo code was created correctly
  As a gemini client
  I want to list and validate it with each plan

  @agena @promo_codes @acceptance_tests @BOUL3MOIS
  Scenario Outline: Check new Promo code on all environments
    When an agena client retrieves the promo code BOUL3MOIS on <environment>
    Then this promo code start date is 30/09/2016
    And this promo code end date is 03/11/2016
    And this promo code region is FR
    And all the below plans should be returned from the promo code, as follows:
      | unit | amount | plan |
      | Month | 3 | My 50 Page Plan |
      | Month | 3 | My 100 Page Plan |
      | Month | 3 | My 300 Page Plan |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @agena @promo_codes @acceptance_tests @BOUL3MOIS
  Scenario Outline: Check new Promo code validation
    Given today's date is after 31/09/2016
    When an agena client retrieves the promo code BOUL3MOIS on <environment>
    Then this promo code start date is 30/09/2016
    And this promo code end date is 03/11/2016
    And this promo code region is FR
    And all the below plans details should be returned from the promo code validation, as follows:
      | plan_guid | amount |
      | 01447003-7197-49e6-81d8-111b2fcbaa82 | 3 |
      | b839a015-3e66-417e-98cf-dad47a058c22 | 3 |
      | b314704e-6117-4d1e-9e20-d9593b01dd26 | 3 |
    And this promo code state is active when validated with all above plans


    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |