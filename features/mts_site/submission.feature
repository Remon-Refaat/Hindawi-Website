Feature: MTS Submission Page

  Background: Login to Submission Page
    Given Navigate to "http://beta.mts.hindawi.com/remon.refaat@hindawi.com/123456"
    And  Click on "Submit a Manuscript"
    And Select a random journal

  @not_finialized
  Scenario: Verify that the user can open all links in the page
    Then Click on all links and verify the title of the page
      | linkxpath    | pagexpath         | title                               |
      | //li[7]/a[1] | //div[2]/div[2]/p | Connecting Research and Researchers |
      | //li[7]/a[2] | //div[2]/div[2]/p | Connecting Research and Researchers |
      | //li[8]/a    | //h1              | Hindawi for Institutions            |
#      | //li[4]/a    | //h2              | Terms of Service                    |
#      | //li[5]/a    | //h2              | Privacy Policy                      |
#      | //li[6]/a    | //h2              | Article Processing Charges          |

  Scenario: Verify that the author can submit a manuscript successfully
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | No                   |
      | Mohamed    | Emad      | mohamed.emad@hindawi.com | Cairo University | USA     | No                   |
      | Mai        | Fathy     | mai.fathy@hindawi.com    | Cairo University | Algeria | Yes                  |
    And Add title of the manuscript
    And Select a random Article Type
    And Choose a file "test1.docx" for "ManuscriptFile"
    And Choose a file "test2.docx" for "CoverLetterReviewReport"
    And Choose a file "test3.docx" for "SupplementaryMaterial"
    And Select the answers of the questions "No", "Yes", and "Yes"
    When Press on "Submit"
    Then "Thank You for Submitting Your Manuscript" will be displayed
    And   Should be found on the Author Activities list with  "Under Review" Status

  Scenario: Verify that the submitting author can cancel his\her submission process
    Given Choose 2 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | No                   |
      | Mohamed    | Emad      | mohamed.emad@hindawi.com | Cairo University | Egypt   | No                   |
    And Add title of the manuscript
    And Select a random Article Type
    And Choose a file "test1.docx" for "ManuscriptFile"
    And Choose a file "test2.docx" for "CoverLetterReviewReport"
    And Choose a file "test3.docx" for "SupplementaryMaterial"
    And Select the answers of the questions "No", "Yes", and "Yes"
    When Click on "Cancel"
    Then "Welcome Remon Refaat" will be displayed

  Scenario: Verify that the system does not accept a manuscript with other format except PDF and Word
    Given Choose 2 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | Yes                  |
      | Mohamed    | Emad      | mohamed.emad@hindawi.com | Cairo University | Egypt   | No                   |
    And Add title of the manuscript
    And Select a random Article Type
    And Select the answers of the questions "No", "Yes", and "Yes"
    And Choose an invalid manuscript file type and Press on "Submit"
      | testi.bmp  |
      | testi.pptx |
      | testi.txt  |
      | testi.png  |
      | testi.mp3  |
      | testi.exe  |
      | testi.xlsx |

  Scenario: Verify that the system does not accept manuscript submission without choose corresponding author
    Given Choose 2 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | No                   |
      | Mohamed    | Emad      | mohamed.emad@hindawi.com | Cairo University | Egypt   | No                   |
    And Add title of the manuscript
    And Select a random Article Type
    And Choose a file "test1.docx" for "ManuscriptFile"
    And Choose a file "test2.docx" for "CoverLetterReviewReport"
    And Choose a file "test3.docx" for "SupplementaryMaterial"
    And Select the answers of the questions "No", "Yes", and "Yes"
    When Press on "Submit"
    Then "Please select the corresponding author of the manuscript" will be displayed

  Scenario: Verify that the system clear the author's data when increase/decrease the number of co-authors
    Given Choose 2 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | Yes                  |
      | Mohamed    | Emad      | mohamed.emad@hindawi.com | Cairo University | Egypt   | No                   |
    Given Choose 3 authors
    Then Make sure that all fields are reset

  Scenario: Verify that the system does not accept email address with more than one author
    Given Choose 2 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | Yes                   |
      | Mohamed    | Emad      | remon.refaat@hindawi.com | Cairo University | Egypt   | No                   |
    And Add title of the manuscript
    And Select a random Article Type
    And Choose a file "test1.docx" for "ManuscriptFile"
    And Select the answers of the questions "No", "Yes", and "Yes"
    When Press on "Submit"
    Then "You cannot add more than one author with the same email" will be displayed

  Scenario: Verify that the system does not accept invalid email address
    And   Choose "1" authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    |               | Cairo University | Egypt   | Yes                  |
    And Add title of the manuscript
    And Select a random Article Type
    And Choose a file "test1.docx" for "ManuscriptFile"
    And Select the answers of the questions "No", "Yes", and "Yes"
    Then I verify the appearance of "Invalid email format" error
      | Email                         |
      | plaintext                     |
      | plainaddress                  |
      | #@%^%#$@#$@#.com              |
      | @example.com                  |
      | <email@example.com>           |
      | email.example.com             |
      | email@example@example.com     |
      | email@example.com (Joe Smith) |
      | email@example  .web           |
      | email@   example.com          |


  Scenario: Verify that all mandatory data is required to fill
  Given Choose 2 authors
  When Press on "Submit"
    Then The following validation messages will be displayed
      | messages                                                 |
      | Please complete all required fields for each author      |
      | Please select the corresponding author of the manuscript |
      | Please enter the title of your manuscript                |
      | Please select a manuscript type                          |
      | Please upload the file of your manuscript                |
  Then Red asterisk is displayed beside the mandatory fields
    | FirstName   |
    | LastName    |
    | Email       |
    | Affiliation |


  Scenario: Verify that the submitting author should be the corresponding author in case of selecting only one author
    Given Choose 1 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | No                   |
    Then The submitting author should be the corresponding author automatic



  Scenario: Verify that the system display validation message when the submitting author not enter his email on the required data
    Given Choose 3 authors
  Given Add the data of all authors
      | First Name | Last Name | Email Address                    | Affiliation | Country     | Corresponding Author |
      | M          | X         | WORLD@g.com                      | 1           | Afghanistan | No                   |
      | O          | Y         | mohamedabdelmohsen1987@gmail.com | 2           | Australia   | Yes                  |
      | Z          | Z         | W@g.com                          | 3           | Cape Verde  | No                   |
  And Add title of the manuscript
  And Select a random Article Type
  And Choose a file "test1.docx" for "ManuscriptFile"
  And Select the answers of the questions "No", "Yes", and "Yes"
  When Press on "Submit"
  Then "Submission should be made by one of the authors of the article. Therefore your details should be included in the list of authors below" will be displayed

  Scenario Outline: Verifying that submitting 3 Manuscripts or more at one journal will generate mail to the editorial staff
    Given Select Journal "Abstract and Applied Analysis"
    Given Choose 1 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | Yes                  |
    And Add title of the manuscript
    And Select a random Article Type
    And Choose a file "<file>" for "<name>"
    And Select the answers of the questions "No", "Yes", and "Yes"
    When Press on "Submit"
    Then "Thank You for Submitting Your Manuscript" will be displayed
Examples:
  | file       | name           |
  | test1.docx | ManuscriptFile |
  | test2.docx | ManuscriptFile |
  | test3.docx | ManuscriptFile |
  | test4.docx | ManuscriptFile |


  Scenario: Verify that system provides information for each question.
    And Select a random Article Type
    And Hover on circles
    Then Information displayed


  Scenario Outline: Verify that the system accepts a manuscript with format PDF and Word
    Given Choose 1 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | Yes                  |
    And Add title of the manuscript
    And Select a random Article Type
    And Choose a file "<file>" for "ManuscriptFile"
    And Select the answers of the questions "No", "Yes", and "Yes"
    When Press on "Submit"
    Then "Thank You for Submitting Your Manuscript" will be displayed
  Examples:
  | file       |
  | test1.docx |
  | test1.doc  |
  | test1.pdf  |
  | test1.rtf  |



  Scenario Outline: Verify that the system make any manuscript submitted which included Sanctioned or Bad-debt author it's status as RTC
    Given    Set the "remon.refaat@hindawi.com" as "<table>"
     And     Choose 2 authors
     And     Add the data of all authors
       | First Name | Last Name | Email Address            | Affiliation | Country     | Corresponding Author |
       | M          | X         | remon.refaat@hindawi.com | 1           | Afghanistan | No                   |
       | O          | Y         | ali_sltani4@yahoo.com    | 2           | Australia   | Yes                  |

    And   Add title of the manuscript
    And   Select a random Article Type
    And   Choose a file "test1.docx" for "ManuscriptFile"
    And   Select the answers of the questions "No", "Yes", and "Yes"
    And   Press on "Submit"
    And   Delete "remon.refaat@hindawi.com" From "<table>" table
    Then  "Thank You for Submitting Your Manuscript" will be displayed
    And   Should be found on the Author Activities list with  "Rejected" Status

  Examples:
    | table      |
    | Bad-debt   |
    | Sanctioned |


  Scenario Outline: Verify that the system make any manuscript submitted by Sanctioned or Bad-debt author it's status as RTC
    Given   Set the "remon.refaat@hindawi.com" as "<table>"
    And     Choose 1 authors
    And     Add the data of all authors
      | First Name | Last Name | Email Address             | Affiliation | Country     | Corresponding Author |
      | O          | Y         | remon.refaat@hindawi.com    | 2           | Australia   | Yes                  |
    And   Add title of the manuscript
    And   Select a random Article Type
    And   Choose a file "test1.docx" for "ManuscriptFile"
    And   Select the answers of the questions "No", "Yes", and "Yes"
    And   Press on "Submit"
    And   Delete "remon.refaat@hindawi.com" From "<table>" table
    Then "Thank You for Submitting Your Manuscript" will be displayed
    And   Should be found on the Author Activities list with  "Rejected" Status
    Examples:
      | table      |
      | Bad-debt   |
      | Sanctioned |

  Scenario: Ensure that questions are displayed once the author selects certain types
    Given   Select Journal "Advances in Medicine"
    And     I verify the appearance of questions
      | type                 |questions|
      | Review Article      |  Do any authors have conflicts of interest to declare?       |
      | Letter to the Editor|  Do any authors have conflicts of interest to declare?       |
      | Research Article    |  Do any authors have conflicts of interest to declare?, Have you included a data availability statement in your manuscript?, Have you provided a funding statement in your manuscript?     |
      | Clinical Study      |  Do any authors have conflicts of interest to declare?, Have you included a data availability statement in your manuscript?, Have you provided a funding statement in your manuscript?           |
    And      back to Submit a Manuscript page
    And      Select Journal "Case Reports in Critical Care"
    And     I verify the appearance of questions
      | type                 |questions|
      | Case Report          |  Do any authors have conflicts of interest to declare? |


  Scenario: Verify that Justification field appears if select an answer that needs justification
    Given    Select Journal "Advances in Medicine"
    And      I verify the appearance of text box to enter your justification
      | type                 | q1  | q2 | q3 |
      | Research Article     | Yes | No | No |
      | Letter to the Editor | Yes |    |    |
      | Review Article       | Yes |    |    |
      | Clinical Study       | Yes | No | No |
    And  back to Submit a Manuscript page
    And  Select Journal "Case Reports in Critical Care"
    And     I verify the appearance of text box to enter your justification
      | type        | q1  |
      | Case Report | Yes |


  Scenario: Verify that the system prevent submitting the manuscript without adding text to Justification field
    Given   Choose "1" authors
    And     Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation | Country     | Corresponding Author |
      | M          | X         | remon.refaat@hindawi.com | 1           | Afghanistan |                    |
    And   Add title of the manuscript
    And   Select a random Article Type
    And   Choose a file "test1.docx" for "ManuscriptFile"
    And   Select the answers of the questions "Yes", "No", and "No"
    And   Press on "Submit"
    Then  "Please complete the submission questions answers." will be displayed


  Scenario: Check that the user who is submitting the Manuscript will be saved as a Submitting Author.
    Given   Choose "2" authors
    And     Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation | Country     | Corresponding Author |
      | Remon      | Refaa     | remon.refaat@hindawi.com | 1           | Afghanistan | No                   |
      | Mai        | Fathy     | Mai.fathy@hindawi.com    | test        | Afghanistan | Yes                  |
    And   Add title of the manuscript
    And   Select a random Article Type
    And   Choose a file "test1.docx" for "ManuscriptFile"
    And   Select the answers of the questions "No", "Yes", and "Yes"
    And   Press on "Submit"
    Then "Thank You for Submitting Your Manuscript" will be displayed
    And   Should be found on the Author Activities list with  "Under Review" Status
    And   Open manuscript details page
    Then  The submitting author "remon.refaat@hindawi.com" should be the displayed with bold style
