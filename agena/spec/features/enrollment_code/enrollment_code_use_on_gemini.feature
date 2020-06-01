Feature: Check the enrollment code flow on gemini
  In order to allow a gemini user to enroll with a pre-selected offer
  As a gemini user
  I want to use an enrollment code to a given offer

  @ready @ui_gemini @enrollment_code
  Scenario Outline: Check the enrollment code flow on gemini for a US user with a free offer
    Given an agena client requests a new enrollment code for US Consumer 99 Cent Offer on <environment>
    When an US gemini user opens the landing page on <environment>
    And  uses the enrollment code received
    Then a success message should be seen with the message 'Thank you for purchasing your printer'
    And the correct plans are shown

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @ui_gemini @enrollment_code
  Scenario Outline: Check the enrollment code flow on gemini for a US user with a prepaid offer
    Given an agena client requests a new enrollment code for HP Instant Ink Prepaid 120 Any Plan on <environment>
    When an US gemini user opens the landing page on <environment>
    And  uses the enrollment code received
    Then a success message should be seen with the message '12000'
    And the correct plans are shown

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ui_gemini @enrollment_code
  Scenario Outline: Check the enrollment code flow on gemini for a UK user with a freemium offer
    Given an agena client requests a new enrollment code for UK Consumer Freemium Offer on <environment>
    When an UK gemini user opens the landing page on <environment>
    And  uses the enrollment code received
    Then a success message should be seen with the message 'Thank you for purchasing your printer'
    And the correct plans are shown

    Examples:
      |environment|
      | test1     |
      | pie1      |
      #| stage1    |#stage1 tests are not able to add default printers or cards :(


  @ready @ui_gemini @enrollment_code
  Scenario Outline: Check the enrollment code flow on gemini for a US user with a purchased offer
    Given an agena client requests a new enrollment code for HP Instant Ink 100 page per month Seed Units on <environment>
    When an US gemini user opens the landing page on <environment>
    And  uses the enrollment code received
    Then a success message should be seen with the message 'You have 1 month of HP Instant Ink at 100 pages per month'
    And the enroll continues successfully with default printer and credit card
    And the summary for that offer should contain 100 pages per month and the amount of 499 cents

    Examples:
      |environment|
      | test1     |
      | pie1      |
      #| stage1    |#stage1 tests are not able to add default printers or cards :(

  @ready @ui_gemini @enrollment_code
  Scenario Outline: Check the enrollment code application on gemini for a US user with a purchased offer
    Given an agena client requests a new enrollment code for HP Instant Ink 100 page per month Seed Units on <environment>
    When an US gemini user opens the landing page on <environment>
    And  uses the enrollment code received
    Then a success message should be seen with the message 'You have 1 month of HP Instant Ink at 100 pages per month'

    Examples:
      |environment|
      | stage1    |

  @ready @ui_gemini @enrollment_code @23_8_16_hotfix
  Scenario Outline: Check the enrollment code application on gemini for a US user with a purchased offer
    Given an agena client requests a new enrollment code for HP Instant Ink Prepaid 16 Any Plan on <environment>
    When an UK gemini user opens the landing page on <environment>
    And  uses the enrollment code received
    Then a success message should be seen with the message '1600'
    And the correct plans are shown

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |