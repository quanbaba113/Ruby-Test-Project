Feature: Check the existent default offers for CA
  In order to make sure the default offers for CA are 50/100/300 pages and 399/599/1099 cents on both the API and the Gemini website
  As an agena client and gemini user
  I want to retrieve the existent offers

  @ready
  Scenario Outline: Check default offers on agena for CA on TEST1,PIE1 and STAGE1
    When an agena client requests for the default offers for CA customers on <environment>
    Then all the below plans should be returned from agena only offer, as follows:
      | guid | pages | priceCents | region | incentiveMonths |
      | fa889a2b-662c-471b-a21a-8abf65bdc45c | 50 | 399 | CA | 1 |
      | 60e1a50f-a3b5-4020-a154-06dc5166d5b4 | 100 | 599 | CA | 1 |
      | 3ee7b81f-1274-4abd-8401-03314ed45b58 | 300 | 1099 | CA | 1 |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @ui_gemini @default_offers
  Scenario Outline: Check default offers on gemini for CA on TEST1,PIE1 and STAGE1
    Given an CA gemini user opens the landing page on <environment>
    When the user hits Sign Up
    Then all the below offers should be seen on screen, as follows:
      | pages | priceCents |
      | 50 | 399 |
      | 100 | 599 |
      | 300 | 1099 |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |
      | prod      |

  @ready @ui_gemini @default_offers
  Scenario Outline: Check default offers on gemini for CA on TEST1,PIE1 and STAGE1
    Given an CAF gemini user opens the landing page on <environment>
    When the user hits Sign Up
    Then all the below offers should be seen on screen, as follows:
      | pages | priceCents |
      | 50 | 399 |
      | 100 | 599 |
      | 300 | 1099 |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |
      | prod      |
