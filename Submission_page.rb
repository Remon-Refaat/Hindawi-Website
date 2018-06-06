require 'selenium-webdriver'

path = Dir.pwd
chrome_path = path + '/resources/chromedriver.exe'
Selenium::WebDriver::Chrome::driver_path = chrome_path
driver = Selenium::WebDriver.for :chrome

driver.manage.timeouts.implicit_wait = 10
#Background
Given /^Login to (.*)$/ do |url|
  driver.get url
end
#Scenario 1
Given /^Sign in using the email address (.*) and the password (\d+)$/ do |username, password|
  driver.first(:id, 'Email').send_key(username)
  driver.first(:id, 'Password').send_key(password)
end
Given("Press on Sign In") do
  driver.first(:xpath, '//*[@id="container"]//tr[3]//input').click
end
When ("Click on Submit a Manuscript") do
  driver.find_element(:xpath, "//*[@id='container']/div[5]/div/ul/li[1]/a").click
end
# When /^Select Journal (.*)$/ do |journalname|
#   driver.find_element(:id, "myInput").send_key(journalname)
#   driver.find_element(:xpath, "//*[@id='myul']/ul[15]/li[1]/a").click
# end

When "Select Journal" do
  journals = driver.find_elements(:xpath, "//*[@id='myul']//a")
  journals[rand(journals.length)].click
end

Then ("Submission page open") do
  title = driver.first(:xpath, "//*[@id='container']/div[5]/h1").text
  expect(title).to eq('Manuscript Submission: Submit Your Manuscript')
end
#Scenario 2
Then ("Click Cancel") do
  driver.find_element(:xpath, "//*[@id='container']/div[5]/div/form/div[6]/a").click
end
#Scenario 3
And /^Choose (\d+) authors$/ do |authorsnum|
  begin
    driver.find_element(:xpath, "//*[@id='RegSection']/li/a").click
  rescue
    driver.first(:id, "Authors_SelectedAuthorCount").first(:xpath, "//div/select/option[#{authorsnum}]").click
  end
  driver.first(:id, "Authors_SelectedAuthorCount").first(:xpath, "//div/select/option[#{authorsnum}]").click
end
And /^Add the data of the author, "(.*)", "(.*)", "(.*)", "(.*)" and "(.*)" in row "(\d+)"$/ do |fname, lname, email, aff, country, rownum|
  driver.first(:id, "Authors_AuthorList_#{rownum}__FirstName").send_key(fname)
  driver.first(:id, "Authors_AuthorList_#{rownum}__LastName").send_key(lname)
  driver.first(:id, "Authors_AuthorList_#{rownum}__Email").send_key(email)
  driver.first(:id, "Authors_AuthorList_#{rownum}__Affiliation").send_key(aff)
  driver.first(:xpath, "//option[text()='#{country}']").click
end
And /^Add title of the manuscript "(.*)"$/ do |title|
  driver.first(:id, "Manuscript_Title").send_key(title)
end
And /^Choose the Article type "(.*)"$/ do |type|
  driver.first(:xpath, "//option[text()='#{type}']").click
end
And /^Choose a manuscript file "(.*)"$/ do |path|
  driver.first(:xpath, "//tr[3]/td[2]//input[@type = 'file']").send_keys(path)
end
And /^Select the answers (.*), (.*), and (.*)$/ do |answer1, answer2, answer3|
  driver.first(:id, "SubmissionQuestionList[0].Answer_#{answer1}").click
  driver.first(:id, "SubmissionQuestionList[1].Answer_#{answer2}").click
  driver.first(:id, "SubmissionQuestionList[2].Answer_#{answer3}").click
end
When("Click Submit") do
  driver.first(:xpath, "//*[@id='container']/div[5]/div/form/div[6]/input").click
end
Then /^(.*) will be displayed$/ do |message|
  expect(driver.first(:xpath, "//*[text()='#{message}']").text).to eq(message)
end

Then /^I verify the appearance of "(.*)" error$/ do |error, table|
  errors = []
  table.rows.each do |email|
    driver.first(:id, 'Authors_AuthorList_0__Email').clear
    driver.first(:id, 'Authors_AuthorList_0__Email').send_keys email
    step %Q{Click Submit}
    begin
      step %Q{#{error} will be displayed}
    rescue
      # puts "Failed step #{email}"
      errors << "Failed email #{email}"
    end
  end
  expect(errors).to be_nil
end

#Scenario 4
#Scenario 5
#Scenario 6
#Scenario 7
#Scenario 8






