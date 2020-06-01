Feature: See how offers will appear on v3
  In order to understand how the offers payload will looks like in v3 API
  As a gemini developer
  I want to see on the console a formatted json with the v2 offer and the v3 equivalent

  @v3_stuff_api
  Scenario: Purchased offer from API showing that v3 offers only shows static incentives
    When an agena client requests the offer with name HP Instant Ink 50pg AMZ Plan on pie1
    Then the payload of this offer is shown on console
    And the payload for v3 offers/:offer_sku is shown on console

  @v3_stuff_ok
  Scenario: purchased offer from file showing that v3 offers only shows static incentives, v3 plans only shows plan data (and no incentive)
    When a v2 offer is read from file purchased.json
    Then the payload of this offer is shown on console
    And the payload for v3 offers/:offer_sku is shown on console
    And the payload for v3 plans for every plan is shown on console

  @v3_stuff_ok
  Scenario: LUPS (15 pages 99 cents plans) offer from file showing that v3 offers only shows static incentives, v3 plans only shows plan data (and no incentive) and v3 offers/signup/enrollment_key/:enrollment_key shows all incentives
    When a v2 offer is read from file lups.json
    Then the payload of this offer is shown on console
    And the payload for v3 offers/:offer_sku is shown on console
    And the payload for v3 plans for every plan is shown on console
    And the payload for v3 offers/signup/enrollment_key/:enrollment_key is shown on console

  @v3_stuff_ok
  Scenario: HUPS (500 pages plans) offer from file showing that v3 offers only shows static incentives, v3 plans only shows plan data (and no incentive) and v3 offers/signup/enrollment_key/:enrollment_key shows all incentives
    When a v2 offer is read from file hups.json
    Then the payload of this offer is shown on console
    And the payload for v3 offers/:offer_sku is shown on console
    And the payload for v3 plans for every plan is shown on console
    And the payload for v3 offers/signup/enrollment_key/:enrollment_key is shown on console

  @v3_stuff_ok
  Scenario: XMOD offer (hasTrialPeriod = true) from file showing that v3 offers only shows static incentives, v3 plans only shows plan data (and no incentive) and v3 offers/signup/enrollment_key/:enrollment_key shows all incentives
    When a v2 offer is read from file xmod.json
    Then the payload of this offer is shown on console
    And the payload for v3 offers/:offer_sku is shown on console
    And the payload for v3 plans for every plan is shown on console
    And the payload for v3 offers/signup/enrollment_key/:enrollment_key is shown on console

  @v3_stuff_ok
  Scenario: Prepaid offer from file showing that v3 offers only shows static incentives, v3 plans only shows plan data (and no incentive) and v3 offers/signup/enrollment_key/:enrollment_key shows all incentives
    When a v2 offer is read from file prepaid.json
    And a v2 enrollment code status is read from file prepaid.ek.json
    Then the payload of this offer is shown on console
    And the payload for v3 offers/:offer_sku is shown on console
    And the payload for v3 plans for every plan is shown on console
    And the payload for v3 offers/signup/enrollment_key/:enrollment_key is shown on console
    And the payload of this enrollment code status is shown on console
    And the payload for v3 codes/:code is shown on console

  @v3_stuff_ok
  Scenario: Using an Enrollment code from a german Purchased offer one can see all the incentives on v3 offers/signup/enrollment_key/:enrollment_key (including auto applied promo codes)
    When a v2 offer is read from file purchased.de.json
    And a v2 enrollment code status is read from file purchased.de.ek.json
    Then the payload of this offer is shown on console
    And the payload for v3 offers/:offer_sku is shown on console
    And the payload of this enrollment code status is shown on console
    And the payload for v3 offers/signup/enrollment_key/:enrollment_key is shown on console
    And the payload for v3 codes/:code is shown on console