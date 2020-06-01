Feature: Check the existent default offers for DE
  In order to make sure the default offers for DE are 50/100/300 pages and 299/499/999 cents on both the API and the Gemini website
  As an agena client and gemini user
  I want to retrieve the existent offers

  @ready
  Scenario Outline: Check default offers on agena for DE on TEST1,PIE1 and STAGE1
    When an agena client requests for the default offers for DE customers on <environment>
    Then all the below plans should be returned from agena only offer, as follows:
      | guid | pages | priceCents | region | incentiveMonths |
      | 0716f65d-06e3-4c53-9120-8faffbbd9a6c | 50 | 299 | DE | 1 |
      | 7d09fb94-caaa-4795-b4d5-9b5f1796ade5 | 100 | 499 | DE | 1 |
      | ca0832ab-14d2-4dd5-967e-80ca55ea6d8d | 300 | 999 | DE | 1 |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @ui_gemini @default_offers
  Scenario Outline: Check default offers on gemini for DE on TEST1,PIE1 and STAGE1
    Given an DE gemini user opens the landing page on <environment>
    When the user hits Sign Up
    Then all the below offers should be seen on screen, as follows:
      | pages | priceCents |
      | 50 | 299 |
      | 100 | 499 |
      | 300 | 999 |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |
      | prod      |