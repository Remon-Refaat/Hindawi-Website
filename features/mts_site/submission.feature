Feature: MTS Submission Page

  @mohamed
  Scenario: Verify that the author can submit a manuscript successfully
    And  Click on "Submit a Manuscript"
    And Search on "An" and click on it
#    And Click on a journal
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | No                   |
      | Mohamed    | Emad      | mohamed.emad@hindawi.com | Cairo University | USA     | No                   |
      | Mai        | Fathy     | mai.fathy@hindawi.com    | Cairo University | Algeria | Yes                  |
    And Add title of the manuscript
    And Choose the Article type "Corrigendum"
    And Choose a file "test1.docx" for "ManuscriptFile"
    And Choose a file "test2.docx" for "CoverLetterReviewReport"
    And Choose a file "test3.docx" for "SupplementaryMaterial"
    And Select the answers of the questions "No", "Yes", and "Yes"
    When Press on "Submit"
    Then "Thank You for Submitting Your Manuscript" will be displayed

  Scenario: Verify that the system does not accept invalid email address
    And  Click on "Submit a Manuscript"
    And Search on "An" and click on it
    And   Choose "1" authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    |               | Cairo University | Egypt   | Yes                  |
    And Add title of the manuscript
    And Choose the Article type "Research Article"
    And Choose a file "test1.docx" for "ManuscriptFile"
    And Select the answers of the questions "No", "Yes", and "Yes"
    Then I verify the appearance of "Invalid email format" error
      | Email                  |
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

  Scenario: Verify that the user can open all links in the page

    And  Click on "Submit a Manuscript"
    And Search on "An" and click on it
    Then Click on all links and verify the title of the page
      | linkxpath    | pagexpath         | title                               |
      | //li[7]/a[1] | //div[2]/div[2]/p | Connecting Research and Researchers |
      | //li[7]/a[2] | //div[2]/div[2]/p | Connecting Research and Researchers |
      | //li[8]/a    | //h1              | Hindawi for Institutions            |
#      | //li[4]/a    | //h2              | Terms of Service                    |
#      | //li[5]/a    | //h2              | Privacy Policy                      |
#      | //li[6]/a    | //h2              | Article Processing Charges          |


  Scenario: Verify that the submitting author can cancel his\her submission process
    And  Click on "Submit a Manuscript"
    And Search on "An" and click on it
    Given Choose 2 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | No                   |
      | Mohamed    | Emad      | mohamed.emad@hindawi.com | Cairo University | Egypt   | No                   |
    And Add title of the manuscript
    And Choose the Article type "Review Article"
    And Choose a file "test1.docx" for "ManuscriptFile"
    And Choose a file "test2.docx" for "CoverLetterReviewReport"
    And Choose a file "test3.docx" for "SupplementaryMaterial"
    And Select the answers of the questions "No", "Yes", and "Yes"
    When Click on "Cancel"
    Then "Welcome Remon Refaat" will be displayed


  Scenario: Verify that the system does not accept a manuscript with other format except PDF and Word
    And  Click on "Submit a Manuscript"
    And Search on "An" and click on it
    Given Choose 2 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | Yes                  |
      | Mohamed    | Emad      | mohamed.emad@hindawi.com | Cairo University | Egypt   | No                   |
    And Add title of the manuscript
    And Choose the Article type "Letter to the Editor"
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
    And  Click on "Submit a Manuscript"
    And Search on "An" and click on it
    Given Choose 2 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | No                   |
      | Mohamed    | Emad      | mohamed.emad@hindawi.com | Cairo University | Egypt   | No                   |
    And Add title of the manuscript
    And Choose the Article type "Corrigendum"
    And Choose a file "test1.docx" for "ManuscriptFile"
    And Choose a file "test2.docx" for "CoverLetterReviewReport"
    And Choose a file "test3.docx" for "SupplementaryMaterial"
    And Select the answers of the questions "No", "Yes", and "Yes"
    When Press on "Submit"
    Then "Please select the corresponding author of the manuscript" will be displayed


  Scenario: Verify that the system clear the author's data when increase/decrease the number of co-authors
    And  Click on "Submit a Manuscript"
    And Search on "An" and click on it
    Given Choose 2 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | Yes                  |
      | Mohamed    | Emad      | mohamed.emad@hindawi.com | Cairo University | Egypt   | No                   |
    Given Choose 3 authors
    Then Make sure that all fields are reset



  Scenario: Verify that the system does not accept email address with more than one author
    And  Click on "Submit a Manuscript"
    And Search on "An" and click on it
    Given Choose 2 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | Yes                   |
      | Mohamed    | Emad      | remon.refaat@hindawi.com | Cairo University | Egypt   | No                   |
    And Add title of the manuscript
    And Choose the Article type "Corrigendum"
    And Choose a file "test1.docx" for "ManuscriptFile"
    And Select the answers of the questions "No", "Yes", and "Yes"
    When Press on "Submit"
    Then "You cannot add more than one author with the same email" will be displayed



  Scenario: Verify that all mandatory data is required to fill
    And  Click on "Submit a Manuscript"
    And Search on "An" and click on it
#    Given Choose 2 authors
#    Given Add the data of all authors
#      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
#      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | Yes                   |
#      | Mohamed    | Emad      | mohamed.emad@hindawi.com | Cairo University | Egypt   | No                   |
#    And Add title of the manuscript
#    And Choose the Article type "Corrigendum"
#    And Choose a file "test1.docx" for "ManuscriptFile"
#    And Select the answers of the questions "No", "Yes", and "Yes"
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
    #And I pause


  Scenario: Verify that the submitting author should be the corresponding author in case of selecting only one author
    And  Click on "Submit a Manuscript"
    And Search on "An" and click on it
    Given Choose 1 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | No                   |
    Then The submitting author should be the corresponding author automatic
    #And I pause


  Scenario: Ensure that questions are displayed once the author selects certain types
    And  Click on "Submit a Manuscript"
    And Click on "Advances in Hematology"
    Then System view questions with following types
      | Types                | Q1                                                    | A1    | Q2                                                                  | A2    | Q3                                                        | A3    |
      | Research Article     | Do any authors have conflicts of interest to declare? | true  | Have you included a data availability statement in your manuscript? | true  | Have you provided a funding statement in your manuscript? | true  |
      | Clinical Study       | Do any authors have conflicts of interest to declare? | true  | Have you included a data availability statement in your manuscript? | true  | Have you provided a funding statement in your manuscript? | true  |
      | Review Article       | Do any authors have conflicts of interest to declare? | true  | Have you included a data availability statement in your manuscript? | false | Have you provided a funding statement in your manuscript? | false |
      | Corrigendum          | Do any authors have conflicts of interest to declare? | false | Have you included a data availability statement in your manuscript? | false | Have you provided a funding statement in your manuscript? | false |
      | Letter to the Editor | Do any authors have conflicts of interest to declare? | true  | Have you included a data availability statement in your manuscript? | false | Have you provided a funding statement in your manuscript? | false |
    And Go to "Case Reports in Surgery"
    Then System view questions with following types
      | Types       | Q1                                                    | A1   | Q2                                                                  | A2    | Q3                                                        | A3    |
      | Case Report | Do any authors have conflicts of interest to declare? | true | Have you included a data availability statement in your manuscript? | false | Have you provided a funding statement in your manuscript? | false |
    And Go to "Advances in Bioinformatics"
    Then System view questions with following types
      | Types           | Q1                                                    | A1    | Q2                                                                  | A2    | Q3                                                        | A3    |
      | Resource Review | Do any authors have conflicts of interest to declare? | false | Have you included a data availability statement in your manuscript? | false | Have you provided a funding statement in your manuscript? | false |


  Scenario: Download the uploaded pdf file
    And  Click on "Submit a Manuscript"
    And Click on "Advances in Hematology"
    Given Choose 1 authors
    Given Add the data of all authors
      | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
      | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | No                   |
    And Add title of the manuscript
    And Choose the Article type "Corrigendum"
    And Choose a file "test1.docx" for "ManuscriptFile"
    And Select the answers of the questions "No", "Yes", and "Yes"
    When Press on "Submit"
    And Click the MS ID
    And Download the pdf file
    Then Verify that the file is downloaded

