Feature: Submitting new manuscript

  Background:
    Given Login to http://beta.mts.hindawi.com/login/

  # Scenario: Check the author can open all links on the Manuscript Submission page
  @emad
  Scenario: Verify that the author can submit a manuscript successfully
    Given Sign in using the email address mohamed.emad@hindawi.com and the password 123456
    And  Press on Sign In
    And  Click on Submit a Manuscript
    When Select Journal
    And  Choose 1 authors
    And  Add the data of the author, "Mohamed", "Emad", "mohamed.emad@hindawi.com", "Cairo University" and "Egypt" in row "0"
    And  Add title of the manuscript "New Manuscript"
    And  Choose the Article type "Research Article"
    And  Choose a manuscript file "D:\\Edit Manuscript Page_Use Case Diagram.pdf"
    And  Select the answers No, Yes, and Yes
    When Click Submit
    Then Thank You for Submitting Your Manuscript will be displayed

  Scenario: Verify that the submitting author can cancel his\her submission process
    When  Click on Submit a Manuscript
    When  Select Journal Sarcoma
    Then  Submission page open
    Given Choose 2 authors
    And   Add the data of the author, "Remon", "Refaat", "mohamed.emad@hindawi.com", "Cairo University" and "Egypt" in row "0"
    And   Add title of the manuscript "Welecome Ruby"
    And   Choose the Article type "Research Article"
    And   Choose a manuscript file "D:\\Edit Manuscript Page_Use Case Diagram.pdf"
    And   Select the answers No, Yes, and Yes
    Then  Click Cancel

  # Scenario: Verify that the system does not accept a manuscript with other format except PDF and Word
  # Scenario: Verify that the system does not accept manuscript submission without choose corresponding author
  # Scenario: Verify that the system clear the author's data when increase/decrease the number of co-authors
  Scenario: Verify that the system does not accept email address with more than one author
    When  Click on Submit a Manuscript
    When  Select Journal Sarcoma
    Then  Submission page open
    Given Choose 2 authors
    And   Add the data of the author, "Remon", "Refaat", "nouran.nagy@hindawi.com", "Cairo University" and "Egypt" in row "0"
    And   Add the data of the author, "Remon", "Refaat", "nouran.nagy@hindawi.com", "Cairo University" and "Egypt" in row "1"
    And   Add title of the manuscript "Welecome Ruby"
    And   Choose the Article type "Research Article"
    And   Choose a manuscript file "D:\\Edit Manuscript Page_Use Case Diagram.pdf"
    And   Select the answers No, Yes, and Yes
    When  Click Submit
    Then  You cannot add more than one author with the same email will be displayed

  Scenario: Verify that the system does not accept invalid email address
    When  Click on Submit a Manuscript
    When  Select Journal
    And   Choose 1 authors
    And   Add the data of the author, "Remon", "Refaat", "test", "Cairo University" and "Egypt" in row "0"
    Then I verify the appearance of "Invalid email format" error
      | Email                         |
      #| .email@example.com            |
      | plaintext                     |
      | plainaddress                  |
      | #@%^%#$@#$@#.com              |
      | @example.com                  |
      | <email@example.com>           |
      | email.example.com             |
      | email@example@example.com     |
    #| email.@example.com            |
    #| email..email@example.com      |
      | email@example.com (Joe Smith) |
    #| email@example                 |
    #| email@-example.com            |
      | email@example  .web           |
    #| email@example..com            |
      | email@   example.com          |


  Scenario: Verify that all mandatory data is required to fill
    When  Click on Submit a Manuscript
    When  Select Journal Sarcoma
    Then Please complete all required fields for each author will be displayed

  # Scenario: Verify that the submitting author should be the corresponding author in case of selecting only one author
  # Scenario: Verify that the system display validation message when the submitting author not enter his email on the required data
  # Scenario: Verify that the system make any manuscript submitted which included Sanctioned or Bad-debt author it's status as RTC
  # Scenario: Verify that the system make any manuscript submitted by Sanctioned or Bad-debt author it's status as RTC
  # Scenario: Verifying that submitting 3 Manuscripts or more at one journal will generate mail to the editorial staff
  # Scenario: Ensure that questions are displayed once the author selects certain types
  # Scenario: Verify that Justification field appears if select an answer that needs justification
  # Scenario: Check that the user who is submitting the Manuscript will be saved as a Submitting Author.
  # Scenario: Check that any author added to the Authors List and not registered, system will create an account form him and send him an email to reset the password
  # Scenario: Check that no repeated accounts will be created for previously registered authors
  # Scenario: Verify that once the author submit the manuscript the system assign EA/ES Specialist/Reviewers checker to the manuscript
  # Scenario: Verify that system provides information for each question.
  # Scenario: Verify that the system accepts a manuscript with format PDF and Word
  # Scenario: Verify that the author can upload supplementary File or Cover letter Optionally
  # Scenario: Verify that the system prevent submitting the manuscript without adding text to Justification field
  # Scenario: Verify that spot checker is assigned to the Manuscript once the author submit it on Vendor Journals and not assigned if submit on Hindawi journal
  # Scenario: Verify that system will view a link that redirects to Research Data Page in case user answers "No" for data availability question
  # Scenario: Verify that other questions will not view link that redirects to research data page
