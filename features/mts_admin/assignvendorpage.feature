Feature: Assign Journals to Vendors

  Background:
    Given Login into Admin MTS

  Scenario Outline: Verify that Assign Vendor page link shall be available on the main page of the Admin MTS.
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    Then "Assign Vendor" link is displayed in the main menu
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |

  Scenario Outline: Verify that the user can open Assign Vendor page from the main page of the Admin MTS.
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Open "Assign Vendor" page from the main menu
    Then "Assign Vendor" page is opened
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |

   Scenario Outline: Verify that Assign Vendor page link shall be available on the hover of the main page for Admin MTS.
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    Then "Assign Vendor" link is displayed in the hover menu
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |

  Scenario Outline: Verify that the user can open Assign Vendor page from the hover of the main page of the Admin MTS.
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Hover on the main menu of the page
    And Open "Assign Vendor" page from the hover
    Then "Assign Vendor" page is opened
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |

  Scenario Outline: Verify that Assign Vendor page link shall not be available on the main page of any other roles.
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    Then "Assign Vendor" page is not displayed in the main menu or in the hover menu
    Examples:
      | User                         |
      | nevin.amin@hindawi.com       |
      | emad.labib@hindawi.com       |
      | nada.nemr@hindawi.com        |
      | marwa.saad@hindawi.com       |
      | shaimaa.rady@hindawi.com     |
      | samir.mahmoud@hindawi.com    |
      | abdelzaher.zayed@hindawi.com |

  Scenario Outline: Verify that Assign Vendor page can not be opened by any other roles via the url.
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    Then "Assign Vendor" page does not opened for "<User>"
  Examples:
  |User|
  | nevin.amin@hindawi.com       |
  | emad.labib@hindawi.com       |
  | nada.nemr@hindawi.com        |
  | marwa.saad@hindawi.com       |
  | shaimaa.rady@hindawi.com     |
  | samir.mahmoud@hindawi.com    |
  | abdelzaher.zayed@hindawi.com |

  Scenario Outline: Verify that the search shall return only all results that contain the keywords
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Open "Assign Vendor" page from the main menu
    Then Search with "hys" and make sure that the displayed journals are only all results that contain the keywords
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |

  Scenario Outline: Verify that all search results contain the search keywords
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Open "Assign Vendor" page from the main menu
    And Search with "hys"
    Then The displayed journals' names contain the keyword "hys"
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |

  Scenario Outline: Verify that when the search returns no results, the system shall show a validation message
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Open "Assign Vendor" page from the main menu
    And Search with "ahmed"
    Then "No matching journal title!" message is displayed
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |

  Scenario Outline: Verify that when the user try to clear the search field from the keyboard, system shall show updated results
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Open "Assign Vendor" page from the main menu
    And Search with "ysi"
    Then The displayed journals' names contain the keyword "ysi"
    And Remove "i" from the search field
    Then The displayed journals' names contain the keyword "ys" and the number of journals is changed
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |


  Scenario Outline: Verify that when the user clear the search field from the keyboard, system shall show the full list of journals
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Open "Assign Vendor" page from the main menu
    And Check the list of journals before searching
    And Search with "hys"
    Then The displayed journals' names contain the keyword "hys"
    And Clear the search field
    Then The full list of journals will be displayed
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |

   Scenario Outline: Verify that list of journals is displayed alphabetically
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Open "Assign Vendor" page from the main menu
    Then The list of journals is displayed alphabetically
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |


  Scenario Outline: Verify that list of journals only list of active journals, not journals flagged as Ceased, Sold, or In test mode
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Make flag to journals as ceased, sold, in test mode
    And Open "Assign Vendor" page from the main menu
    Then journals "should not" be displayed in the list of journals
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |


  Scenario Outline: Verify that list of journals display only list of active journals
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Make flag to journals as active
    And Open "Assign Vendor" page from the main menu
    Then journals "should" be displayed in the list of journals
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |

  Scenario Outline: Verify that drop down list "Editorial Communication Vendor" is displayed next to each journal
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Open "Assign Vendor" page from the main menu
    Then Drop down list Editorial Communication Vendor is displayed next to each journal
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |

  Scenario Outline: Verify that drop down list "Editorial Communication Vendor" is displayed next to each journal after search
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Open "Assign Vendor" page from the main menu
    And Search with "hys"
    Then Drop down list Editorial Communication Vendor is displayed next to each journal
  Examples:
  | User                          |
  | angelina.ilievska@hindawi.com |
  | mahmoud.salah@hindawi.com     |

   Scenario: Verify that drop down list "Editorial Communication Vendor" contains "Hindawi", "SPI", and "SPS"
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    Then Drop down list contains the following "3" items:
      | vendor  |
      | Hindawi |
      | SPI     |
      | SPS     |

  #@issue
  Scenario: Verify that "Editorial Communication Vendor" contains "Hindawi", "SPI", and "SPS" after make change and press on Save
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Assign another vendor to a certain journal
    When Press on button Save
    Then The same Drop down list contains the following "3" items:
      | Vendor  |
      | Hindawi |
      | SPI     |
      | SPS     |

  @issue
  Scenario: Verify that the last saved selection in drop down list shall be displayed as the default selection
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Assign another vendor to a certain journal
    And Press on button Save
    Then The last saved selection in drop down list shall be displayed as the default selection

#  @issue
  Scenario: Verify that the user can return the previous selection in the drop down list
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Assign another vendor to a certain journal
    And Press on button Save
    When Return to the previous selected item
    And Press on button Save
    Then The previous selected item shall be displayed as the default selection

  Scenario: Verify that the page contains only one "Save" button
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    Then The page contains only one Save button

#  @issue

  Scenario: Verify that user shall be able to save the changes by clicking the Save button
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Assign another vendor to a certain journal
    When Press on button Save
    Then New vendor is saved

#  @issue
  Scenario: Verify that user shall be able to save the changes if he/she uses the search field firstly
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Search with "hys"
    And Assign another vendor to a certain journal
    When Press on button Save
    Then New vendor is saved

#  @issue
  Scenario: Verify that user shall be able to save multiple changes
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Assign another vendor to a certain journal
    And Assign another vendor to a different journal-1
    And Assign another vendor to a different journal-2
    When Press on button Save
    Then New vendor is saved for all journals

   Scenario: Verify that the button is active only if a modification is applied in drop down list
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Assign another vendor to a certain journal
    Then Save button is active

   Scenario: Verify that the button Save is not active if a modification is not applied in drop down list
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    Then Save button is inactive

  Scenario: Verify that the button is not active if the user chooses the same vendor which is already selected
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Open the drop down list and choose the same vendor which is already selected
    Then Save button is inactive

  Scenario: Verify that the button is not active if a modification is applied in drop down list and then return to first status
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Assign another vendor to a certain journal
    And Return the first vendor to the journal
    Then Save button is inactive

#  @issue
  Scenario: Verify that user can not save the changes by any other modification in the page
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And make any modifications in the page
    And Make refresh to the page
    Then No change is applied to the page

    Scenario: Verify that Editorial Communication Vendor in Summary Table displays only the following list
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    Then Editorial Communication Vendor in Summary Table displays only the following list
      | Vendor  |
      | Hindawi |
      | SPI     |
      | SPS     |

  Scenario: Verify that Summary Table displays Editorial Communication Vendor alphabetically
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    Then Summary Table displays Editorial Communication Vendor alphabetically


  Scenario: Verify that "Number of Journals Assigned" in Summary Table displays the total number of journals assigned to each vendor
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    Then Number of Journals Assigned column displays the total number of journals assigned to each vendor

  Scenario: Verify that "Number of Journals Assigned" is updated only upon clicking the Save button
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And check the total number of journals assigned to each vendor
    And Assign another vendor to a certain journal
    When Press on button Save
    Then Number of Journals Assigned column is updated only upon clicking the Save button

  Scenario Outline: Verify that the following accounts can view and edit the page
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Open "Assign Vendor" page from the main menu
    And Assign another vendor to a certain journal
    When Press on button Save
    Then The last saved selection in drop down list shall be displayed as the default selection
    Examples:
      | User                       |
      |angelina.ilievska@hindawi.com|
      | craig.raybould@hindawi.com |
      | luke.prescott@hindawi.com  |

  Scenario Outline: Verify that Commencing the date of changing the vendor of a given journal, manuscripts submitted to that journal shall be handled by the Editorial Assistants of the new vendor
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Assign another vendor to a certain journal
    And Press on button Save
    And Make a new submission 1 with type "<Type>" in "<Section>"
    And Auto-assign tool will assign EA for the submission 1
    Then Make sure that new submission 1 is assigned to the editorial assistant of vendor 1
Examples:
    |Type|Section|
    |Research Article|regular section|
    |Research Article|SI section     |


   Scenario: Verify that Save button is inactive for MTS Admin role (view-only mode)
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/mahmoud.salah@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    Then Save button is inactive

  Scenario: Verify that drop down list of all vendors is dimmed for MTS Admin role (view-only mode)
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/mahmoud.salah@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    Then Drop down list of all vendors is dimmed


  Scenario: Verify that confirmation message will be displayed upon successfully saved
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Assign another vendor to a certain journal
    And Press on button Save
    Then "Your changes have been saved successfully." message is displayed

  Scenario Outline: Filtration dropdown list contains Hindawi, SPI, SPS
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Open "Assign Vendor" page from the main menu
    Then Make sure that filtration dropdown list contains "Hindawi", "SPI", "SPS"
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |

  Scenario Outline: Filtration by drop down list will return all the journals assigned to this vendor
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Open "Assign Vendor" page from the main menu
    When Select one of the vendor from the drop down list
    Then All the journals assigned to this vendor will be displayed
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |

  Scenario Outline: User shall be able to search for a specific vendor using a dropdown list
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/<User>"
    And Open "Assign Vendor" page from the main menu
    When Select one of the vendor from the drop down list
    Then Only the journals assigned to this vendor will be displayed
    Examples:
      | User                          |
      | angelina.ilievska@hindawi.com |
      | mahmoud.salah@hindawi.com     |


  Scenario: Verify that user shall be able to save the changes if he/she uses the search via drop down list firstly
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    When Select one of the vendor from the drop down list
    And Assign another vendor to a certain journal after filtration
    When Press on button Save
    Then New vendor is saved

  Scenario: Verify that user shall be able to save the changes if he/she uses the search field and drop down list firstly
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    When Select one of the vendor from the drop down list
    And Search with "journal"
    And Assign another vendor to a certain journal after filtration
    When Press on button Save
    Then New vendor is saved

  @test
  Scenario: Verify that manuscripts submitted before the date of changing the vendor shall continue to be handled by the preceding vendor
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Assign another vendor to a certain journal
   And Press on button Save
    And Make a new submission 1 with type "Research Article" in "regular section"
    And Auto-assign tool will assign EA for the submission 1
    Then Make sure that new submission 1 is assigned to the editorial assistant of vendor 1
    When Assign another vendor to the same journal
   And Press on button Save
    And Make a new submission 2 with type "Research Article" in "regular section"
    And Auto-asign tool will assign EA for the submission 2
   Then Make sure that new submission 2 is assigned to the editorial assistant of vendor 2
   Then Make sure that new submission 1 is assigned to the editorial assistant of vendor 1


  Scenario: Verify that if the page is opened for two users on two browsers, only one action will be taken and the other will be disregarded
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Choose a certain journal-selected journal
    And In a new browser, navigate to "http://beta.admin.mts.hindawi.com/auth/craig.raybould@hindawi.com", Assign another vendor and Press on Save
    And Try to Assign the same vendor to the same journal at the first browser
    And Press on button Save
    Then Make sure that the journal is assigned to the correct vendor once in the database


  Scenario: Verify that Only the last saved selection is displayed for MTS Admin role (view-only mode)
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Assign another vendor to a certain journal
   And Press on button Save
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/mahmoud.salah@hindawi.com", open Assign vendor page and verify that the last saved selection is displayed

  Scenario Outline: Verify that free type submission in regular section will be assigned to certain editorial assistant
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Assign vendor "<New Vendor>" to a certain journal for vendor "<Previous Vendor>"
   And Press on button Save
    And Make a new submission 1 with type "Corrigendum" in "regular section"
    And Auto-assign tool will assign EA for the submission 1
    Then Make sure that new submission 1 is assigned to one of certain editorial assistant
    Examples:
    |New Vendor|Previous Vendor|
    |SPI       |Hindawi        |
    |SPS       |Hindawi        |
    |Hindawi   |SPI            |

  Scenario Outline: Verify that free type submission in SI section will be assigned to certain editorial assistant
    Given Navigate to "http://beta.admin.mts.hindawi.com/auth/angelina.ilievska@hindawi.com"
    And Open "Assign Vendor" page from the main menu
    And Assign vendor "<New Vendor>" to a certain journal for vendor "<Previous Vendor>"
    And Press on button Save
    And Make a new submission 1 with type "Corrigendum" in "SI section"
    And Auto-assign tool will assign EA for the submission 1
    Then Make sure that new submission 1 is assigned to one of certain editorial assistant
    Examples:
      |New Vendor|Previous Vendor|
      |SPI       |Hindawi        |
      |SPS       |Hindawi        |
      |Hindawi   |SPI            |





