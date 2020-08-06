Feature: I want to test MMS site

  Background:
    Given login with associate account through url

  Scenario: Open Membership report
    Given click on membership report
    Then the membership report opened with correct title

  Scenario: verify that the user can back to Administrator Activities
    Given the user click on back to Administrator Activities
    Then the homepage of mms opened with correct address

  Scenario: Verify that the system display right text underneath the title that appropriate for the deposit membership
    Given login with deposit account through url
    Then this text should be displayed under the back link "You have a Deposit Membership. Accepted manuscripts by affiliated authors will have their APCs paid from your deposit unless you choose to exclude the manuscript. All APCs paid from the deposit also receive a discount."
    Then this text should be displayed under the first text "Your membership continues until your deposit is depleted. You can top up your deposit at any time. Contact memberships@hindawi.com."

  Scenario: Verify that the system display right text underneath the title that appropriate for the unlimitted membership
    Given login with unlimitted account through url
    Then this text should be displayed under the back link "You have an Unlimited Membership. The APCs of all accepted manuscripts are covered, unless you choose to exclude the submission."
    Then this text should be displayed under the first text "If you choose to renew your membership after the current term expires, your new annual charge will be scaled according to your published output."

  Scenario: Verify that the system display right text underneath the title that appropriate for the associate membership
    Given login with associate account through url
    Then this text should be displayed under the back link "You have an Associate Membership. This entitles all authors at your institution to a 10% discount on all Hindawi APCs."
    And check the dates the start date should be before the end date
    And check the text and verify that it is display the correct content

  Scenario: Verify that the user can search by valid Submission date range
    Given click on membership report
    Given the user enter valid submission date range from "2018-02-01" and to "2018-03-01"
    And click filter button
    Then the system should display the matched result

  Scenario: Verify that the user can search by valid Acceptance date range
    Given click on membership report
    Given the user enter valid acceptance date range from "2018-02-01" and to "2018-03-01"
    And click filter button
    Then the system should display the correct matched result

  Scenario: Verify that the system validate when the user search by invalid submission dates
    Given click on membership report
    Given the user enter invalid submission date from and to then the system should validate
      | Sub_from      | Sub_to        |
      | 20/12/2017    | 31/12/2017    |
      | 2017          | 2017          |
      | -12-20-2017   | -12-31-2017   |
      | !@#$%%        | !@#$%%        |
      | 1546464416314 | 54564564646   |
      | 20/20/2017    | 20/21/2017    |
      | 12/35/2017    | 12/36/2017    |
      | <><>asl<><>   | <><>asl<><>   |
      | 12/20/2018    | 12/12/2018    |
      | 12/20         | 12/31         |
      | 12/2017       | 12/2017       |
      | December 2017 | December 2017 |

  Scenario: Verify that the system validate when the user search by invalid acceptance dates
    Given click on membership report
    Given the user enter invalid acceptance date from and to then the system should validate
      | acc_from      | acc_to        |
      | 20/12/2017    | 31/12/2017    |
      | 2017          | 2017          |
      | -12-20-2017   | -12-31-2017   |
      | !@#$%%        | !@#$%%        |
      | 1546464416314 | 54564564646   |
      | 20/20/2017    | 20/21/2017    |
      | 12/35/2017    | 12/36/2017    |
      | <><>asl<><>   | <><>asl<><>   |
      | 12/20/2018    | 12/12/2018    |
      | 12/20         | 12/31         |
      | 12/2017       | 12/2017       |
      | December 2017 | December 2017 |

  Scenario: Verify that the user can search for "Accepted Manuscripts" by Status
    Given click on membership report
    Given the user select the status to be "Accepted"
    And click filter button
    Then the result should have ms with correct status

  Scenario: Verify that the user can search for "Published Manuscripts" by Status
    Given click on membership report
    Given the user select the status to be "Published"
    And click filter button
    Then the result should have ms with correct status

  Scenario: Verify that the user can search and display articles where corresponding author is affiliated to the account
    Given click on membership report
    And user click on check box
    And click filter button
    Then System should display all manuscripts where corresponding authors are affiliated to the account

  Scenario: Verify that the user can reset the result before search
    Given click on membership report
    Given the user enter valid submission date range from "2018-02-01" and to "2018-03-01"
    Given the user enter valid acceptance date range from "2018-02-01" and to "2018-03-01"
    Given the user select the status to be "Accepted"
    And user click on check box
    And the user click reset button
    Then the fields should be cleared

  Scenario: Verify that the user can reset the result after search
    Given click on membership report
    And note the full records in the table
    Given the user enter valid submission date range from "2018-02-01" and to "2018-03-01"
    And click filter button
    And the user click reset button
    Then the system should display the full set


#  Scenario: Verify that the user can export the result in excel sheet
#    Given click on membership report
#    And note the full records in the table
#    And the user click on export button
#    Then excel File automatically downloaded
#    And compare the excel file data with the result in the system
#    Then the data should be matched

  Scenario: Verify that the Membership Report is sorted by default by most recent submission date
    Given click on membership report
    And verify that the column of submission dates should be sorted by default by most recent submission date

  Scenario: Verify that the system display the right Manuscripts counter
    Given click on membership report
    Then verify that the counter display the correct no of result

#  Scenario: ccc
#    Given click on membership report
#    Given verify that the user email the corresponding author