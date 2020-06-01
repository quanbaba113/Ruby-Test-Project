Feature: Check the enrollment code operations on agena API
  In order to allow a agena client to use an enrollment_code
  As an agena client
  I want to exercise all operations (creation, redeem, unredeem) on them

  @ready @agena @enrollment_code_creation @slow
  Scenario Outline: Check if an enrollment code can be created with v1 API (the same that AST uses) for each offer on Seeds with status "activated"
  Given an agena client requests a new enrollment code based on each offer on <environment> in the same way AST does
  When an enrollment code is returned for every offer
  Then all the enrollment code state are activated

  Examples:
    |environment|
    | test1     |
    | pie1      |
    | stage1    |

  @ready @agena @enrollment_code_creation @slow
  Scenario Outline: Check if an enrollment code can be created with v2 api for each offer on Seeds with status "activated"
    Given an agena client requests a new enrollment code based on each offer on <environment>
    When an enrollment code is returned for every offer
    Then all the enrollment code state are activated

    Examples:
      |environment|
      | test1     |
      | pie1      |
      | stage1    |

  @ready @slow @agena @enrollment_code_creation @ui_gemini
  Scenario Outline: Check if an enrollment code can be used on Gemini when created with v2 API for US region
    Given an agena client requests enrollment codes based on an offer from US on <environment> in the same way AST does
    When each enrollment code is used on Gemini for the current region
    Then they're applied correctly, including with the correct plans

    Examples:
      |environment|
      | test1     |
      #| pie1      |
      #| stage1    |

  @ready @slow @agena @enrollment_code_creation @ui_gemini
  Scenario Outline: Check if an enrollment code can be used on Gemini when created with v2 API for CA region
    Given an agena client requests enrollment codes based on an offer from CA on <environment> in the same way AST does
    When each enrollment code is used on Gemini for the current region
    Then they're applied correctly, including with the correct plans

    Examples:
      |environment|
      | test1     |
      #| pie1      |
      #| stage1    |

  @ready @slow @agena @enrollment_code_creation @ui_gemini
  Scenario Outline: Check if an enrollment code can be used on Gemini when created with v2 API for UK region
    Given an agena client requests enrollment codes based on an offer from UK on <environment> in the same way AST does
    When each enrollment code is used on Gemini for the current region
    Then they're applied correctly, including with the correct plans

    Examples:
      |environment|
      | test1     |
      #| pie1      |
      #| stage1    |

  @ready @slow @agena @enrollment_code_creation @ui_gemini
  Scenario Outline: Check if an enrollment code can be used on Gemini when created with v2 API for ES region
    Given an agena client requests enrollment codes based on an offer from ES on <environment> in the same way AST does
    When each enrollment code is used on Gemini for the current region
    Then they're applied correctly, including with the correct plans

    Examples:
      |environment|
      | test1     |
      #| pie1      |
      #| stage1    |

  @ready @slow @agena @enrollment_code_creation @ui_gemini
  Scenario Outline: Check if an enrollment code can be used on Gemini when created with v2 API for FR region
    Given an agena client requests enrollment codes based on an offer from FR on <environment> in the same way AST does
    When each enrollment code is used on Gemini for the current region
    Then they're applied correctly, including with the correct plans

    Examples:
      |environment|
      | test1     |
      #| pie1      |
      #| stage1    |

  @ready @slow @agena @enrollment_code_creation @ui_gemini
  Scenario Outline: Check if an enrollment code can be used on Gemini when created with v2 API for DE region
    Given an agena client requests enrollment codes based on an offer from DE on <environment> in the same way AST does
    When each enrollment code is used on Gemini for the current region
    Then they're applied correctly, including with the correct plans

    Examples:
      |environment|
      | test1     |
      #| pie1      |
      #| stage1    |