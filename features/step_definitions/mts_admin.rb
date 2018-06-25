####################################################################################
########### Login, Open Search Manuscript page, Assert on pages titles #############
####################################################################################

Given /^open Admin MTS$/ do
  visit "http://beta.admin.mts.hindawi.com/"
end

Given /^enter valid email$/ do
  fill_in 'identifierId', :with => 'doaa.asl@hindawi.com'
end

Given /^click next$/ do
  page.find(:id, 'identifierNext').click
end

Given /^enter valid password$/ do
  sleep 1
  fill_in 'password', :with => 'Doaa2020'
end

Given /^click next again$/ do
  find(:xpath, '//*[@id="passwordNext"]/content/span').click
  sleep 3
end

Given /^Open Search Manuscript page and verify on the title$/ do
  page.find(:xpath, '//a[text()="Search Manuscripts"]').click
  page_address = find(:xpath, '//h1[contains(text(),"Search Manuscripts")]').text
  if page_address == "Search Manuscripts"
    puts "Search Manuscripts page opened"
  else
    puts "Wrong Page address"
  end
end

##################################################
############ Search with valid MS ID #############
##################################################

Given /^the user enter valid Manuscript number "(.*)"$/ do |id|
  step %Q{Open Search Manuscript page and verify on the title}
  @ms_id = id
  fill_in 'SearchFields_ManunscriptId', with: @ms_id
end

Given /^Click Search button$/ do
  page.find(:xpath, '//button[@id="submit"]').click
end

Then /^the system will display the correct manuscript$/ do
  result = find(:xpath, '//*[@id="MtsTable"]/tbody/tr/td[3]/div/a').text
  if result.include? "@ms_id"
    puts result
  end
end

############################################################
########### Search with Valid Manuscript title #############
############################################################

Given /^the user clear the field and enter valid data$/ do
  find(:xpath, '//*[@id="SearchFields_ManunscriptId"]').native.clear
  find(:xpath, '//html//td[@colspan="2"]//div[1]/input[1]').click
  find(:xpath, '//input[@id="SearchFields_Title"]').send_keys("Transmitter")
  step %Q{Click Search button}
end

Then /^matched result opened$/ do
  result = find(:xpath, '//div[@class="paper_title"]/b')
  result.each do |element|
    expect(element.text.include? 'Transmitter').to be_truthy
  end
end

Then /^Make sure that all fields are reset$/ do
  #element['value']
  # @tester.browser.find_element(:id => "id_of_text_field")['value'].should == 'test value'
  element = driver.first(:id, "Authors_AuthorList_0__FirstName")
  expect(element['value'].empty?).to be_truthy

end

##################################################################
########### Search with one Editorial Recommendation #############
##################################################################

Given /^The user select one of the Editorial Recommendation$/ do
  step %Q{Open Search Manuscript page and verify on the title}
  find(:xpath, "//input[@value='EdMajor']").set(true)
  step %Q{Click Search button}
end

Then /^the system will display the correct recommendation$/ do
  result = find(:xpath, '//html//tr[1]/td[8]').text
  expect(result).to eq("Consider after Major Changes")
end

################################################################
########### select/clear all editorial recommendation ##########
################################################################


Given /^Check select-clear all from editorial recommendation$/ do
  step %Q{Open Search Manuscript page and verify on the title}
  find(:xpath, "//input[@id='chkAll']").set(true)
end


Then /^All editorial recommendation should be selected$/ do
  errors = []
  within(:xpath, "//table[@class='search_recom']") do
    recommendations = all(:xpath, '//input[@name="checklistRecommendation"]')
    recommendations.each do |element|
      begin
        expect(element.checked?).to be_truthy
        puts "Recommendation Selected"
      rescue RSpec::Expectations::ExpectationNotMetError
        errors << "Errors #{element.text}"
      end
    end
  end
  puts errors
  expect(errors).to eq([])
end

Then /^All editorial recommendation should be unselected$/ do
  errors = []
  within(:xpath, "//table[@class='search_recom']") do
    recommendations = all(:xpath, '//input[@name="checklistRecommendation"]')
    recommendations.each do |element|
      begin
        !expect(element.checked?).to be_truthy
        puts "Recommendation Unselected"
      rescue RSpec::Expectations::ExpectationNotMetError
        errors << "Errors #{element.text}"
      end
    end
  end
  puts errors
  expect(errors).to eq([])
end

##############################################################
################## Search with empty fields ##################
##############################################################


Then /^a validation message should appear$/ do
  step %Q{Open Search Manuscript page and verify on the title}
  step %Q{Click Search button}
  validation = page.find(:xpath, '//*[@id="form0"]/div[3]/b').text
  if validation.include? "You must specify at least one field to search."
    puts validation
  end
end

##############################################################
################# Search with invalid MS ID ##################
##############################################################

Given /^the user clear manuscript ID field and enter invalid data (.*)$/ do |invalid_id|
  step %Q{Open Search Manuscript page and verify on the title}
  find(:xpath, '//*[@id="SearchFields_ManunscriptId"]').send_keys invalid_id
  step %Q{Click Search button}
end

Then /^The system display (.*)$/ do |error|
  result = find(:xpath, '//*[@id="form0"]/div[3]/b').text
  expect(result).to eq(error)
end

##############################################################
################ Search with invalid data ####################
##############################################################

Given /^the user clear the field and enter invalid data "(.*)"$/ do |invalid_data|
  step %Q{Open Search Manuscript page and verify on the title}
  find(:xpath, '//input[@id="SearchFields_Title"]').send_keys invalid_data
  find(:xpath, "//input[@id='SearchFields_IssueId']").send_keys invalid_data
  find(:xpath, '//input[@id="SearchFields_IssueDescr"]').send_keys invalid_data
  step %Q{Click Search button}
end

Then /^The system validate the following data$/ do |table|
  errors = []
  table.hashes.each do |row|
    visit 'http://beta.admin.mts.hindawi.com/admin/search.manuscripts/'
    step %Q{the user clear the field and enter invalid data "#{row['invalid_data']}"}

    begin
      result = find(:xpath, '//*[@id="form0"]/div[3]/b').text
      expect(result).to eq(row['error'])
    rescue
      errors << "I got the error #{row['error']} for value #{row['invalid_data']}"
      take_instant_screenshot('error')
    end
  end
  expect(errors).to eq []
end

##############################################################
################ Search with Submission date #################
##############################################################

Given /^the user Choose The submission date from (.*)$/ do |from|
  @fromdate= from
  step %Q{Open Search Manuscript page and verify on the title}
  fill_in 'SubmissionFrom', with: @fromdate
end

Then /^System should display manuscripts submitted from the date enetered till now$/ do
  step %Q{Click Search button}
  result = all(:xpath, '//a[@class="topopup"]')
  result.sample.click
  sleep 5
  submission_date = find(:xpath, "//td[contains(text(),'Submitted On')]//following-sibling::td").text
  puts submission_date
  date = Date.parse submission_date
  datefrom = Date.parse @fromdate
  puts date.strftime("%Y-%m-%d")
  datefrom.strftime("%Y-%m-%d")
  currentdate = Time.now.strftime("%Y-%m-%d")
  todaydate = Date.parse currentdate
  expect(date.between?(datefrom, todaydate)).to be_truthy
end

####################################################################
################ Search with Submission date range #################
####################################################################
#
# Problem !#

Given /^the user Choose The submission date To "(.*)"$/ do |to|
  @todate = to
  fill_in 'SubmissionTo', with: @todate
end

Then /^System should display manuscripts submitted in that range$/ do
  step %Q{Click Search button}
  result = all(:xpath, '//a[@class="topopup"]')
  result.sample.click
  sleep 5
  submission_date = find(:xpath, "//td[contains(text(),'Submitted On')]//following-sibling::td").text
  date = Date.parse submission_date
  datefrom = Date.parse @fromdate
  dateto = Date.parse @todate

  date.strftime("%Y-%m-%d")
  datefrom.strftime("%Y-%m-%d")
  dateto.strftime("%Y-%m-%d")

  expect(date.between?(datefrom, dateto)).to be_truthy
end
###############################################################
################## search by version number ###################
###############################################################

Given /^the user Choose "(.*)" from drop down list$/ do |version|
  step %Q{Open Search Manuscript page and verify on the title}
  select version, from: 'SearchFields_VersionNumber'
  find(:xpath, "//input[@value='EdMajor']").set(true)
  step %Q{Click Search button}
end

Then /^All manuscripts which have one version shall be displayed$/ do
  result = all(:xpath, '//a[@class="topopup"]')
  result.each do |element|
    expect(element.text.include? "v1").to be_truthy
  end
end

####################################################################################
############## Verify that the user can back to general activities #################
####################################################################################

Given ("The user click on back to general activities") do
  step %Q{Open Search Manuscript page and verify on the title}
  find(:xpath, '//*[@id="form0"]/div[2]/a').click
end

Then ("The system redirect the user to Administrator Activities page") do
  page_address = find(:xpath, "//h1[contains(text(),'Administrator Activities')]").text
  if page_address == "Administrator Activities"
    puts "The system direct the user to Administrator Activities page"
  else
    puts "Wrong directing"
  end
end