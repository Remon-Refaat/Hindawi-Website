Feature: Verify that the user can open Edit Ms page

Background:
  Given I open http://beta.admin.mts.hindawi.com

@Sally
  Scenario: Open Edit Link
    And   I enter username sally.safwat@hindawi.com
    And   I click on Next button "identifierNext"
    And   I enter password Sally1411
    And   I click on Next button "passwordNext"
    When  I navigate to EA account http://beta.admin.mts.hindawi.com/auth/amr.yoseph@hindawi.com
    And   Staff Manuscripts is opened
    Then  I choose random MS and click on Edit Manuscript
    Then I log out


#  Scenario: Verify that the editorial can update MS successfully
#    And   I enter username sally.safwat@hindawi.com
#    And   I click on Next button "identifierNext"
#    And   I enter password Sally1411
#    And   I click on Next button "passwordNext"
#    When  I navigate to EA account http://beta.admin.mts.hindawi.com/auth/amr.yoseph@hindawi.com
#    And   Staff Manuscripts is opened
#    Then  I choose random MS and click on Edit Manuscript
#    And   I fill the field Manuscript Title with "Automation Case Study"
#    And   I select issue, Manuscript type, and recommendation from dropdown lists
#    And   I upload Manuscript PDF File, Additional File, Supplementary Materials "C:\Users\Sally.Safwat\RubymineProjects\EditMS\File\6837404.pdf"
#    And   I check on the radio buttons of conflicts of interest, data availability statement, funding statement, and Select the answers of the questions "No", "Yes", and "Yes"
#    When  I click  on Update
#    Then  Validation "Operation Completed Successfully." should be displayed

#  Scenario: Verify that the editorial can upload files of MS successfully
#    And   I enter username sally.safwat@hindawi.com
#    And   I click on Next button "identifierNext"
#    And   I enter password Sally1411
#    And   I click on Next button "passwordNext"
#    When  I navigate to EA account http://beta.admin.mts.hindawi.com/auth/nourhan.mabrouk@hindawi.com
#    And   Staff Manuscripts is opened
#    And   I choose random MS and click on Edit Manuscript
#    And   I upload Manuscript PDF File, Additional File, Supplementary Materials "C:\Users\Sally.Safwat\RubymineProjects\EditMS\File\6837404.pdf"
#    And   I click  on Update
#    Then  Validation "Operation Completed Successfully." should be displayed
#    And   Download additional file link should be displayed
#    And   Delete link should be displayed beside additional file
#    And   Delete link should be displayed beside supplementary materials
#    When  I Check new changes in MTs admin in MS details
##    Then  It should be updated in selected version
#    And   Check new changes in MTs website at editor/author/reviewer of this MS







