@first
@second
Feature: As I user, I want to login

  Background:
    Given I navigate to "https://mts.hindawi.com"

  Scenario: Test invalid email login
    Given I enter username "mohamed@hindawi"
    And I enter password "123456"
    When I click on "Sign In" button
    Then I should see the error message "The email address or password you entered is incorrect."

  Scenario Outline: Test invalid email login
    Given I enter username "<username>"
    And I enter password "<password>"
    When I click on "Sign In" button
    Then I should see the error message "<error>"
    Examples:
      | username            | password | error                                                   |
      | mohamed@hindawi     | 123456   | The email address or password you entered is incorrect. |
      | mohamed@hindawi.com | 123456   | email address or password you entered is incorrect. |