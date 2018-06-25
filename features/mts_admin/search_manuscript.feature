Feature: I want to test search manuscript in mts

  Background:
    Given open Admin MTS

  Scenario: Login, Open Search Manuscript page, Assert on pages titles
    And enter valid email
    And click next
    And enter valid password
    And click next again
    And Open Search Manuscript page and verify on the title

  Scenario: Verify that the user can back to general activities
    Given The user click on back to general activities
    Then The system redirect the user to Administrator Activities page

  Scenario: Search by Valid Manuscript ID
    And the user enter valid Manuscript number "4153829"
    And Click Search button
    Then the system will display the correct manuscript

  Scenario: Search by one Editorial Recommendation
    And The user select one of the Editorial Recommendation
    Then the system will display the correct recommendation

  Scenario: Verify that the user can select/clear all editorial recommendation
    And Check select-clear all from editorial recommendation
    Then All editorial recommendation should be selected
    And Check select-clear all from editorial recommendation
    Then All editorial recommendation should be unselected

  Scenario: Verify that the system displays a validation message when the user click search without enter data
    Then a validation message should appear

  Scenario Outline: Test searching by invalid manuscript ID
    And the user clear manuscript ID field and enter invalid data <invalid_id>
    Then The system display <error>
    Examples:
      | invalid_id  | error                            |
      | 1234567833  | Your search returned no results. |
      | Doaa        | Your search returned no results. |
      | #@$#%$^%&&^ | Your search returned no results. |
      | <><>Asl<><> | Your search returned no results. |
      | -4153829    | Your search returned no results. |


  Scenario: Search by invalid Manuscript title, Manuscript issue & Manuscript issue name
    Then The system validate the following data
      | invalid_data             | error                            |
      | 123456783354165465464563 | Your search returned no results. |
      | Dodfgfdhghfbghgfdhbgfhaa | Your search returned no results. |
      | <><><<<<<<<<<<<<<Asl<><> | Your search returned no results. |
      | #@$#$#^%$^#%%$^%$%$^%&&^ | Your search returned no results. |

  Scenario: Test if the user can search by submission date
    When the user Choose The submission date from "06/01/2018"
    Then System should display manuscripts submitted from the date enetered till now

  Scenario: Test if the user can search by submission from & to dates
    When the user Choose The submission date from "04/01/2018"
    And the user Choose The submission date To "04/20/2018"
    Then System should display manuscripts submitted in that range

  Scenario: Test if the user can search by version number
    When the user Choose "1" from drop down list
    Then All manuscripts which have one version shall be displayed


  Scenario: Search by invalid Manuscript Issue Name
    Given Open Search Manuscript page and verify on the title
    Then enter invalid issue name
      | input           | error                            |
      | 123412312567833 | Your search returned no results. |
      | #@$#%$^%&&^     | Your search returned no results. |
      | <>noura<>       | Your search returned no results. |
      | -4153829        | Your search returned no results. |


  Scenario: Search by invalid Journal SubCode
    Given Open Search Manuscript page and verify on the title
    Then enter invalid subcode
      | jsubcode        | subcodeerror                     |
      | 123412312567833 | Your search returned no results. |
      | #@$#%$^%&&^     | Your search returned no results. |
      | <>noura<>       | Your search returned no results. |
      | -4153829        | Your search returned no results. |


  Scenario: Search by invalid Manuscript Author(s)
    Given Open Search Manuscript page and verify on the title
    Given enter invalid authors

      | authors         | authrserror                      |
      | 123412312567833 | Your search returned no results. |
      | #@$#%$^%&&^     | Your search returned no results. |
      | <>noura<>       | Your search returned no results. |
      | -4153829        | Your search returned no results. |
