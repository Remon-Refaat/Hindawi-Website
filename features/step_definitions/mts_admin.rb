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

Given /^the user Choose The submission date from "(.*)"$/ do |from|
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
  datefrom = Date.strptime(@fromdate, "%m/%d/%Y")
  dateto = Date.strptime(@todate, "%m/%d/%Y")

  date.strftime("%Y-%m-%d")
  datefrom.strftime("%Y-%m-%d")
  dateto.strftime("%Y-%m-%d")

  puts "#{datefrom}, #{dateto}"
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
<<<<<<< HEAD
####################################################################################
##Search by invalid Manuscript Issue Name##

Then /^enter invalid issue name$/ do |table|
  errors = []
  table.hashes.each do |row|
    find(:id, "SearchFields_IssueDescr").native.clear
    find(:id, "SearchFields_IssueDescr").send_keys row['input']
    step %Q{Click Search button}
    error_message = find(:xpath, "//b").text
    begin
      expect(row['error'] == error_message).to be_truthy
    rescue RSpec::Expectations::ExpectationNotMetError
      errors << "I was expecting #{row['error']} for value #{row['Input']}"
    end
  end
  expect(errors).to eq([])
end
#######################################################################################
##Search by invalid Manuscript Journal SubCode##
Given /^enter invalid subcode$/ do |table|
  errors2 = []
  table.hashes.each do |row|
    find(:xpath, "//*[@id='SearchFields_IssueDescr']").native.clear
    find(:id, "SearchFields_JournalSubCode").native.clear
    find(:id, "SearchFields_JournalSubCode").send_keys row['jsubcode']
    step %Q{Click Search button}
    error_message = find(:xpath, "//b").text
    begin
      expect(row['subcodeerror'] == error_message).to be_truthy
    rescue RSpec::Expectations::ExpectationNotMetError
      errors2 << "I was expecting #{row['subcodeerror']} for value #{row['jsubcode']}"
    end
  end
  expect(errors2).to eq([])
end
#########################################################################################
##Search by invalid Manuscript Manuscripts Author(s)##
Given /^enter invalid authors$/ do |table|
  errors3 = []
  table.hashes.each do |row|
    find(:id, "SearchFields_JournalSubCode").native.clear
    find(:id, "SearchFields_AuthorsName").native.clear
    find(:id, "SearchFields_AuthorsName").send_keys row['authors']
    step %Q{Click Search button}
    error_message = find(:xpath, "//b").text
    begin
      expect (row['authorserror'] == error_message).to be_truthy
    rescue
      errors3 << "I was expecting #{row['authorserror']} for value #{row['authors']}"
    end
  end
  expect(errors3).to eq ([])
end

=======







###############EDit MS##################################
#


Given /^I open (.*)$/ do |url|
  visit url
end

Given /^I enter username (.*)$/ do |username|
  email = page.first("//div//input[@type='email']")
  email.send_keys username

end

Given /^I click on Next button "(.*)"$/ do |btn|
  page.find("//*[@id='#{btn}']/content/span").click
  sleep 2
end


Given /^I enter password (.*)$/ do |pass|
  passw = page.first("//input[@type='password']")
  passw.send_keys pass
end


# And /^I pause$/ do
#   print "Press any key to continue ...."
#   STDIN.getc
# end


Given /^I navigate to EA account (.*)$/ do |url|
  visit url
  sleep 1
end


Given("Staff Manuscripts is opened") do
  # page.driver.browser.action.move_to(page.find("//a[@href='/editorial.staff/']").native).perform
  page.find(:xpath, "//a[@href='/editorial.staff/']").hover
  page.find("//*[@id='ctl00_NavigationBar1_LeftNavBar']/div/ul/li/ul/li[5]/a").click
end

# When("I Click on MS ID randomly") do
#
#   page.all("//table[@id='MtsTable']/tbody/tr/td[3]/a").sample.click
#      sleep 2
# end


When("I choose random MS and click on Edit Manuscript") do
  loop do
    page.all("//table[@id='MtsTable']/tbody/tr/td[3]/a").sample.click
    sleep 1
    break if page.has_selector?("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]")
    page.evaluate_script('window.history.back()')
  end
  page.find("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]/a").click
end

# Given ("I log out") do
# page.find("//*[@id='hindawi_links']/ul/li[2]/a").click
# end



####### Scenario 2: Verify that EA can update manuscripts details successfully  ################

Given("I logged as EA") do
  step %Q{I navigate to EA account "#{url}"}
end

Given("I opened Edit Manuscript") do
  step %Q{Staff Manuscripts is opened}
  step %Q{I choose random MS and click on Edit Manuscript}

end
#
Given /^I fill the field Manuscript Title with (.*)$/ do |value|
  # fill_in "//div[contains(text(),'#{label}:')]/../following-sibling::td", :with => value
  #  fill_in label.gsub(' ', '_'), :with => value
  fill_in 'MsTitle', with: value

  sleep 1
end

Given("I select issue, Manuscript type, and recommendation from dropdown lists") do

  find(:id, 'SelectedIssueId').all(:css, 'option')[rand(10)].select_option
  sleep 4
  type = find(:id, 'SelectedMsTypeId').all(:css, 'option')[rand(10)].select_option
  puts @mstype = type.text
  sleep 3
  find(:id, 'SelectedRecommendationId').all(:css, 'option')[rand(10)].select_option
  sleep 3
end


Given /^I upload Manuscript PDF File, Additional File, Supplementary Materials "(.*)"$/ do |path|
  page.find("//*[@id='form0']/table/tbody/tr[6]/td[2]/input[@type = 'file']").send_keys(path)
  sleep 2

  page.find("//*[@id='form0']/table/tbody/tr[7]/td[2]/input[@type = 'file']").send_keys(path)

  sleep 2
  page.find("//*[@id='form0']/table/tbody/tr[8]/td[2]/input[@type = 'file']").send_keys(path)

  @supplementary = 'ssssssssssssssssssssssssssss'
  find("//*[@id='SupplementaryDescr']").send_keys(@supplementary)
  sleep 2

end

Given /^I check on the radio buttons of conflicts of interest, data availability statement, funding statement, and Select the answers of the questions "(.*)", "(.*)", and "(.*)"$/ do |ans1, ans2, ans3|
  types = ["Research Article", "Clinical Study", "Review Article", "Letter to the Editor", "Case Report"]
  page.find("//td[contains(text(),'conflicts of interest')]/../following-sibling::tr[1]//input[@value='#{ans1}']").click if types.include?("#{@mstype}")
  page.find("//td[contains(text(),'data availability')]/../following-sibling::tr[1]//input[@value='#{ans2}']").click if types.first(2).include?("#{@mstype}")
  page.find("//td[contains(text(),'funding')]/../following-sibling::tr[1]//input[@value='#{ans3}']").click if types.first(2).include?("#{@mstype}")

  # puts 'no questions' if page.not_to have_selector("//td[contains(text(),'conflicts of interest')]/../following-sibling::tr[1]//input[@type='radio']")
  # puts 'no questions' if page.not_to have_selector("//td[contains(text(),'data availability')]/../following-sibling::tr[1]//input[@type='radio']")
  # puts 'no questions' if page.not_to have_selector("//td[contains(text(),'funding')]/../following-sibling::tr[1]//input[@type='radio']")

  sleep 3
  # find("//td[contains(text(),'data availability')]/../following-sibling::tr[1]//input[@value='#{ans2}']").click if types.first(2).include?("#{@mstype}")
  # find("//td[contains(text(),'funding')]/../following-sibling::tr[1]//input[@value='#{ans3}']").click if types.first(2).include?("#{@mstype}")
end

When("I click  on Update") do
  find("//*[@id='form0']/table/tbody/tr[31]/td[2]/input").click
end

Then /^Validation "(.*)" should be displayed$/ do |message|
  msg = find("//*[@id ='sp_Message']/b").text
  puts expect(message == msg).to be true
  sleep 3
end

Given ("Download additional file link should be displayed") do
  puts expect(page.has_selector?("//*[@id='form0']/table/tbody/tr[7]/td[2]/a[1]")).to be true
end



Given ("Delete link should be displayed beside additional file") do
  puts expect(page.has_selector?("//*[@id='form0']/table/tbody/tr[7]/td[2]/a[2]")).to be true
end


Given ("Delete link should be displayed beside supplementary materials") do
  puts expect(page.has_selector?("//*[@id='form0']/table/tbody/tr[8]/td[2]/a[2]")).to be true
  sleep 2
end


Given ("I Check new changes in MTs admin in MS details") do
  find("//*[@id='container']/div[9]/div[1]/a").click
  sleep 5

  supp = find("//span[@id='descr']").text
  puts (expect supp==@supplementary).to be true

  path = "#{ENV['DOWNLOAD_DIR']}/#{@ms_id}.v1.docx"

  File.exist?(path).should be_truthy
  # clear_downloads
end
>>>>>>> 07fc82f428a2d62c00cdcf3d805d6c3261cef9de
