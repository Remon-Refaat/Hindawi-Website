#############################
# Given
#############################
Given /^I navigate to "(.*)"$/ do |url|
  visit url
end

Given /^I enter username "(.*)"$/ do |username|
  # email = driver.first(:id, 'Email')
  # email.send_key username
  fill_in 'Email', :with => username
end

Given /^I enter password "(\d+)"$/ do |pass|
  # password = driver.first(:name, 'Password')
  # password.send_key pass
  fill_in 'Password', :with => pass
end


#############################
# When
#############################
When /^I click on "(.*)" button$/ do |button|
  # driver.first(:xpath, "//*[@value='Sign In']").click
  click_button button
end

When /^I click on "(.*)" link$/ do |link|
  click_link link
end

When /^I click on submit link$/ do
  within(:xpath, "//div[@class='reading_area']") do
    click_link 'Submit a Manuscript'
  end
end


#############################
# Then
#############################
Then /^I should see the error message "(.*)"$/ do |error|
  error_msg = page.first(:xpath, "//div[@class='validation-summary-errors']//li[1]").text
  expect(error_msg).to eq(error)
end

#############################
# And
#############################
And /^I logged in with username "(.*)" with password "(\d+)"$/ do |username, password|
  step %Q{I enter username "#{username}"}
  step %Q{I enter password "#{password}"}
  step %Q{I click on "Sign In" button}
end

And /^I populate authors data using the following:$/ do |table|
  i = 0
  table.hashes.each do |row|
    fill_in "Authors_AuthorList_#{i}__FirstName", :with => row['First Name']
    fill_in "Authors_AuthorList_#{i}__LastName", with: row['Last Name']
    fill_in "Authors_AuthorList_#{i}__Email", with: row['Email Address']
    fill_in "Authors_AuthorList_#{i}__Affiliation", with: row['Affiliation']
    select row['Country'], :from => "Authors_AuthorList_#{i}__CountryId"
    if row['Corresponding Author'].downcase == 'yes'
      choose "AuthorList[#{i}].IsCorresponding"
    end
    i=i+1
  end
  end

And /^I fill the field "(.*)" with "(.*)"$/ do |label, value|
  # fill_in "//div[contains(text(),'#{label}:')]/../following-sibling::td", :with => value
  fill_in label.gsub(' ', '_'), :with => value
end

And /^I select "(.*)" from Manuscript Type dropdown-list$/ do |option|
  select option, from: 'Manuscript_TypeId'
end

And /^I upload "(.*)" file to the field "(.*)"$/ do |file, field|
  find("//div[text()='#{field}:']/../following-sibling::td/input").send_keys "#{ENV['DATA_DIR']}/#{file}"
end