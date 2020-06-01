Feature: Check the existent offers endpoint for UK and CA
  In order to make sure the offers endpoint is being correctly returned
  As an agena client
  I want to retrieve all the existent offers

  @ready @agena @all_offers
  Scenario Outline: Check all offers response on TEST1, PIE1 and STAGE1
    Given an agena client requests for all the offers on <environment>
    When they're returned safelly
    Then they're not empty
    And the gemini fields are all there

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena @oobe @all_offers
  Scenario Outline: Check if an enrollment code can be created for each offer
    Given an agena client requests for all the offers on <environment>
    When the ones with model number are used on OOBE flow
    Then all plans are returned correcly

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @agena @duplicated_unique_offers @all_offers
  Scenario Outline: Check if an enrollment code can be created for each offer
    When an agena client requests for all the offers on <environment>
    Then list all the offers with duplicated names
    And list all the offers with unique names

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |