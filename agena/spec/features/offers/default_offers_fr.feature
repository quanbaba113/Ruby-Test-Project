Feature: Check the existent default offers for FR
  In order to make sure the default offers for FR are 50/100/300 pages and 299/499/999 cents on both the API and the Gemini website
  As an agena client and gemini user
  I want to retrieve the existent offers

  @ready
  Scenario Outline: Check default offers on agena for FR on TEST1,PIE1 and STAGE1
    When an agena client requests for the default offers for FR customers on <environment>
    Then all the below plans should be returned from agena only offer, as follows:
      | guid | pages | priceCents | region | incentiveMonths |
      | 01447003-7197-49e6-81d8-111b2fcbaa82 | 50 | 299 | FR | 1 |
      | b839a015-3e66-417e-98cf-dad47a058c22 | 100 | 499 | FR | 1 |
      | b314704e-6117-4d1e-9e20-d9593b01dd26 | 300 | 999 | FR | 1 |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @ui_gemini @default_offers
  Scenario Outline: Check default offers on gemini for FR on TEST1,PIE1 and STAGE1
    Given an FR gemini user opens the landing page on <environment>
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