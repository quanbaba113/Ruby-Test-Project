Feature: Check the printer's incentives, using a single representant of each incentives groups on OOBE endpoint
  In order to make sure the incentives for a single printer inside each incentive group is being returned correctly
  As an agena client
  I want to retrieve the incentives for each appointed printer

  @ready @agena @oobe @printers_incentives
  Scenario Outline: Check the default XMOC printer benefits on TEST1,PIE1 and STAGE1 using the oobe endpoint flow only
    Given model number A9T80A belongs to a XMOC printer on US
    When an agena client retrieves that printer incentives using OOBE API on <environment>
    Then all the oobe incentive fields should be present on the response
    And printer classification should be XMOC on the response
    And no printer incentive should be on the response
    And printer incentive days should be 7

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena @oobe @printers_incentives
  Scenario Outline: Check the default XMO2 printer 3 months benefits on TEST1,PIE1 and STAGE1 using the oobe endpoint flow only
    Given model number F0V69A belongs to a XMO2 printer on US
    When an agena client retrieves that printer incentives using OOBE API on <environment>
    Then all the oobe incentive fields should be present on the response
    And printer classification should be XMO2 on the response
    And 3 months of printer incentive should be on the response
    And printer incentive days should be 7

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena @oobe @printers_incentives
  Scenario Outline: Check the default XMO2 printer 4 months benefits on TEST1,PIE1 and STAGE1 using the oobe endpoint flow only
    Given model number T0G48A belongs to a XMO2 printer on ES
    When an agena client retrieves that printer incentives using OOBE API on <environment>
    Then all the oobe incentive fields should be present on the response
    And printer classification should be XMO2 on the response
    And 4 months of printer incentive should be on the response
    And printer incentive days should be 7

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena @oobe @printers_incentives
  Scenario Outline: Check the default XMO2 printer 5 months benefits on TEST1,PIE1 and STAGE1 using the oobe endpoint flow only
    Given model number K7G87A belongs to a XMO2 printer on DE
    When an agena client retrieves that printer incentives using OOBE API on <environment>
    Then all the oobe incentive fields should be present on the response
    And printer classification should be XMO2 on the response
    And 5 months of printer incentive should be on the response
    And printer incentive days should be 7

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena @oobe @printers_incentives
  Scenario Outline: Check the default XMO2 printer 9 months benefits on TEST1,PIE1 and STAGE1 using the oobe endpoint flow only
    Given model number J6U67A belongs to a XMO2 printer on UK
    When an agena client retrieves that printer incentives using OOBE API on <environment>
    Then all the oobe incentive fields should be present on the response
    And printer classification should be XMO2 on the response
    And 9 months of printer incentive should be on the response
    And printer incentive days should be 7

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |