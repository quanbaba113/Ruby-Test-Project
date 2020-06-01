Feature: Check the existent default offers for US
  In order to make sure the default offers for UK are 50/100/300 pages and 299/499/999 cents on both the API and the Gemini website
  As an agena client and gemini user
  I want to retrieve the existent offers

  @ready @agena
  Scenario Outline: Check default offers on agena for US on TEST1,PIE1 and STAGE1
    When an agena client requests for the default offers for US customers on <environment>
    Then only one offer is returned
    And all the below plans should be returned from agena only offer, as follows:
      | guid | pages | priceCents | region | incentiveMonths |
      | f73a53f8-c207-4fcd-8228-e265cf68d19f | 50 | 299 | US | 1 |
      | be86e9c2-ef37-4519-9665-3cf0aa483588 | 100 | 499 | US | 1 |
      | 477937ed-51ce-464b-9d47-096aa1ceb67b | 300 | 999 | US | 1 |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @ui_gemini @default_offers
  Scenario Outline: Check default offers on gemini for US on TEST1,PIE1 and STAGE1
    Given an US gemini user opens the landing page on <environment>
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