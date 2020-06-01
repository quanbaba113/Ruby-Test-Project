Feature: Check the existent default offers for UK
  In order to make sure the default offers for UK are 50/100/300 pages and 199/349/799 cents on both the API and the Gemini website
  As an agena client and gemini user
  I want to retrieve the existent offers

  @ready @agena
  Scenario Outline: Check default offers on agena for UK on TEST1,PIE1 and STAGE1
    When an agena client requests for the default offers for UK customers on <environment>
    Then only one offer is returned
    And all the below plans should be returned from agena only offer, as follows:
      | guid | pages | priceCents | region | incentiveMonths |
      | 61300129-e8ff-4456-9378-3f9bb2cd82a9 | 50 | 199 | UK | 1 |
      | 604a59d5-5390-4af6-ae01-9a21c3a25dcb  | 100 | 349 | UK | 1 |
      | 899953a6-690a-4293-b7bf-04e9a303612a  | 300 | 799 | UK | 1 |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @ui_gemini @default_offers
  Scenario Outline: Check default offers on gemini for UK on TEST1,PIE1 and STAGE1
    Given an UK gemini user opens the landing page on <environment>
    When the user hits Sign Up
    Then all the below offers should be seen on screen, as follows:
      | pages | priceCents |
      | 50 | 199 |
      | 100 | 349 |
      | 300 | 799 |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |
      | prod      |