Feature: New offers validation
  In order to make sure a given new offer behaves correctly
  As a gemini client and oobe client
  I want to enroll with the given offer successfully on Gemini flows (responsive and non-responsive) and OOBE API

  @new_offer @agena
  Scenario: New offer basic validation on agena's API
    Given an agena client requests the given offer on a given environment
    When they're returned safelly
    Then they're not empty
    And the gemini fields are all there
    And the plans are shown as expected

  @new_offer @oobe
  Scenario: New offer enrollment validation on OOBE API using an enrollment code
    Given the default model number A9T80A is used
    And an agena client requests a new enrollment code using the given offer on the given environment
    When an agena client enrolls that printer using OOBE flow
    And an agena client get the offers for that printer and enrollment code using OOBE flow
    Then all the oobe fields should be present on the response
    And all the plans from the given offer should be returned from agena on the oobe response

  @new_offer @gemini
  Scenario: New offer enrollment validation on Gemini using an enrollment code
    Given an agena client requests new enrollment codes for all the plans using the given offer on the given environment
    When a gemini client uses an enrollment code
    Then incentives or cents amount are obtained from the success message
    And the correct plans are shown on the plans page
    And each plan pages and prices are shown correctly on the summary page
    And the incentives are listed correctly on the summary page
    And thank you page is shown