Feature: Check the existent default offers for ES
  In order to make sure the default offers for ES are 50/100/300 pages and 299/499/999 cents on both the API and the Gemini website
  As an agena client and gemini user
  I want to retrieve the existent offers

  @ready
  Scenario Outline: Check default offers on agena for ES on TEST1,PIE1 and STAGE1
    When an agena client requests for the default offers for ES customers on <environment>
    Then all the below plans should be returned from agena only offer, as follows:
      | guid | pages | priceCents | region | incentiveMonths |
      | f5aa702f-8f6d-42fa-aa3b-8101bdb15e88 | 50 | 299 | ES | 1 |
      | 50174cc3-6829-4bd5-b2ae-707f7df28f86 | 100 | 499 | ES | 1 |
      | 3d5dda91-7e87-4244-8947-cadde546667c | 300 | 999 | ES | 1 |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @ui_gemini @default_offers
  Scenario Outline: Check default offers on gemini for ES on TEST1,PIE1 and STAGE1
    Given an ES gemini user opens the landing page on <environment>
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