############
# Open MMS #
############

Given /^open mms site "(.*)"$/ do |url|
  visit url
end

#################
# Deposit Login #
#################

Given /^login with deposit account through url$/ do
  visit "http://beta.mms.hindawi.com/doaa.asl@hindawi.com/123456/openaccess@kcl.ac.uk"
end
####################
# Unlimitted Login #
####################

Given /^login with unlimitted account through url$/ do
  visit "http://beta.mms.hindawi.com/doaa.asl@hindawi.com/123456/tt.tt@tt.com"
end

###################
# associate Login #
###################

Given /^login with associate account through url$/ do
  visit "http://beta.mms.hindawi.com/doaa.asl@hindawi.com/123456/info@openaccess.cam.ac.uk"
end

##########################
# Open Membership Report #
##########################

Given /^click on membership report$/ do
  find(:xpath, "//*[@id='container']/div[6]/ul/li[1]/a").click
  sleep 5
end

Then /^the membership report opened with correct title$/ do
  page_address = find(:xpath, "//*[@id='container']/div[6]/h1").text
  begin
    expect(page_address).to eq("Membership Report")
    puts "The Page address displayed correctly as: #{page_address}"
  rescue
    puts "The Page address displayed wrongly as: #{page_address}"
  end
end
####################################
# back to Administrator Activities #
####################################

Given /^the user click on back to Administrator Activities$/ do
  step %Q{click on membership report}
  find(:xpath, "//a[contains(text(),'Back to Administrator Activities')]").click
  sleep 2
end
Then /^the homepage of mms opened with correct address$/ do
  page_address = find(:xpath, "//h1[contains(text(),'Administrator Activities')]").text
  begin
    expect(page_address).to eq("Administrator Activities")
    puts "The Page address displayed correctly as: #{page_address}"
  rescue
    puts "The Page address displayed wrongly as: #{page_address}"
  end
end

###############################
# correct text for each model #
###############################

Then /^this text should be displayed under the back link "(.*)"$/ do |first_text|
  step %Q{click on membership report}
  text_under_back_link = find(:xpath, "//body/div[@id='container']/div[@class='reading_area']/p[1]").text
  begin
    expect(text_under_back_link).to eq(first_text)
    puts "The system display the text of deposit model correctly: #{text_under_back_link}"
  rescue
    puts "The system display the text of deposit model wrongly: #{text_under_back_link}"
  end
end

Then /^this text should be displayed under the first text "(.*)"$/ do |second_text|
  text_under_first_text = find(:xpath, "//body/div[@id='container']/div[@class='reading_area']/p[2]").text
  begin
    expect(text_under_first_text).to eq(second_text)
    puts "The system display the text of deposit model correctly: #{text_under_first_text}"
  rescue
    puts "The system display the text of deposit model wrongly: #{text_under_first_text}"
  end
end

And /^check the dates the start date should be before the end date$/ do
  start_date = find(:xpath, "//div[@class='perf_pnts display_inl_block margin_b_12 margin_t_12 lock width_200px']//tbody//tr[1]//td[2]").text
  end_date = find(:xpath, "//div[@class='perf_pnts display_inl_block margin_b_12 margin_t_12 lock width_200px']//tbody//tr[2]//td[2]").text
  start = Date.parse start_date
  endd = Date.parse end_date
  if start < endd
    puts "the system display the start date #{start} is before end date #{endd}"
  else
    puts "the system display wrong dates interval"
  end
end

And /^check the text and verify that it is display the correct content$/ do
  x = "Accepted and Published Manuscripts"
  y = "By default, this table lists all accepted and published manuscripts that have been submitted since the start of your membership. Use the search tools to filter the view."
  z = 'Use the "Export to Excel" button to download the current list as a Microsoft Excel spreadsheet.'
  step %Q{login with deposit account through url}
  step %Q{click on membership report}
  text1 = find(:xpath, "//*[@id='container']/div[6]/form/div[3]").text
  puts expect(text1).to eq(x)
  text2 = find(:xpath, "//*[@id='container']/div[6]/form/p[1]").text
  puts expect(text2).to eq(y)
  text3 = find(:xpath, "//*[@id='container']/div[6]/form/p[2]").text
  puts expect(text3).to eq(z)
  step %Q{login with unlimitted account through url}
  step %Q{click on membership report}
  puts expect(text1).to eq(x)
  puts expect(text2).to eq(y)
  puts expect(text3).to eq(z)
  step %Q{login with associate account through url}
  step %Q{click on membership report}
  puts expect(text1).to eq(x)
  puts expect(text2).to eq(y)
  puts expect(text3).to eq(z)
end

##################################################################
# Verify that the user can search by valid Submission date range #
##################################################################

Given /^the user enter valid submission date range from (.*) and to (.*)$/ do |sub_from, sub_to|
  # step %Q{click on membership report}
  fill_in 'SubmissionDateFrom', with: sub_from
  fill_in 'SubmissionDateTo', with: sub_to
  @Submission_from = sub_from
  @Submission_to = sub_to
end

And /^click filter button$/ do
  find(:xpath, "//tbody//tr[5]//td[2]//input[1]").click
  sleep 2
end

Then /^the system should display the matched result$/ do
  from = Date.parse @Submission_from
  puts from.strftime("%Y-%m-%d")
  to = Date.parse @Submission_to
  puts to.strftime("%Y-%m-%d")

  sub_dates = all(:xpath, "//table[@class='table_border']//tr[@class='td_white' or @class='td_lightblue']//td[4]")
  x = sub_dates.sample
  sub = x.text
  submission_date = Date.parse sub
  puts submission_date.strftime("%Y-%m-%d")

  puts expect(submission_date).to be_between(from, to)
end

##################################################################
# Verify that the user can search by valid Acceptance Date range #
##################################################################

Given /^the user enter valid acceptance date range from (.*) and to (.*)$/ do |acc_from, acc_to|
  # step %Q{click on membership report}
  fill_in 'AcceptanceDateFrom', with: acc_from
  fill_in 'AcceptanceDateTo', with: acc_to
  @Acceptance_from = acc_from
  @Acceptance_to = acc_to
end

Then /^the system should display the correct matched result$/ do
  from = Date.parse @Acceptance_from
  puts from.strftime("%Y-%m-%d")
  to = Date.parse @Acceptance_to
  puts to.strftime("%Y-%m-%d")

  acc_dates = all(:xpath, "//table[@class='table_border']//tr[@class='td_white' or @class='td_lightblue']//td[5]")
  x = acc_dates.sample
  acc = x.text
  acceptance_date = Date.parse acc
  puts acceptance_date.strftime("%Y-%m-%d")

  puts expect(acceptance_date).to be_between(from, to)
end

######################################################################################
## Verify that the system validate when the user search by invalid submission dates ##
######################################################################################

Given /^the user enter invalid submission date from and to then the system should validate$/ do |table|
  # step %Q{click on membership report}
  table.hashes.each do |row|
    fill_in 'SubmissionDateFrom', with: row['sub_from']
    fill_in 'SubmissionDateTo', with: row['sub_to']
    step %Q{click filter button}

    errors = []
    result = find(:xpath, '//*[@id="container"]/div[6]/form/div[1]/ul/li').text
    begin
      expect(result).to eq("Please select a valid submission date range.")
      puts "Right Validation Message: #{result}"
    rescue
      errors << "I got wrong validation for value"
    end
    expect(errors).to eq []
  end
end

####################################################################################
# Verify that the system validate when the user search by invalid acceptance dates #
####################################################################################

Given /^the user enter invalid acceptance date from and to then the system should validate$/ do |table|
  # step %Q{click on membership report}
  table.hashes.each do |row|
    fill_in 'AcceptanceDateFrom', with: row['acc_from']
    fill_in 'AcceptanceDateTo', with: row['acc_to']
    step %Q{click filter button}

    errors = []
    result = find(:xpath, '//*[@id="container"]/div[6]/form/div[1]/ul/li').text
    begin
      expect(result).to eq("Please select a valid submission date range.")
      puts "Right Validation Message: #{result}"
    rescue
      errors << "I got wrong validation for value"
    end
    expect(errors).to eq []
  end
end

######################################################################################
# Verify that the user can search for "Accepted and Published Manuscripts" by Status #
######################################################################################

Given /^the user select the status to be "(.*)"$/ do |status|
  select status, from: "SelectedStatus"
  @selected_status = status
end

Then /^the result should have ms with correct status$/ do
  status_arr = []
  result = page.all("//tbody//td[11]")
  result.each do |res|
    x = res.text
    status_arr << x
  end
  puts status_got = status_arr.sample
  begin
    expect(status_got).to eq(@selected_status)
    puts "System display MS with #{@selected_status} status"
  rescue
    puts "System display wrong status"
  end
end

################################################################################################################
# Verify that the user can search and display articles where corresponding author is affiliated to the account #
################################################################################################################

And /^user click on check box$/ do
  find(:xpath, "//input[@id='IsCorresponding']").click
end

Then /^System should display all manuscripts where corresponding authors are affiliated to the account$/ do
  find(:xpath, "//tbody//tr[1]//td[6]//span[2]").hover
  puts icon_sample = find(:xpath, "//tbody//tr[1]//td[6]//span[2]//span[1]").text
  sub_domain = select_from_dbs("SELECT consortium.ConsortiumDomainsMembershipName [Consortium Name], consortium.ConsortiumCurrentModel [Consrotium Model],
domain.DomainName [Domain Name], DisplayValue [Display Value], details.DomainModelType [Domain Model], details.StartDate [Start Date], details.EndDate [End Date]
, details.DomainsMembershipUsersDetailsId
FROM dbo.ConsortiumDomainsMembership consortium
JOIN dbo.DomainsMembership domain ON domain.ConsortiumDomainsMembershipID = consortium.ConsortiumDomainsMembershipID
JOIN dbo.Domains ON Domains.DomainName = domain.DomainName
JOIN dbo.DomainsMembershipUsersDetails details ON details.DomainsMembershipId = domain.DomainsMembershipId
WHERE DisplayValue ='#{icon_sample}'
AND details.StartDate = (SELECT MAX(dDetails.StartDate) FROM dbo.DomainsMembershipUsersDetails dDetails WHERE dDetails.DomainsMembershipId = domain.DomainsMembershipId)
")
  sub_domain.each do |column|
    puts @model = column["Consrotium Model"]
  end
  toptext = find(:xpath, "//*[@id='container']/div[6]/p/b").text
  if toptext.include? @model
    puts "The corresponding author is affiliated to the account"
  end
end

#############################################
# Verify that the user can reset the search #
#############################################
And /^note the full records in the table$/ do
  z = []
  fullset = all(:xpath, "//tbody//tr//td[@align='center']")
  fullset.each do |res|
    x = res.text
    z << x
  end
  @full_record = z.length
end

And /^the user click reset button$/ do
  find(:xpath, "//input[@value='Reset']").click
  sleep 2
end

Then /^the fields should be cleared$/ do
  subfrom = find(:id, "SubmissionDateFrom")
  subto = find(:id, "SubmissionDateTo")
  accfrom = find(:id, "AcceptanceDateFrom")
  accto = find(:id, "AcceptanceDateTo")
  status = find(:xpath, "//select[@id='SelectedStatus']")
  iscorresponding = find(:xpath, "//input[@id='IsCorresponding']")
  begin
    expect(subfrom['value'] && subto['value'] && accto['value'] && accfrom['value'] && status['value']).to eq("")
    expect(iscorresponding.checked?).to be_falsey
    puts "Fields is cleared"
  rescue
    puts "Fields not cleared"
  end
end

Then /^the system should display the full set$/ do
  y = []
  after_res = all(:xpath, "//tbody//tr//td[@align='center']")
  after_res.each do |res|
    x = res.text
    y << x
  end
  record_after_res = y.length
  expect(record_after_res).to eq(@full_record)
  puts "the reset functionality is working well"
end

#########################################################################################
# Verify that the Membership Report is sorted by default by most recent submission date #
#########################################################################################

And /^verify that the column of submission dates should be sorted by default by most recent submission date$/ do
  @all_sub_dates = []
  sub_column = all(:xpath, "//table[@class='table_border']//tr[@class='td_white' or @class='td_lightblue']//td[4]")
  sub_column.each do |element|
    sub_dates = element.text
    @all_sub_dates << sub_dates
  end
  x = @all_sub_dates.sort.reverse
  puts expect(@all_sub_dates).to eq(x)
end

#########################################################################################
Given /^verify that the counter display the correct no of result$/ do
  counter = find(:xpath, "//*[@id='container']/div[6]/form/div[4]").text
  rows = all(:xpath, "//table[@class='table_border']//tbody//tr")
  records = rows.length
  searchrecords = records - 1
  puts searchrecords
  if counter.include?("#{searchrecords}")
    puts "System display the correct counter"
  else
    puts "The system display the WRONG counter"
  end
end
########################################################################################
Given /^verify that the user email the corresponding author$/ do
  find(:xpath, "//*[@id='container']/div[6]/form/table[2]/tbody/tr[1]/td[6]/a[1]").right_click.click("Copy email address")
  step %Q{I pause}
end
