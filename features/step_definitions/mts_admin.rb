#############################
########### Given ###########
#############################
Given /^open Admin MTS$/ do
  visit "http://beta.admin.mts.hindawi.com/"
end

Given /^enter valid email$/ do
  fill_in 'identifierId', :with => 'doaa.asl@hindawi.com'
end

Given /^enter valid password$/ do
  sleep 1
  fill_in 'password', :with => 'Doaa2020'
end
Given /^Open Search Manuscript page$/ do
  page.find(:xpath, '//a[text()="Search Manuscripts"]').click
  sleep 1
end

Given ("The user click on back to general activities") do
  step %Q{Open Search Manuscript page}
  find(:xpath, '//*[@id="form0"]/div[2]/a').click
end

Given /^the user enter valid Manuscript number "(.*)"$/ do |id|
  @new_id = id
  step %Q{Open Search Manuscript page}
  fill_in 'SearchFields_ManunscriptId', with: id
end

Given /^the user clear manuscript ID field and enter invalid data (.*)$/ do |invalid_id|
  step %Q{Open Search Manuscript page}
  find(:xpath, '//*[@id="SearchFields_ManunscriptId"]').send_keys invalid_id
  step %Q{Click Search button}
end

Given /^the user enter valid Manuscript title$/ do
  step %Q{Open Search Manuscript page}
  fill_in 'SearchFields_Title', with: "Transmitter"
  step %Q{Click Search button}
end

Given /^enter invalid Manuscript title$/ do |invalid_title|
  step %Q{Open Search Manuscript page}
  invalid_title.hashes.each do |row|
    errors = []
    find(:id, "SearchFields_Title").native.clear
    find(:id, "SearchFields_Title").send_keys row['invalid_title']
    step %Q{Click Search button}
    sleep 2
    begin
      result = find(:xpath, '//*[@id="form0"]/div[3]/b').text
      expect(result).to eq(row['error'])
    rescue
      errors << "I got the wrong error for value #{row['invalid_title']}"
    end
  end
end

Given /^enter invalid issue$/ do |invalid_issue|
  step %Q{Open Search Manuscript page}
  invalid_issue.hashes.each do |row|
    find(:id, "SearchFields_IssueId").native.clear
    find(:id, "SearchFields_IssueId").send_keys row['invalid_issue']
    step %Q{Click Search button}
    sleep 2
    begin
      result = find(:xpath, '//*[@id="form0"]/div[3]/b').text
      expect(result).to eq(row['error'])
    rescue
      errors << "I got the wrong error for value #{row['invalid_issue']}"
    end
  end
end

Given /^the user enter valid issue$/ do
  step %Q{Open Search Manuscript page}
  fill_in 'SearchFields_IssueId', with: "NPBCC"
  step %Q{Click Search button}
end

Given /^the user enter valid Manuscript Issue Name$/ do
  step %Q{Open Search Manuscript page}
  fill_in 'SearchFields_IssueDescr', with: "Advanced Optimization Techniques and Their Applications in Civil Engineering"
  step %Q{Click Search button}
end

Given /^the user enter valid Journal SubCode$/ do
  step %Q{Open Search Manuscript page}
  fill_in 'SearchFields_JournalSubCode', with: "JCSE"
  step %Q{Click Search button}
end

Given /^enter invalid subcode$/ do |table|
  step %Q{Open Search Manuscript page}
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

Given /^the user enter valid Manuscript Author$/ do
  step %Q{Open Search Manuscript page}
  fill_in 'SearchFields_AuthorsName', with: "Kangling Wang"
  step %Q{Click Search button}
end

Given /^the user enter valid Manuscript Authors$/ do
  step %Q{Open Search Manuscript page}
  fill_in 'SearchFields_AuthorsName', with: "MOHREM ABDELKRIM, CHETATE Boukhemis, GUIA Houssem Eddine"
  step %Q{Click Search button}
  sleep 5
end

Given /^the user clear the field and enter invalid data "(.*)"$/ do |invalid_data|
  step %Q{Open Search Manuscript page}
  find(:xpath, '//input[@id="SearchFields_Title"]').send_keys invalid_data
  find(:xpath, "//input[@id='SearchFields_IssueId']").send_keys invalid_data
  find(:xpath, '//input[@id="SearchFields_IssueDescr"]').send_keys invalid_data
  step %Q{Click Search button}
end

Given /^The user select one of the Editorial Recommendation$/ do
  step %Q{Open Search Manuscript page}
  find(:xpath, "//input[@value='EdMajor']").set(true)
  step %Q{Click Search button}
end

Given ("multi recommendations are selected Void and Reject") do
  step %Q{Open Search Manuscript page}
  find(:xpath, "//*[@id='form0']/div[3]/table/tbody/tr[2]/td/table/tbody/tr/td/div[4]/input").set(true)
  find(:xpath, "//*[@id='form0']/div[3]/table/tbody/tr[2]/td/table/tbody/tr/td/div[9]/input").set(true)
end

Given /^the user Choose "(.*)" from drop down list$/ do |version|
  step %Q{Open Search Manuscript page}
  select version, from: 'SearchFields_VersionNumber'
  find(:xpath, "//input[@value='EdMajor']").set(true)
  step %Q{Click Search button}
end

Given /^page selection is "(.*)"$/ do |default|
  step %Q{Open Search Manuscript page}
  result = find(:xpath, "//*[@id='SearchFields_ManuscriptPerPage']").text
  if result.include? "#{default}"
    puts "default is correct"
  else
    puts "default is not correct"
  end
end

Given /^user Choose "(.*)" from drop down list$/ do |pages|
  # step %Q{Open Search Manuscript page}
  step %Q{the user Choose The submission date from "04/01/2018"}
  step %Q{the user Choose The submission date To "04/30/2018"}
  select pages, from: "SearchFields_ManuscriptPerPage"
  step %Q{Click Search button}
  sleep 5
end

Given /^the user Choose The submission date from "(.*)"$/ do |from|
  @fromdate = from
  step %Q{Open Search Manuscript page}
  fill_in 'SubmissionFrom', with: @fromdate
end

Given /^the user Choose invalid submission date from and to then the system should validate$/ do |table|
  step %Q{Open Search Manuscript page}
  table.hashes.each do |row|

    fill_in 'SubmissionFrom', with: row['date_from']
    fill_in 'SubmissionTo', with: row['date_to']
    step %Q{Click Search button}

    errors = []
    begin
      result = find(:xpath, '//*[@id="form0"]/div[3]/b').text
      expect(result).to eq(row['validation_message'])
      !if result == row['validation_message']
         break if page.has_selector?("//b[contains(text(),'You are not authorized to view this page.')]")
         page.evaluate_script('window.history.back()')
       else
         puts "Right Validation Message"
       end
    rescue
      errors << "I got the error #{row['validation_message']} for value #{row['date_from']}"
    end
    expect(errors).to eq []
  end
end

Given /^the user Choose The decision date from "(.*)"$/ do |from|
  @fromdate = from
  step %Q{Open Search Manuscript page}
  fill_in "RecommendationDateFrom", with: @fromdate
end

Given /^check the manuscript status radio button$/ do
  step %Q{Open Search Manuscript page}
  @status = find(:xpath, '//input[3]')
end

Given /^user Choose The decision date To "(.*)"$/ do |to|
  step %Q{Open Search Manuscript page}
  @todate = to
  fill_in 'RecommendationDateTo', with: @todate
end

Given /^select archived manuscript in the dbs$/ do
  manuscript = select_from_dbs("select top 1 * from manuscripts where IsArchived = '1'")
  manuscript.each do |column|
    puts @x = column["ManuscriptId"]
  end
end
Given /^select current manuscript in the dbs$/ do
  manuscript = select_from_dbs("select top 1 * from manuscripts where IsArchived = '0'")
  manuscript.each do |column|
    puts @y = column["ManuscriptId"]
  end
end

Given /^check the counter of results$/ do
  step %Q{the user Choose The submission date from "01/04/2018"}
  step %Q{the user Choose The submission date To "02/04/2018"}
  step %Q{Click Search button}
  sleep 1
  puts @counter = find(:xpath, '//span[@class="results"]').text
  rows = all(:xpath, "//html//table[@id='MtsTable']//tr")
  records = rows.length
  @searchrecords = records - 1
  puts @searchrecords
end

Given /^the user select page number$/ do
  step %Q{the user Choose The submission date from "01/04/2018"}
  step %Q{the user Choose The submission date To "02/04/2018"}
  step %Q{Click Search button}
  sleep 1
  find(:xpath, "//input[@type='submit'][@value='3']").click
end

Given /^the user click on header title$/ do
  step %Q{the user Choose The submission date from "04/01/2018"}
  step %Q{the user Choose The submission date To "04/02/2018"}
  step %Q{Click Search button}
  sleep 1
  @befsort = []
  results = all(:xpath, "//table[@id='MtsTable']//tr//td[3]")
  results.each do |row|
    @befsort << row.text
  end
  @befsort = @befsort.sort
end

Given /^the user click on header titles and the system should sort the result$/ do |table|
  step %Q{the user Choose The submission date from "04/01/2018"}
  step %Q{the user Choose The submission date To "04/02/2018"}
  step %Q{Click Search button}
  sleep 1
  @befsort = []
  @aftersort = []
  errors = []
  table.hashes.each do |row|
    results = all(:xpath, "//th[contains(@class,'title_cells_')][contains(text(),'#{row['header']}')]/../../../tbody/tr/td[#{row['td']}]")
    results.each do |row|
      @befsort << row.text
    end
    @befsort = @befsort.sort
    find(:xpath, "//th[contains(@class,'title_cells_')][contains(text(),'#{row['header']}')]").click
    sleep 1
    sortedresults = all(:xpath, "//th[contains(@class,'title_cells_')][contains(text(),'#{row['header']}')]/../../../tbody/tr/td[#{row['td']}]")
    sortedresults.each do |element|
      @aftersort << element.text
    end
    begin
      expect(@aftersort).to eq(@befsort)
    rescue RSpec::Expectations::ExpectationNotMetError
      errors << "Sorting of the header #{row['header']} is not correct"
    end
  end
  expect(errors).to eq []
end

Given /^the user select random record and click on cover letter hyperlink$/ do
  step %Q{the user enter valid Manuscript number "3192074"}
  step %Q{Click Search button}
  sleep 2
  find(:xpath, "//*[@id='MtsTable']/tbody/tr/td[6]/a").click
end

Given /^the user search by not finalized recommendation$/ do
  step %Q{the user Choose The submission date from "04/01/2018"}
  step %Q{the user Choose The submission date To "04/02/2018"}
  select '1', from: 'SearchFields_VersionNumber'
  find(:xpath, "//input[@value='Not']").set(true)
  step %Q{Click Search button}
end

Given /^the user search by one recommendation$/ do
  step %Q{the user Choose The submission date from "03/01/2018"}
  step %Q{the user Choose The submission date To "04/02/2018"}
  find(:xpath, "//input[@id='SearchFields_ManunscriptId']").click
  select '1', from: 'SearchFields_VersionNumber'
  find(:xpath, "//input[@value='EiCPublish']").set(true)
  step %Q{Click Search button}
  step %Q{click on MS ID}
end

Given /^new manuscript is submitted$/ do
  step %Q{Navigate to "http://beta.mts.hindawi.com/remon.refaat@hindawi.com/123456"}
  step %Q{Click on "Submit a Manuscript"}
  step %Q{Select a random journal}
  step %Q{Add the data of all authors}, table(%q{
  | First Name | Last Name | Email Address            | Affiliation      | Country | Corresponding Author |
  | Remon      | Refaat    | remon.refaat@hindawi.com | Cairo University | Egypt   | No                   |
  | Mohamed    | Emad      | mohamed.emad@hindawi.com | Cairo University | USA     | No                   |
  | Mai        | Fathy     | mai.fathy@hindawi.com    | Cairo University | Algeria | Yes                  |})
  step %Q{Add title of the manuscript}
  step %Q{Select a random Article Type}
  step %Q{Choose a file "test1.docx" for "ManuscriptFile"}
  step %Q{Choose a file "test2.docx" for "CoverLetterReviewReport"}
  step %Q{Choose a file "test3.docx" for "SupplementaryMaterial"}
  step %Q{Select the answers of the questions "No", "Yes", and "Yes"}
  step %Q{Press on "Submit"}
  step %Q{"Thank You for Submitting Your Manuscript" will be displayed}
  puts @ms_id = find(:xpath, "//*[@id='container']/div[5]/div[2]/div/p[1]/a").text
end

############################
########### And ############
############################
And /^click next again$/ do
  find(:xpath, '//*[@id="passwordNext"]/content/span').click
  sleep 3
end

And /^click next$/ do
  page.find(:id, 'identifierNext').click
end

And /^Click Search button$/ do
  page.find(:xpath, '//button[@id="submit"]').click
end

And /^click on MS ID$/ do
  find(:xpath, "//*[@id='MtsTable']/tbody/tr[1]/td[3]/div/a").click
  sleep 10
end

And /^the user enter valid data in Manuscript Author "(.*)"$/ do |author|
  find(:xpath, "//*[@id='SearchFields_AuthorsName']").send_keys author
  @auth = author
end

And /^the user enter valid data Journal SubCode "(.*)"$/ do |jsubcode|
  find(:xpath, '//*[@id="SearchFields_JournalSubCode"]').send_keys jsubcode
  @subcode = jsubcode
  step %Q{Click Search button}
end

And /^Check select-clear all from editorial recommendation$/ do
  step %Q{Open Search Manuscript page}
  find(:xpath, "//input[@id='chkAll']").set(true)
end

And /^the user Choose The decision date To "(.*)"$/ do |to|
  @todate = to
  fill_in 'RecommendationDateTo', with: @todate
end

And /^search by selected manuscript id and archived status$/ do
  step %Q{the user enter valid Manuscript number "#{@x}"}
  find(:xpath, "//div[@class='search_status_radio']//input[2]").click
  step %Q{Click Search button}
end

And /^search by selected manuscript id and current status$/ do
  step %Q{the user enter valid Manuscript number "#{@y}"}
  find(:xpath, "//div[@class='search_status_radio']//input[1]").click
  step %Q{Click Search button}
end


And /^the user Choose The submission date To "(.*)"$/ do |to|
  @todate = to
  fill_in 'SubmissionTo', with: @todate
end

############################
########## When ############
############################

When /^user search by Manuscript ID$/ do
  step %Q{open Admin MTS}
  step %Q{the user enter valid Manuscript number "#{@ms_id}"}
  sleep 20
end

############################
########## Then ############
############################
Then /^check tha page address$/ do
  page_address = find(:xpath, '//h1[contains(text(),"Search Manuscripts")]').text
  if page_address == "Search Manuscripts"
    puts "Search Manuscripts page opened"
  else
    puts "Wrong Page address"
  end
end

Then ("The system redirect the user to Administrator Activities page") do
  page_address = find(:xpath, "//h1[contains(text(),'Administrator Activities')]").text
  if page_address == "Administrator Activities"
    puts "The system direct the user to Administrator Activities page"
  else
    puts "Wrong directing"
  end
end

Then /^a validation message should appear$/ do
  step %Q{Open Search Manuscript page}
  step %Q{Click Search button}
  validation = page.find(:xpath, '//*[@id="form0"]/div[3]/b').text
  if validation.include? "You must specify at least one field to search."
    puts validation
  end
end

Then /^the system will display the correct manuscript$/ do
  errors = []
  @result = all(:xpath, '//*[@id="MtsTable"]/tbody/tr/td[3]/div/a')
  @result.each do |msid|
    @result = msid.text
  end
  begin
    expect(@result.include? @new_id).to be_truthy
  rescue RSpec::Expectations::ExpectationNotMetError
    errors << "MS ID #{@result} is displayed wrongly"
  end
  expect(errors).to eq []
end

Then /^The system display (.*)$/ do |error|
  result = find(:xpath, '//*[@id="form0"]/div[3]/b').text
  expect(result).to eq(error)
end

Then /^the matched result is displayed$/ do
  errors = []
  @mstitle = all(:xpath, '//div[@class="paper_title"]/b')
  @mstitle.each do |element|
    @mstitle = element.text
  end
  begin
    expect(@mstitle.include? 'Transmitter').to be_truthy
  rescue RSpec::Expectations::ExpectationNotMetError
    errors << "MS title #{@mstitle} is displayed wrongly"
  end
  expect(errors).to eq []
end

Then /^the matched issue should be displayed$/ do
  errors = []
  @msissue = all(:xpath, "//html//table[@id='MtsTable']//td[2]")
  @msissue.each do |element|
    @msissue = element.text
  end
  begin
    expect(@msissue.include? 'NPBCC').to be_truthy
  rescue RSpec::Expectations::ExpectationNotMetError
    errors << "MS title #{@msissue} is displayed wrongly"
  end
  expect(errors).to eq []
end

Then /^system displays correct issue name$/ do
  error = []
  name = find(:xpath, "//td[contains(text(),'Issue')]//following-sibling::td").text
  begin
    expect(name.text.include? 'Advanced Optimization Techniques and Their Applications in Civil Engineering').to be_truthy
  rescue
    error << "wrong issue name"
  end
end

Then /^enter invalid issue name$/ do |table|
  step %Q{Open Search Manuscript page}
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

Then /^system will display Journal SubCode$/ do
  result = all(:xpath, '//*[@id="MtsTable"]/tbody/tr/td[1]')
  result.each do |element|
    expect(element.text.include? 'JCSE').to be_truthy
  end
end

Then /^system will display correct Manuscript Author$/ do
  result = all(:xpath, '//*[@id="MtsTable"]/tbody/tr/td[4]/div[2]')
  result.each do |element|
    expect(element.text.include? "Kangling Wang").to be_truthy
  end
end

Then /^system will display correct Manuscript Authors$/ do
  expect(page.has_selector?(:xpath, '//*[@id="MtsTable"]/tbody')).to be_truthy
  begin
    result = all(:xpath, "//*[@id='MtsTable']/tbody/tr/td[4]/div[2]/i")
    result.each do |element|
      expect(element.text.include? "MOHREM ABDELKRIM, CHETATE Boukhemis, GUIA Houssem Eddine").to be_truthy
      puts "True"
    rescue
      expect(page.has_selector?(:xpath, "//b[contains(text(),'Your search returned no results.')]")).to be_falsy
      puts "this message appears : Your search returned no results."
    end
  end
end

Then /^enter invalid authors$/ do |table|
  step %Q{Open Search Manuscript page}
  errors3 = []
  table.hashes.each do |row|
    find(:id, "SearchFields_JournalSubCode").native.clear
    find(:id, "SearchFields_AuthorsName").native.clear
    find(:id, "SearchFields_AuthorsName").send_keys row['authors']
    step %Q{Click Search button}
    error_message = find(:xpath, "//b").text
    begin
      expect(row['authorserror'] == error_message).to be_truthy
    rescue
      errors3 << "I was expecting #{row['authorserror']} for value #{row['authors']}"
    end
  end
  expect(errors3).to eq([])
end

Then /^the system will display the correct manuscript with valid combination$/ do
  errors = []
  @result = all(:xpath, '//*[@id="MtsTable"]/tbody/tr/td[3]/div/a')
  @result2 = all(:xpath, '//*[@id="MtsTable"]/tbody/tr/td[4]/div[2]/i')
  @result3 = all(:xpath, '//*[@id="MtsTable"]/tbody/tr/td[1]')
  @result.each do |msid|
    @result = msid.text
  end
  @result2.each do |author|
    @result2 = author.text
  end
  @result3.each do |jsubcode|
    @result3 = jsubcode.text
  end
  begin
    puts expect(@result.include? @new_id).to be_truthy
    puts expect(@result2.include? @auth).to be_truthy
    puts expect(@result3.include? @subcode).to be_truthy
  rescue RSpec::Expectations::ExpectationNotMetError
    errors << "MS ID #{@result} is displayed wrongly"
  end
  expect(errors).to eq []
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
  find(:xpath, "//input[@id='chkAll']").set(false)
  errors = []
  within(:xpath, "//table[@class='search_recom']") do
    recommendations = all(:xpath, '//input[@name="checklistRecommendation"]')
    recommendations.each do |element|
      begin
        expect(element.checked?).to be_falsy
        puts "Recommendation Unselected"
      rescue RSpec::Expectations::ExpectationNotMetError
        errors << "Errors #{element.text}"
      end
    end
  end
  puts errors
  expect(errors).to eq([])
end

Then /^the system will display the correct recommendation$/ do
  result = find(:xpath, '//html//tr[1]/td[8]').text
  expect(result).to eq("Consider after Major Changes")
end

Then /^the system will display correct recommendations "(.*)" and "(.*)"$/ do |recommendation1, recommendation2|
  recommendations = all(:xpath, '//*[@id="MtsTable"]/tbody/tr/td[8]')
  recommendations.sample.text
  if recommendations == recommendation1 || recommendation2
    puts "Recommendations exist"
  else
    puts "Recommendations does not exist"
  end
end

Then /^All manuscripts which have one version shall be displayed$/ do
  result = all(:xpath, '//a[@class="topopup"]')
  result.each do |element|
    expect(element.text.include? "v1").to be_truthy
  end
end

Then /^Results will be out of "(.*)"$/ do |pages|
  result = find(:xpath, "//*[@id='form0']/div[3]/div[3]/span[1]").text
  if result.include? "#{pages}"
    puts "pager works"
  else
    puts "pager does not work"
  end
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

Then /^System should display manuscripts submitted till To date$/ do
  find(:xpath, "//input[@value='EdReject']").set(true)
  step %Q{Click Search button}
  result = all(:xpath, '//a[@class="topopup"]')
  result.sample.click
  sleep 5
  submission_date = find(:xpath, "//td[contains(text(),'Submitted On')]//following-sibling::td").text
  puts submission_date
  date = Date.parse submission_date
  dateto = Date.parse @todate
  puts date.strftime("%Y-%m-%d")
  dateto.strftime("%Y-%m-%d")
  from = "01/01/1900"
  fromdate = Date.parse from
  sleep 6
  expect(date.between?(fromdate, dateto)).to be_truthy
end

Then /^System should display manuscripts decision from the date enetered till now$/ do
  step %Q{Click Search button}
  result = all(:xpath, '//a[@class="topopup"]')
  result.sample.click
  sleep 5
  decision_date = find(:xpath, "//td[contains(text(),'Recommendation')]//following-sibling::td").text
  puts decision_date
  date = Date.parse decision_date
  datefrom = Date.parse @fromdate
  puts date.strftime("%Y-%m-%d")
  datefrom.strftime("%Y-%m-%d")
  currentdate = Time.now.strftime("%Y-%m-%d")
  todaydate = Date.parse currentdate
  expect(date.between?(datefrom, todaydate)).to be_truthy
end

Then /^System should display manuscripts decision in that range$/ do
  step %Q{Click Search button}
  result = all(:xpath, '//a[@class="topopup"]')
  result.sample.click
  sleep 5
  decision_date = find(:xpath, "//td[contains(text(),'Recommendation')]//following-sibling::td").text
  date = Date.parse decision_date
  puts date
  datefrom = Date.strptime(@fromdate, "%m/%d/%Y")
  dateto = Date.strptime(@todate, "%m/%d/%Y")
  date.strftime("%Y-%m-%d")
  datefrom.strftime("%Y-%m-%d")
  dateto.strftime("%Y-%m-%d")
  puts "#{datefrom}, #{dateto}"
  expect(date.between?(datefrom, dateto)).to be_truthy
end

Then /^System should display manuscripts decision till To date$/ do
  step %Q{Click Search button}
  result = all(:xpath, '//a[@class="topopup"]')
  result.sample.click
  sleep 5
  decision_date = find(:xpath, "//td[contains(text(),'Recommendation')]//following-sibling::td").text
  puts decision_date
  date = Date.parse decision_date
  dateto = Date.parse @todate
  puts date.strftime("%Y-%m-%d")
  dateto.strftime("%Y-%m-%d")
  first = "1900-01-01"
  firstdate = Date.parse first
  sleep 6
  expect(date.between?(firstdate, dateto)).to be_truthy
end

Then /^the All Manuscripts should be selected by default$/ do
  if @status.checked?
    puts "All Manuscripts radio button is checked by default"
  end
end

Then /^the manuscript id should displayed in search result as archived$/ do
  msid = all(:xpath, "//tbody//td[3]//div[1]//a[1]")
  y = msid.sample
  id = y.text
  if id.include?(@x)
    puts "Manuscript is archived"
  end
end

Then /^the manuscript id should displayed in search result as current$/ do
  msid = all(:xpath, "//tbody//td[3]//div[1]//a[1]")
  y = msid.sample
  id = y.text
  if id.include?(@y)
    puts "Manuscript is Current"
  end
end

Then /^the counter should display the same number of rows$/ do
  if @counter.include?("#{@searchrecords}")
    puts "System display the correct counter"
  else
    puts "The system display the WRONG counter"
  end
end

Then /^the page number should be selected$/ do
  expect(page.has_selector?(:xpath, "//span[@class='active']/input[@value='3']")).to be_truthy
end

Then /^the system should sort the result$/ do

  find(:xpath, "//th[@class='title_cells_plus header'][contains(text(),'Manuscript No.')]").click
  sleep 1
  @aftersort = []
  sortedresults = all(:xpath, "//table[@id='MtsTable']//tr//td[3]")
  sortedresults.each do |element|
    @aftersort << element.text
  end
  expect(@aftersort).to eq(@befsort)
end

Then /^check if manuscript id is hyperlinked$/ do
  def have_link(locator = nil, options = {}, &optional_filter_block)
    locator, options = nil, locator if locator.is_a? Hash
    HaveSelector.new(:link, locator, options, &optional_filter_block)

    link = find(:xpath, "//*[@id='MtsTable']/tbody/tr/td[3]/div/a").have_link
    error = []
    begin
      expect(link.has_selector?(:xpath, "//*[@id='MtsTable']/tbody/tr/td[3]/div/a")).to be_truthy
    rescue
      error << "no hyperlink"
    end
  end
end

Then /^MS details page is opened with MS (.*) in title$/ do |vf|
  title = find(:xpath, "//*[@id='popup_content']/div/h1").text
  if title.include? vf
    puts "MS details opened"
  else
    puts "MS details not opened"
  end
end

Then /^the Cover Letter should be downloaded successfully "(.*?)"$/ do |coverletter|
  var = %x[ IF EXIST #{ENV['DOWNLOAD_DIR']}/"coverletter" ECHO "coverletter" exists ]
  puts var
  puts Dir["C:\Users\doaa.asl\Downloads#{coverletter}"].last
end

Then /^check submission date and calculate the elapsed time$/ do
  submission_date = find(:xpath, "//td[contains(text(),'Submitted On')]//following-sibling::td").text
  date = Date.parse submission_date
  puts date.strftime("%Y-%m-%d")
  currentdate = Time.now.strftime("%Y-%m-%d")
  todaydate = Date.parse currentdate
  elapsed_time = todaydate - date
  puts elapsed_time

  system_elapsed_time = find(:xpath, "//tr[1]//td[9]").text
  if elapsed_time.to_s.include? (system_elapsed_time.to_s)
    puts "System display correct elapsed time which equal #{system_elapsed_time}"
  else
    puts "System display wrong elapsed time"
  end
end

Then /^check submission and recommendation date then calculate the elapsed time$/ do
  submission_date = find(:xpath, "//td[contains(text(),'Submitted On')]//following-sibling::td").text
  date = Date.parse submission_date
  puts date.strftime("%Y-%m-%d")

  recommendation_date = find(:xpath, "//td[contains(text(),'Recommendation')]//following-sibling::td").text
  rec_date = Date.parse recommendation_date
  puts rec_date.strftime("%Y-%m-%d")

  elapsed_time = rec_date - date
  puts elapsed_time

  system_elapsed_time = find(:xpath, "//tr[1]//td[9]").text
  if elapsed_time.to_s.include? (system_elapsed_time.to_s)
    puts "System display correct elapsed time which equal #{system_elapsed_time}"
  else
    puts "System display wrong elapsed time"
  end
end

Then /^report column display correct numbers$/ do
  puts system_reports = find(:xpath, "//tr[1]//td[7]").text
  step %Q{click on MS ID}
  table_rows = all(:xpath, "//div[@id='toPopup']//table[@id='MtsTable']//tbody//td[2]")
  puts assigned_reviewers = table_rows.length #

  decline = all(:xpath, "//tbody//tr//td[4][contains(text(),'Declined')]")
  declined_reviewers = decline.length
  puts all_except_declined = assigned_reviewers - declined_reviewers #

  agree = all(:xpath, "//tbody//tr//td[4][contains(text(),'Agreed')]|//tbody//tr//td[4][contains(text(),'Submitted')]")
  puts agreed_reviewers = agree.length #

  submitted = all(:xpath, "//tbody//tr//td[4][contains(text(),'Submitted')]")
  puts submitted_reviewers = submitted.length #

  expected_result = ("#{submitted_reviewers}/#{agreed_reviewers}/#{all_except_declined}/#{assigned_reviewers}").to_s
  # expect(system_reports).to eq(expected_result).to be_truthy
  if system_reports == expected_result
    puts "System display right report #{system_reports}"
  else
    puts "System display wrong report #{system_reports}"
  end
end


