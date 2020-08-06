Feature: domain message Page

  Background: Login to mms admin site
    Given Navigate to "http://beta.admin.mms.hindawi.com"

  Scenario: Verify that the user redirects to Home from login
    Given   login As admin  with "Mai.fathy@hindawi.com" and "maft9384"
    When    Navigate to "http://beta.admin.mms.hindawi.com/auth/dalia.elrawy@hindawi.com"
    Then    The system should redirects to home page

  Scenario: Verify that the user can access the domain messages page
    Given   Open "Domain Messages" Page
    And     Click on "Coordinator Activities" link from container section
    And     Click on "Domain Messages" link from container section
    Then    The "Domain Messages" page should be opened

  Scenario: Check for the displayed URL on the domain messages page
    Given   Open "Domain Messages" Page
    And     Click on "Coordinator Activities" link from container section
    And     Click on "Domain Messages" link from container section
    Then    The "Domain Messages" should be displayed with the right URL


  Scenario: Verify that the The Institutions table displayed on domain messages
    Given   Open "Domain Messages" Page
    And     Click on "Coordinator Activities" link from container section
    And     Click on "Domain Messages" link from container section
    Then    The Institutions table should be displayed



  Scenario: Verify that the back to coordinator activities link displayed on domain messages
    Given   Open "Domain Messages" Page
    And     Click on "Coordinator Activities" link from container section
    And     Click on "Domain Messages" link from container section
    Then    The "Back to Coordinator Activities" link should be displayed


  Scenario: Verify that the number of institutions displayed above the institutions table
    Given   Open "Domain Messages" Page
    And     Click on "Coordinator Activities" link from container section
    And     Click on "Domain Messages" link from container section
    Then    The number of institutions should be displayed above the table

  Scenario: Check for the header of institutions table
    Given   Open "Domain Messages" Page
    And     Click on "Coordinator Activities" link from container section
    And     Click on "Domain Messages" link from container section
    Then    "Ser, Institution User, Domain Name, Message" should be as table headers


  Scenario: Verify that the institutions table sortable and ordered by serial.
    Given   Open "Domain Messages" Page
    And     Click on "Coordinator Activities" link from container section
    And     Click on "Domain Messages" link from container section
    Then    The table should be sortable and ordered by serial.


  Scenario: Verify the user can back to coordinator activities page, by clicking on "Back to Coordinator Activities" link
    Given   Open "Domain Messages" Page
    And     Click on "Back to Coordinator Activities" link
    Then   The system should be redirect to "Coordinator Activities" Page


  Scenario: Verify that the user can ordered each column by clicking on the arrow which displayed beside table headers
    Given  Open "Domain Messages" Page
    When   Click on arrow which displayed beside table headers for each column
    |Order By|
    |ASC|
    |DES|
    Then   The system should re-order the table right

  Scenario: Verify that the user can open edit message page
    Given  Open "Domain Messages" Page
    And    Click on "Edit Message" link for any Institution
    Then   The "Edit Domain Message" page should be opened


  Scenario: Check for the displayed URL on the edit domain messages page
    Given  Open "Domain Messages" Page
    And    Click on "Edit Message" link for any Institution
    Then   The "Edit Domain Message" should be displayed with the right URL

  Scenario: Verify that the back to domain messages link displayed on the edit message page
    Given  Open "Domain Messages" Page
    And    Click on "Edit Message" link for any Institution
    Then   The "Back to Domain Messages" link should be displayed

  Scenario: Verify that the user can back to domain message page, by clicking on "Back Domain Messages" link
    Given  Open "Domain Messages" Page
    And    Click on "Edit Message" link for any Institution
    And    Click on "Back Domain Messages" link
    Then   The system should be redirect to "Domain Messages" Page

  Scenario: Verify that the domain name field displayed on the edit message page
    Given   Open "Domain Messages" Page
    And     Click on "Edit Message" link for any Institution
    Then    "Domain Name:" field should be displayed


    Scenario: Verify that the domain name on edit domain message page same as domain name on institutions table
    Given  Open "Domain Messages" Page
    And    Click on "Edit Message" link for any Institution
    Then   The domain name on edit domain message page should be same as domain name on institutions table


  Scenario: Verify that the message field displayed on the edit message page
    Given   Open "Domain Messages" Page
    And     Click on "Edit Message" link for any Institution
    Then    "Message:" field should be displayed

  Scenario: Verify that  Message text box displayed on the edit message page
    Given   Open "Domain Messages" Page
    And     Click on "Edit Message" link for any Institution
    Then    Message text box should be displayed


  Scenario: Verify that the save button displayed on the edit message page
    Given   Open "Domain Messages" Page
    And     Click on "Edit Message" link for any Institution
    Then    "Save" button should be displayed

  Scenario: Verify that when the user click on save button the system back to domain messages page
    Given   Open "Domain Messages" Page
    And     Click on "Edit Message" link for any Institution
    And     Click on "Save" button
    Then    The system should be redirect to "Domain Messages" Page


  Scenario: Verify that the system retrieves the message from the update account page
    Given  Open "Domain Messages" Page
    And    Click on "Edit Message" link for any Institution
    And    Get the Domain Message on Update account from DB
   Then    The two messages should be the same



  Scenario Outline: Verify that when the IMC update the message, it will be updated on the update account page
    Given  Open "Domain Messages" Page
    And    Click on "Edit Message" link for any Institution
    And    "<update_by>" domain message
    And    Go to MMS site
    And    Open update account page
    Then   The domain message should be updated
    Examples:
      | update_by |
      | update    |
      | add new   |
      | delete    |


  Scenario Outline: Verify that If the institution updates the message on the update account page, it shall be updated on the domain messages page
    Given   Open "Domain Messages" Page
    And     Select random institution
    And     Go to MMS site
    And     Open update account page
    And     "<update_by>" message which displayed on update account page
    And     Open "Domain Messages" Page
    And     Open the Edit message page
    Then    The two messages should be the same
    Examples:
      | update_by |
      | update    |
      | add new   |
      | delete    |



















