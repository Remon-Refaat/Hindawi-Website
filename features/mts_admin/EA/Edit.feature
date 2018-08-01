Feature: Verify that the user can open Edit Ms page

  Background:
    Given I open http://beta.admin.mts.hindawi.com
    And I login to Admin MTS

  Scenario: Verify that back to Ms details is worked correctly
    When  I navigate to EA account http://beta.admin.mts.hindawi.com/auth/amr.yoseph@hindawi.com
    And   Staff Manuscripts is opened
    And   I choose random MS and click on Edit Manuscript
    Given click on "Back to Manuscript Details" to Ms details

  Scenario: Verify that the editorial can update MS successfully
    When  I navigate to EA account http://beta.admin.mts.hindawi.com/auth/amr.yoseph@hindawi.com
    And   Staff Manuscripts is opened
    Then  I choose random MS and click on Edit Manuscript
    And   I fill the field Manuscript Title with "Automation Case Study"
    And   I select issue, Manuscript type, and recommendation from dropdown lists
    And   I upload Manuscript PDF File, Additional File, Supplementary Materials
    And   I check on the radio buttons of conflicts of interest, data availability statement, funding statement, and Select the answers of the questions "No", "Yes", and "Yes"
    When  I click  on Update
    Then  Validation "Operation Completed Successfully." should be displayed

  Scenario: Verify that a validation message is displayed when removing MS title
    When  I navigate to EA account http://beta.admin.mts.hindawi.com/auth/amr.yoseph@hindawi.com
    And   Staff Manuscripts is opened
    And   I choose random MS and click on Edit Manuscript
    Given  i delete ms title

  Scenario: Verify that a validation message is displayed when uploading invalid files
    When  I navigate to EA account http://beta.admin.mts.hindawi.com/auth/amr.yoseph@hindawi.com
    And   Staff Manuscripts is opened
    And   I choose random MS and click on Edit Manuscript
    Given  I Uplaod invalid files in this fileds Manuscript PDF File and Additional File

  Scenario: Verify that the system does not proceed unless the admin answers all the question
    Given  Select research article ms and navigate to EA account and validate completion of answers of Questions


   Scenario: Verify that the editorial can upload files of MS successfully
    When   I choose ms from db
     And   I upload Manuscript PDF File, Additional File, Supplementary Materials
    And   I click  on Update
    Then  Validation "Operation Completed Successfully." should be displayed
    And   Download additional file link should be displayed
    And   Delete link should be displayed beside additional file
    And   Delete link should be displayed beside supplementary materials
    And   I download MS PDF
    When  I Check new changes in MTs admin in MS details
    Then   Check new changes in MTs website at editor-author-reviewer of this MS


  Scenario: Verify that the editorial staff can't update MS with IsPublished flag
    And   select MS that takes flag of is published and get the email address that handle the paper from DB
    When  I navigate to EA account
    Then Edit link should not be appeared


  Scenario: Verify that the editorial staff can upload and dowenload then delete Additional files
    When  I navigate to EA account http://beta.admin.mts.hindawi.com/auth/amr.yoseph@hindawi.com
    And   Staff Manuscripts is opened
    And   I choose random MS and click on Edit Manuscript
    Given  I can upload and dowenload the Additional


  Scenario: Verify that the editorial staff can delete Additional File/Supplementary Materials file
    When  I navigate to EA account http://beta.admin.mts.hindawi.com/auth/amr.yoseph@hindawi.com
    And   Staff Manuscripts is opened
    And   I choose random MS and click on Edit Manuscript
    Given i can delete file


  Scenario: Verify that the admin can edit the selection and comments for COI, DA, Funding Statement(s)
    When  I navigate to EA account http://beta.admin.mts.hindawi.com/auth/amr.yoseph@hindawi.com
    And   Staff Manuscripts is opened
    And   I choose random MS and click on Edit Manuscript
    Given admin can edit the selection from Yes to No and vice versa
    And Assert that DB save the new answers as well as the old ones


  Scenario: Verify that EA can make Not finalized if the MS is flagged re-review from any EA or Editorial recommendation
    Given Choose ms which is flagged as re-review
    And   login as EA who handle this ms
    Then  assert that Not Finalized is allowed in Recommendation dropdown list


  Scenario: Verify that all dates of the Not Finalized recommendation will be saved in the DB
    Given I logged as EQA
    And   I check that MS Re-review date is the same date of checking the re-review link
    Given I logged as EA who handles the ms and changed the recommendation to Not Finalized


  Scenario: Verify that after making the recommendation not finalized for re-review, reminders that sent to the editors will be on hold
    Given For a re-review MS, EA change the recommendation to Not finalized
    Then  Reminders “Editor Not Decision After Completed Reviews​ and Editor Not Decision After Minor Rev”​ shall be on hold


  Scenario: Verify that all drop down menu data is correct
    When I navigate to EA account http://beta.admin.mts.hindawi.com/auth/amr.yoseph@hindawi.com
    Then I choose a  specific journal and I check if the dropdown lists of Issues and MS types are following this journal


  Scenario: verify that EA cant upload supplementary materials after assign material checker and not paused on any reason
    Given I choose approved ms



