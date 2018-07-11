Feature: I want to test search manuscript in mts

  Background:
    Given open Admin MTS

  @noura
  Scenario: Login, Open Search Manuscript page, Assert on pages titles
    Given enter valid email
    And click next
    Given enter valid password
    And click next again
    Then Open Search Manuscript page and verify on the title

  Scenario: Verify that the user can back to general activities
    Given The user click on back to general activities
    Then The system redirect the user to Administrator Activities page

  Scenario: Verify that the system displays a validation message when the user click search without enter data
    Then a validation message should appear

  Scenario: Search by Valid Manuscript ID
    Given the user enter valid Manuscript number "4153829"
    And Click Search button
    Then the system will display the correct manuscript

  Scenario Outline: Test searching by invalid manuscript ID
    Given the user clear manuscript ID field and enter invalid data <invalid_id>
    Then The system display <error>
    Examples:
      | invalid_id  | error                            |
      | 1234567833  | Your search returned no results. |
      | Doaa        | Your search returned no results. |
      | #@$#%$^%&&^ | Your search returned no results. |
      | <><>Asl<><> | Your search returned no results. |
      | -4153829    | Your search returned no results. |

  #Error
  Scenario: Search with Valid Manuscript title
    Given the user enter valid Manuscript title
    Then the matched result is displayed


  Scenario: Search with Valid Manuscript Issue Name
    Given the user enter valid Manuscript Issue Name
    And  click on MS ID
    Then system displays correct issue name

  Scenario: Search by invalid Manuscript Issue Name
    Then enter invalid issue name
      | input           | error                            |
      | 123412312567833 | Your search returned no results. |
      | #@$#%$^%&&^     | Your search returned no results. |
      | <>noura<>       | Your search returned no results. |
      | -4153829        | Your search returned no results. |

  Scenario: Search with Valid Journal SubCode
    Given the user enter valid Journal SubCode
    Then system will display Journal SubCode

  Scenario: Search by invalid Journal SubCode
    Then enter invalid subcode
      | jsubcode        | subcodeerror                     |
      | 123412312567833 | Your search returned no results. |
      | #@$#%$^%&&^     | Your search returned no results. |
      | <>noura<>       | Your search returned no results. |
      | -4153829        | Your search returned no results. |


  Scenario: Search with Valid Manuscript Author
    Given the user enter valid Manuscript Author
    Then system will display correct Manuscript Author


  Scenario: Search with Valid  multi manuscript authors
    Given the user enter valid Manuscript Authors
    Then system will display correct Manuscript Authors


#error
  Scenario: Search by invalid Manuscript Author
    Then enter invalid authors
      | authors         | authrserror                      |
      | 123412312567833 | Your search returned no results. |
      | #@$#%$^%&&^     | Your search returned no results. |
      | <>noura<>       | Your search returned no results. |
      | -4153829        | Your search returned no results. |


  Scenario: Search with  valid Combination data
    Given the user enter valid data in Manuscript number "8950516"
    And the user enter valid data in Manuscript Author "Xiaowen Jiang"
    And the user enter valid data Journal SubCode "ECAM"
    Then the system will display the correct manuscript

  Scenario: Search by invalid Manuscript title, Manuscript issue & Manuscript issue name


    Then The system validate the following data
      | invalid_data             | error                            |
      | 123456783354165465464563 | Your search returned no results. |
      | Dodfgfdhghfbghgfdhbgfhaa | Your search returned no results. |
      | <><><<<<<<<<<<<<<Asl<><> | Your search returned no results. |
      | #@$#$#^%$^#%%$^%$%$^%&&^ | Your search returned no results. |


  Scenario: Verify that the user can select/clear all editorial recommendation
    Given Check select-clear all from editorial recommendation
    Then All editorial recommendation should be selected
    Then All editorial recommendation should be unselected

  Scenario: Search by one Editorial Recommendation
    Given The user select one of the Editorial Recommendation
    Then the system will display the correct recommendation

  Scenario: verify that system views correct results when select multi recommendation
    Given multi recommendations are selected Void and Reject
    And Click Search button
    Then the system will display correct recommendations "Void" and "Reject"

  Scenario: Test if the user can search by version number
    Given the user Choose "1" from drop down list
    Then All manuscripts which have one version shall be displayed

  Scenario:  Test that the default paging is 50
    Given page selection is "50"

  Scenario: Test if the user can search by manuscripts/page
    Given user Choose "10" from drop down list
    Then Results will be out of "10"

  Scenario: Test if the user can search by submission date
    Given the user Choose The submission date from "06/01/2018"
    Then System should display manuscripts submitted from the date enetered till now

  Scenario: Test if the user can search by submission from & to dates
    Given the user Choose The submission date from "04/01/2018"
    And the user Choose The submission date To "04/20/2018"
    Then System should display manuscripts submitted in that range

  Scenario: Test if the user can search by Decision From date
    Given the user Choose The decision date from "06/01/2018"
    Then System should display manuscripts decision from the date enetered till now

  Scenario: Test if the user can search by decision from & to dates
    Given the user Choose The decision date from "04/01/2018"
    And the user Choose The decision date To "04/20/2018"
    Then System should display manuscripts decision in that range

  Scenario: Test if the user can search by Decision To date
    Given  user Choose The decision date To "01/01/2015"
    Then System should display manuscripts decision till To date

  Scenario: Test if All Manuscripts should be selected by default
    Given check the manuscript status radio button
    Then the All Manuscripts should be selected by default

  Scenario: Test if the system display correct counter of results
    Given check the counter of results
    Then the counter should display the same number of rows

  Scenario: Test if the navigation works correctly
    Given the user select page number
    Then the page number should be selected

  Scenario: the user can sort search result
    Given the user click on header title
    Then the system should sort the result

  Scenario: the user can sort search result
    Given the user click on header titles and the system should sort the result
      | header                   | td |
      | Journal                  | 1  |
      | Issue                    | 2  |
      | Manuscript No.           | 3  |
      | Title & Authors          | 4  |
      | Editor                   | 5  |
      | Editorial Recommendation | 8  |
      | Elapsed Time             | 9  |


  Scenario: Test manuscript id is hyperlinked and opens MS details
    Given the user enter valid Manuscript number "4153829"
    And Click Search button
    Then check if manuscript id is hyperlinked
    And click on MS ID
    Then  MS details page is opened with MS "4153829" in title

  @noura
  Scenario: Verify that system views new manuscripts submitted
    Given new manuscript is submitted
    When user search by Manuscript ID
    And Click Search button
    Then the system will display the correct manuscript