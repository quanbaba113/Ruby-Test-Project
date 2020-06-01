Feature: Verify updated offers with additional months
  In order to make sure the updated offers have correct additional months on Gemini flows (responsive and non-responsive)
  As a gemini client
  I want to enroll with the given offers successfully

  @acceptance_tests @agena
  Scenario: HP Instant Ink 50pg AMZ Plan should bring the correct 50 pages US plan with 2 incentives months
    When an agena client requests the offer with name HP Instant Ink 50pg AMZ Plan on pie1
    Then all the below plans should be returned from the current offer, as follows:
      | guid | pages | priceCents | region | incentiveMonths |
      | f73a53f8-c207-4fcd-8228-e265cf68d19f | 50 | 299 | US | 2 |

  @acceptance_tests @agena
  Scenario: HP Instant Ink 100pg AMZ Plan should bring the correct 100 pages US plan with 2 incentives months
    When an agena client requests the offer with name HP Instant Ink 100pg AMZ Plan on pie1
    Then all the below plans should be returned from the current offer, as follows:
      | guid | pages | priceCents | region | incentiveMonths |
      | be86e9c2-ef37-4519-9665-3cf0aa483588 | 100 | 499 | US | 2 |

  @acceptance_tests @agena
  Scenario: HP Instant Ink 300pg AMZ Plan should bring the correct 300 pages US plan with 2 incentives months
    When an agena client requests the offer with name HP Instant Ink 300pg AMZ Plan on pie1
    Then all the below plans should be returned from the current offer, as follows:
      | guid | pages | priceCents | region | incentiveMonths |
      | 477937ed-51ce-464b-9d47-096aa1ceb67b | 300 | 999 | US | 2 |

  @acceptance_tests @agena
  Scenario: HP Inst Ink HHO Any15/50/100/300p Pln should bring the correct 15/50/100/300 US plans with 3 incentive months (except 15 pages)
    When an agena client requests the offer with name HP Inst Ink HHO Any15/50/100/300p Pln on pie1
    Then all the below plans should be returned from the current offer, as follows:
      | guid | pages | priceCents | region | incentiveMonths |
      | d57f3dac-9345-4cdb-8b50-d5540ed876c5 | 15 | 0 | US | 0 |
      | f73a53f8-c207-4fcd-8228-e265cf68d19f | 50 | 299 | US | 3 |
      | be86e9c2-ef37-4519-9665-3cf0aa483588 | 100 | 499 | US | 3 |
      | 477937ed-51ce-464b-9d47-096aa1ceb67b | 300 | 999 | US | 3 |

  @acceptance_tests @ui_gemini @enrollment_code
  Scenario Outline: Specified US purchased offers should grant 2 months of incentives when using an enrollment code on gemini
    Given an agena client requests a new enrollment code for <offer_name> on <environment>
    And a gemini user expects to see the message '<success_message>' on a successful usage of it
    When an <region> gemini user opens the landing page on <environment>
    And  uses the enrollment code received successfully
    And the enroll continues successfully with default printer and credit card
    Then the summary for that offer should contain <pages> pages per month and the amount of <cents> cents
    And the summary for that offer should contain <incentive_months> free months due to enrollment key
    And the summary should not have any promo code applied
    And the enroll should end successfully on 'Thank You' page

    Examples:
      |environment|region|offer_name|pages|cents|incentive_months|success_message|
      |pie1|US|HP Instant Ink 50pg AMZ Plan|50|299|2|You have 2 months of HP Instant Ink at 50 pages per month|
      |pie1|US|HP Instant Ink 100pg AMZ Plan|100|499|2|You have 2 months of HP Instant Ink at 100 pages per month|
      |pie1|US|HP Instant Ink 300pg AMZ Plan|300|999|2|You have 2 months of HP Instant Ink at 300 pages per month|

  @acceptance_tests @ui_gemini @enrollment_code
  Scenario Outline: HP Inst Ink HHO Any15/50/100/300p Pln should not grant any free months when selecting 15 pages plan using an enrollment code on gemini
    Given an agena client requests a new enrollment code for HP Inst Ink HHO Any15/50/100/300p Pln on <environment>
    And a gemini user expects to see the message 'Thank you for purchasing your printer' on a successful usage of it
    And wants to see expected plans on a successful usage of it
    When an US gemini user opens the landing page on <environment>
    And  uses the enrollment code received successfully
    When the user enrolls with the first plan
    Then the summary for that offer should contain 15 pages per month and the amount of FREE cents
    #And the summary should not have any enrollment key incentive applied
    And the summary for that offer should contain 0 free months due to enrollment key
    And the summary should not have any promo code applied
    And the enroll should end successfully on 'Thank You' page

    Examples:
      |environment|
      |pie1       |

  @acceptance_tests @ui_gemini @enrollment_code
  Scenario Outline: HP Inst Ink HHO Any15/50/100/300p Pln should grant 3 free months when 50/100/300 pages plans are selected using an enrollment code on gemini
    Given an agena client requests a new enrollment code for HP Inst Ink HHO Any15/50/100/300p Pln on pie1
    And a gemini user expects to see the message 'Thank you for purchasing your printer' on a successful usage of it
    And wants to see expected plans on a successful usage of it
    When an US gemini user opens the landing page on <environment>
    And uses the enrollment code received successfully
    And the user enrolls with the <selected_plan> plan
    Then the summary for that offer should contain <pages> pages per month and the amount of <cents> cents
    And the summary for that offer should contain <incentive_months> free months due to enrollment key
    And the summary should not have any promo code applied
    And the enroll should end successfully on 'Thank You' page

    Examples:
      |environment|selected_plan|pages|cents|incentive_months|
      |pie1|second|50|299|3|
      |pie1|third|100|499|3|
      |pie1|fourth|300|999|3|
