Feature: EQS Spot Check

Scenario: Comment section in each spot check’s page is divided into Spot Check's items
Given The spot check is logged in the EQS
And He opens a new/returning manuscript
When He goes through all the pages of the manuscript.
Then Comment section in each spot check’s page is divided into Spot Check's items.

Scenario: The old non-editable comment (if it is found) is displayed by default without marking the check box of the item
Given The spot check is logged in the EQS
And He opens a returning manuscript
When Go to any page that has an old comment.
Then The old comment is displayed by default without marking the check box of the item and it is non-editable.

Scenario: A new editable comment box and "View All Comments" link are displayed only after marking the check box of any item
Given The spot check is logged in the EQS
And He opens a new/returning manuscript
And Go to any page
When Mark on a check box of any item
Then A new editable comment box and "View All Links Comments" link are displayed

Scenario: The old comment box displays the most recent comment only
Given The spot check is logged in the EQS
And He opens a returning manuscript
When Go to any page that has many old comments in the same item
Then The old comment box displays the most recent comment only

Scenario: If there were no previous comments the old comment box will not be displayed
Given The spot check is logged in the EQS
And He opens a new/returning manuscript
When Go to any page which does not have any old comments
Then The old comment box will not be displayed if there were no previous comments.

Scenario: The check boxes should reset in case of a returning manuscript that has a previous old comment
Given The spot check is logged in the EQS
And He opens a returning manuscript
When Go to any page that has an old comment
Then The check boxes are reset

Scenario: A link “All Pages Comments” is displayed in Page 15 which showing all the comments that were inserted in all pages by spot check
Given The spot check is logged in the EQS
And He opens a new/returning manuscript
And Add comments to many pages
When Go to page 15
And Press on the link “All Pages Comments”
Then A pop up box will be displayed and shows all the comments in the form of step/Item/Comment that were inserted in all pages by spot check.

Scenario: The comments inserted in page 15 is not displayed in “All Pages Comments”
Given The spot check is logged in the EQS
And He opens a new/returning manuscript
And Add comments to many pages
When Go to page 15 and add a comment
And Press on the link “All Pages Comments”
Then The link shows all the comments except for the comments inserted in page 15.

Scenario: A restriction message should appear when the spot check checks an item box and select proceed without inserting a comment
Given The spot check is logged in the EQS
And He opens a new/returning manuscript
When Mark on the check box of an item at any page
And Press on Next without adding text in the new comment box
Then A message will be displayed that "As an item check box is marked a comment is required".

Scenario: The system displays a confirmation message if there are comments in any of the pages while the spot Check decision is to Accept
Given The spot check is logged in the EQS
And He opens a new/returning manuscript
When Add comments to any pages
And Go to the action page
And Accept the decision
Then A confirmation message is displayed that "One or more pages contain comments, are you sure you want to Accept decision?"
When Press Cancel
Then "Cancel" button will not do any actions
When Press Yes
Then “Yes” button will proceed with Acceptance



Scenario Outline: sdff

  Given The "<username>" spot check "<password>" is logged in the EQS
  And He opens a new/returning manuscript
  When Add comments to any pages
  And Go to the action page
  And Accept the decision
  Then A confirmation message is displayed that "One or more pages contain comments, are you sure you want to Accept decision?"
  When Press Cancel
  Then "Cancel" button will not do any actions
  When Press Yes
  Then “Yes” button will proceed with Acceptance
  Examples:
    | username | password |
    | admin | 123 |
    | staff | 1223 |

