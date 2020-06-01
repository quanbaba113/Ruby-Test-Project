Feature: Check the XMO2 US offers behavior on OOBE endpoint
  In order to make sure the offers for an XMO2 US printer are being returned with the same data used on the Gemini Site
  As an agena client
  I want to registrate and retrieve the offers from oobe endpoint

  @ready @agena @oobe @default_offer @offer
  Scenario Outline: Check the default plans on OOBE API for an XMO2 US printer on TEST1,PIE1 and STAGE1 using the agena flow only
    Given model number D9L20A, the serial number TH65B5X149 and the jump ID easystartwin_oobe_ows_D9L20A belongs to a XMO2 printer on US
    When an agena client enrolls that printer using OOBE flow on <environment>
    And an agena client get the offers for that printer using OOBE flow on <environment>
    Then all the oobe fields should be present on the response
    And printer classification should be XMO2 on the response
    And no incentive should be on the response
    And all the below plans should be returned from agena, as follows:
      | guid | pages | price_cents | currency |
      | f73a53f8-c207-4fcd-8228-e265cf68d19f | 50 | 299 | USD |
      | be86e9c2-ef37-4519-9665-3cf0aa483588 | 100 | 499 | USD |
      | 477937ed-51ce-464b-9d47-096aa1ceb67b | 300 | 999 | USD |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @failed @bad_15_pags_99_cents_offer @agena @oobe @printer_specific_offer @offer
  Scenario Outline: Check the addition of plans 15,50,100,300 on production offer named 'HP Instant Ink US Any 15/50/100/300p Pln' on OOBE API for an XMO2 US printer on TEST1,PIE1 and STAGE1 using the agena flow only
    Given model number F0V69A, the serial number CN58A16171 and the jump ID easystartwin_oobe_ows_F0V69A belongs to a XMO2 printer on US
    When an agena client get the offers for that printer using OOBE flow on <environment>
    Then all the oobe fields should be present on the response
    And printer classification should be XMO2 on the response
    And no incentive should be on the response
    And all the below plans should be returned from agena, as follows:
      | guid | pages | price_cents | currency |
      | 916798cd-b10a-4570-9e0c-1174cfd8c8fa | 15 | 0 | USD |
      | f73a53f8-c207-4fcd-8228-e265cf68d19f | 50 | 299 | USD |
      | be86e9c2-ef37-4519-9665-3cf0aa483588 | 100 | 499 | USD |
      | 477937ed-51ce-464b-9d47-096aa1ceb67b | 300 | 999 | USD |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena @oobe @printer_specific_offer @23_8_16_hotfix @offer @waiver_rollover_allow_plan_change
  Scenario Outline: Check the addition of plans 15,50,100,300 for printer M9L66A on OOBE API for an XMO2 US printer on TEST1,PIE1 and STAGE1 using the agena flow only in order to verify agena hotfix from 8/23
    Given the model number M9L66A and the jump ID easystartwin_oobe_ows_M9L66A belongs to a XMO2 printer on US
    When an agena client get the offers for that printer using OOBE flow on <environment>
    Then all the oobe fields should be present on the response
    And printer classification should be XMO2 on the response
    And only oobe incentive should be on the response
    And all the below plans should be returned from agena, as follows:
      | guid | pages | price_cents | currency | waiver | rollover | allow_plan_change_back |
      | d57f3dac-9345-4cdb-8b50-d5540ed876c5 | 15 | 0 | USD | 0 | 15 | false             |
      | f73a53f8-c207-4fcd-8228-e265cf68d19f | 50 | 299 | USD | 300 | 50 | true            |
      | be86e9c2-ef37-4519-9665-3cf0aa483588 | 100 | 499 | USD | 300 | 100 | true          |
      | 477937ed-51ce-464b-9d47-096aa1ceb67b | 300 | 999 | USD | 300 | 300 | true          |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena @oobe @printer_specific_offer @23_8_16_hotfix @offer
  Scenario Outline: Check the addition of plans 15,50,100,300 for printer M9L66A on OOBE API for an XMO2 CA printer on TEST1,PIE1 and STAGE1 using the agena flow only in order to verify agena hotfix from 8/23
    Given the model number M9L66A and the jump ID easystartwin_oobe_ows_M9L66A belongs to a XMO2 printer on CA
    When an agena client get the offers for that printer using OOBE flow on <environment>
    Then all the oobe fields should be present on the response
    And printer classification should be XMO2 on the response
    And only oobe incentive should be on the response
    And all the below plans should be returned from agena, as follows:
      | guid | pages | price_cents | currency |
      | fa889a2b-662c-471b-a21a-8abf65bdc45c | 50 | 399 | CAD |
      | 60e1a50f-a3b5-4020-a154-06dc5166d5b4 | 100 | 599 | CAD |
      | 3ee7b81f-1274-4abd-8401-03314ed45b58 | 300 | 1099 | CAD |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena @oobe @enrollment_code_offer @offer
  Scenario Outline: Check the enrollment code application on OOBE API for an XMO2 US printer on TEST1,PIE1 and STAGE1 using the agena flow only
    Given the model number D9L20A and the jump ID easystartwin_oobe_ows_D9L20A belongs to a XMO2 printer on US
    And an agena client requests a new enrollment code for US Consumer Freemium Offer on <environment>
    When an agena client get the offers for that printer and enrollment code using OOBE flow on <environment>
    Then all the oobe fields should be present on the response
    And printer classification should be XMO2 on the response
    And only oobe incentive should be on the response
    And all the below plans should be returned from agena, as follows:
      | guid | pages | price_cents | currency |
      | d57f3dac-9345-4cdb-8b50-d5540ed876c5 | 15 | 0 | USD |
      | f73a53f8-c207-4fcd-8228-e265cf68d19f | 50 | 299 | USD |
      | be86e9c2-ef37-4519-9665-3cf0aa483588 | 100 | 499 | USD |
      | 477937ed-51ce-464b-9d47-096aa1ceb67b | 300 | 999 | USD |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena @oobe @enrollment_code_offer @offer @waiver_rollover_allow_plan_change
  Scenario Outline: Check the enrollment code application of a HUPS offer on OOBE API for an XMO2 US printer on TEST1,PIE1 and STAGE1 using the agena flow only
    Given the model number D9L20A and the jump ID easystartwin_oobe_ows_D9L20A belongs to a XMO2 printer on US
    And an agena client requests a new enrollment code for HUPs Pilot - (J7K36A) GENERIC RETAILER on <environment>
    When an agena client get the offers for that printer and enrollment code using OOBE flow on <environment>
    Then all the oobe fields should be present on the response
    And printer classification should be XMO2 on the response
    And only oobe incentive should be on the response
    And all the below plans should be returned from agena, as follows:
      | guid | pages | price_cents | currency | waiver | rollover | allow_plan_change_back |
      | f73a53f8-c207-4fcd-8228-e265cf68d19f | 50 | 299 | USD | 300 | 50 | true            |
      | be86e9c2-ef37-4519-9665-3cf0aa483588 | 100 | 499 | USD | 300 | 100 | true          |
      | 477937ed-51ce-464b-9d47-096aa1ceb67b | 300 | 999 | USD | 300 | 300 | true          |
      | 03ca853c-9ea5-4641-b422-fb4fc52eb6d9 | 500 | 1499 | USD | 300 | 500 | true         |

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |