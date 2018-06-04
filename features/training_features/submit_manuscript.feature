Feature: As I user, I want to submit my paper

  Background:
    Given I navigate to "http://beta.mts.hindawi.com"
    And I logged in with username "mohamedabdelmohsen1987@gmail.com" with password "123456"
    And I click on submit link

    Scenario: Test submit of a manuscript
      Given I click on "Abstract and Applied Analysis" link
      And I populate authors data using the following:
        | First Name | Last Name | Email Address                    | Affiliation | Country     | Corresponding Author |
        | M          | X         | W@g.com                          | 1           | Afghanistan | No                   |
        | O          | Y         | mohamedabdelmohsen1987@gmail.com | 2           | Australia   | Yes                  |
        | Z          | Z         | W@g.com                          | 3           | Cape Verde  | No                   |
      And I fill the field "Manuscript Title" with "Automation Case Study"
      And I select "Letter to the Editor" from Manuscript Type dropdown-list
      And I upload "test1.docx" file to the field "Manuscript File"
      And I upload "test2.docx" file to the field "Optional Cover Letter"
      And I upload "test3.docx" file to the field "Optional Supplementary Materials"

