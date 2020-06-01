Feature: Check if Promo Codes can be used on Gemini
  In order to make sure the Promo Codes can be used on Gemini flows (responsive and non-responsive)
  As a gemini client
  I want to verify a given valid promo code on all countries

  @ready @promo_codes @ui_gemini
  Scenario Outline: Check 'FREEINK' on US client at TEST1, PIE1 and STAGE1 as it has a valid expiration date
    Given an US gemini user opens the landing page on <environment>
    When the user enrolls with the first default plan
    And  applies 'FREEINK' promo code to the summary page
    Then the summary for that offer should contain 50 pages per month and the amount of 299 cents
    And the summary for that offer should contain 1 free months due to promo code
    And the enroll should end successfully on 'Thank You' page

    Examples:
      |environment|
      #| test1     |
      | pie1      |
      #| stage1    | #stage1 tests are not able to add default printers or cards :(

  @ready @promo_codes @ui_gemini
  Scenario Outline: Check 'FREEINK' on UK client at TEST1, PIE1 and STAGE1 as it has a valid expiration date
    Given an UK gemini user opens the landing page on <environment>
    When the user enrolls with the first default plan
    And  applies 'FREEINK' promo code to the summary page
    Then the summary for that offer should contain 50 pages per month and the amount of 199 cents
    And the summary for that offer should contain 1 free months due to promo code
    And the enroll should end successfully on 'Thank You' page

    Examples:
      |environment|
      #| test1     |
      | pie1      |
      #| stage1    | #stage1 tests are not able to add default printers or cards :(

  @ready @promo_codes @ui_gemini
  Scenario Outline: Check 'FREEINK' on ES client at TEST1, PIE1 and STAGE1 as it has a valid expiration date
    Given an ES gemini user opens the landing page on <environment>
    When the user enrolls with the first default plan
    And  applies 'FREEINK' promo code to the summary page
    Then the summary for that offer should contain 50 pages per month and the amount of 299 cents
    And the summary for that offer should contain 1 free months due to promo code
    And the enroll should end successfully on 'Thank You' page

    Examples:
      |environment|
      #| test1     |
      | pie1      |
      #| stage1    | #stage1 tests are not able to add default printers or cards :(

  @ready @promo_codes @ui_gemini
  Scenario Outline: Check 'FREEINK' on FR client at TEST1, PIE1 and STAGE1 as it has a valid expiration date
    Given an FR gemini user opens the landing page on <environment>
    When the user enrolls with the first default plan
    And  applies 'FREEINK' promo code to the summary page
    Then the summary for that offer should contain 50 pages per month and the amount of 299 cents
    And the summary for that offer should contain 1 free months due to promo code
    And the enroll should end successfully on 'Thank You' page

    Examples:
      |environment|
      #| test1     |
      | pie1      |
      #| stage1    | #stage1 tests are not able to add default printers or cards :(

  @ready @promo_codes @ui_gemini
  Scenario Outline: Check 'FREEINK' on DE client at TEST1, PIE1 and STAGE1 as it has a valid expiration date
    Given an DE gemini user opens the landing page on <environment>
    When the user enrolls with the first default plan
    And  applies 'FREEINK' promo code to the summary page
    Then the summary for that offer should contain 50 pages per month and the amount of 299 cents
    And the summary for that offer should contain 1 free months due to promo code
    And the enroll should end successfully on 'Thank You' page

    Examples:
      |environment|
      #| test1     |
      | pie1      |
      #| stage1    | #stage1 tests are not able to add default printers or cards :(

  @ready @promo_codes @ui_gemini
  Scenario Outline: Check 'FREEINK' on CA client at TEST1, PIE1 and STAGE1 as it has a valid expiration date
    Given an CA gemini user opens the landing page on <environment>
    When the user enrolls with the first default plan
    And  applies 'FREEINK' promo code to the summary page
    Then the summary for that offer should contain 50 pages per month and the amount of 399 cents
    And the summary for that offer should contain 1 free months due to promo code
    And the enroll should end successfully on 'Thank You' page

    Examples:
      |environment|
      #| test1     |
      | pie1      |
      #| stage1    | #stage1 tests are not able to add default printers or cards :(