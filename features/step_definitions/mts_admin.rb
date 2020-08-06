def selectMS
  matrix = []
  loop do

    xx = page.all("//table[@id='MtsTable']/tbody/tr/td[3]/a")

    xx.each do |row|
      @MSidd = row
      matrix << @MSidd
      @MSidd = matrix.sample

      @IDDD = @MSidd.text
    end

    @MSidd.click


    sleep 1
    break if page.has_selector?("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]")
    page.evaluate_script('window.history.back()')
  end

end


def sleDb
  arr = []
  ms_id = select_from_dbs("mtsv2", "SELECT top 10 * FROM  dbo.Manuscripts WHERE [MsTypeId] ='2' AND CurrentRecommendationId = 'Not'")
  ms_id.each do |row|
    @ms_ids = row['ManuscriptId']
    arr << @ms_ids
    @ms_ids = arr.sample
  end
  puts @ms_ids


  user_id = select_from_dbs("mtsv2", "SELECT UserId FROM dbo.staffmanuscripts WHERE [ManuscriptId] = '#{@ms_ids}'")

  user_id.each do |row|
    @UserId = row['UserId']
  end

  puts @UserId


  eA_mail = select_from_dbs("mtsv2", "SELECT Email FROM dbo.Users WHERE UserId = '#{@UserId}'")

  eA_mail.each do |row|
    @EAMail = row['Email']
  end
  puts @EAMail
end


def geturl

  visit 'http://beta.admin.mts.hindawi.com/auth/' + @EAMail

  # path = page.current_path
  #
  puts url = URI.parse(current_url)

  visit url + @ms_ids
end


def looop1
  loop do
    sleDb
    geturl
    break if page.has_selector?("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]")

  end
end


def looop2
  loop do
    looop1
    page.find("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]/a").click
    break if page.has_no_selector?("//b[text()='You are not authorized to view this page.']")
  end

end


def chekdown
  @no = @zz.split('/')
  if @no[1].include?("v1")
    File.open("#{ENV['Download_Dir']}/#{@no[1]}.pdf", 'rb') do |io|
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
        # page.text
        puts expect(page.should have_content('Author 3')).to be true
      end
    end
  elsif @no[1].include?("v2")

    File.open("#{ENV['Download_Dir']}/#{@no[1]}.pdf", 'rb') do |io|
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
        page.text
        puts expect(page.should have_content('Author 3')).to be true
      end

      # @session.driver.browser.action.context_click(self.native).perform

    end


  end

end


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
    sleep 1
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
    sleep 1
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
  sleep 1
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
  sleep 1
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
  sleep 1
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


Given /^I open (.*)$/ do |url|
  visit url
end

Given /^I enter username (.*)$/ do |username|
  email = page.first("//div//input[@type='email']")
  email.send_keys username

end

Given /^I click on Next button "(.*)"$/ do |btn|
  page.find("//*[@id='#{btn}']/content/span").click
  sleep 1
end

Given /^I enter password (.*)$/ do |pass|
  passw = page.first("//input[@type='password']")
  passw.send_keys pass
end

Given /^I navigate to EA account (.*)$/ do |url|
  visit url
  sleep 1
end

Given("Staff Manuscripts is opened") do
  # page.driver.browser.action.move_to(page.find("//a[@href='/editorial.staff/']").native).perform
  find(:xpath, "//div[@class='treemenu']").hover
  find("//*[@id='ctl00_NavigationBar1_LeftNavBar']/div/ul/li/ul/li[5]/a").click

end

# Given ("I log out") do
# page.find("//*[@id='hindawi_links']/ul/li[2]/a").click
# end


Given /^I fill the field Manuscript Title with (.*)$/ do |value|
  # fill_in "//div[contains(text(),'#{label}:')]/../following-sibling::td", :with => value
  #  fill_in label.gsub(' ', '_'), :with => value
  fill_in 'MsTitle', with: value

  sleep 1
end

Given("I select issue, Manuscript type, and recommendation from dropdown lists") do


  isuue = page.all("//select[@id='SelectedIssueId']/option")
  is=[]
  isuue.each do |row|
    @issu_d = row
    is<<@issu_d
  end
  @re = is.sample
  @RBE =@re.text

  @re.click


  m_ty =page.all("//select[@id='SelectedMsTypeId']/option")
  tyeds=[]
  m_ty.each do |row|
    @m_typee=row
    tyeds<<@m_typee
  end
  @sample = tyeds.sample
  @mtype=@sample.text
  @sample.click

  recos= page.all("//select[@id='SelectedRecommendationId']/option")
  rere=[]
  recos.each do |row|
    @reci=row
    rere<<@reci
  end
  @R = rere.sample
  @R.click
  @RRBE= @R.text
puts @RRBE
  if @RRBE == "Reject By Editorial Staff"

    page.find("//*[@id='form0']/table/tbody/tr[5]/td[2]/input[2]").click

  end

end


Given ("I upload Manuscript PDF File, Additional File, Supplementary Materials") do
  page.find("//*[@id='form0']/table/tbody/tr[6]/td[2]/input[@type = 'file']").send_keys "#{ENV['DATAPATH']}6837404.pdf"
  sleep 1

  page.find("//*[@id='form0']/table/tbody/tr[7]/td[2]/input[@type = 'file']").send_keys "#{ENV['DATAPATH']}6837404.pdf"

  sleep 1
  page.find("//*[@id='form0']/table/tbody/tr[8]/td[2]/input[@type = 'file']").send_keys "#{ENV['DATAPATH']}6837404.pdf"

  find("//*[@id='SupplementaryDescr']").native.clear
  @supplementary = 'ssssssssssssssssssssssssssss'
  find("//*[@id='SupplementaryDescr']").send_keys(@supplementary)
  sleep 1

end

Given /^I check on the radio buttons of conflicts of interest, data availability statement, funding statement, and Select the answers of the questions "(.*)", "(.*)", and "(.*)"$/ do |ans1, ans2, ans3|
  types = ["Research Article", "Clinical Study", "Review Article", "Letter to the Editor", "Case Report"]
  page.find("//td[contains(text(),'conflicts of interest')]/../following-sibling::tr[1]//input[@value='#{ans1}']").click if types.include?("#{@mtype}")
  page.find("//td[contains(text(),'data availability')]/../following-sibling::tr[1]//input[@value='#{ans2}']").click if types.first(2).include?("#{@mtype}")
  page.find("//td[contains(text(),'funding')]/../following-sibling::tr[1]//input[@value='#{ans3}']").click if types.first(2).include?("#{@mtype}")
  sleep 1
end

Given ("Download additional file link should be displayed") do
  puts expect(page.has_selector?("//*[@id='form0']/table/tbody/tr[7]/td[2]/a[1]")).to be true
end


Given ("Delete link should be displayed beside additional file") do
  puts expect(page.has_selector?("//*[@id='form0']/table/tbody/tr[7]/td[2]/a[2]")).to be true
end


Given ("Delete link should be displayed beside supplementary materials") do
  puts expect(page.has_selector?("//*[@id='form0']/table/tbody/tr[8]/td[2]/a[2]")).to be true
  sleep 1
end

Given ("I download MS PDF") do

  find("//*[@id='form0']/table/tbody/tr[6]/td[2]/a").click
end

Given("I Check new changes in MTs admin in MS details") do

  find("//*[@id='container']/div[9]/div[1]/a").click
  sleep 1
  supp = find("//span[@id='descr']").text

  puts (expect supp == @supplementary).to be true

  @zz = page.find("//*[@id='container']/div[9]/h1").text

  if @zz.include?("v1")
    File.open("#{ENV['Download_Dir']}/#{@msddz}.v1.pdf", 'rb') do |io|
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
        # page.text
        puts expect(page.should have_content('Author 3')).to be true
      end
    end
  elsif @zz.include?("v2")

    File.open("#{ENV['Download_Dir']}/#{@msddz}.v2.pdf", 'rb') do |io|
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
        page.text
        puts expect(page.should have_content('Author 3')).to be true
      end

      # @session.driver.browser.action.context_click(self.native).perform

    end


  end

  clear_downloads


end


Given "select MS that takes flag of is published and get the email address that handle the paper from DB" do

  g = []
  ms_id = select_from_dbs("mtsv2", "SELECT  ManuscriptId  FROM dbo.Manuscripts WHERE Ispublished = '1' AND MSSubmitDate BETWEEN '2018-01-01' AND '2018-12-31'")

  ms_id.each do |row|
    @MS_id = row['ManuscriptId']
    g << @MS_id
    @MS_id = g.sample
  end
  puts @MS_id


  user_id = select_from_dbs("mtsv2","SELECT UserId FROM dbo.StaffManuscripts WHERE ManuscriptId = '#{@MS_id}'")

  user_id.each do |row|
    @UserId = row['UserId']
  end

  puts @UserId

  eA_mail = select_from_dbs("mtsv2","select Email from dbo.Users where UserId = '#{@UserId}'")

  eA_mail.each do |row|
    @EAMail = row['Email']
  end
  puts @EAMail

end

Given ("I navigate to EA account") do

  visit 'http://beta.admin.mts.hindawi.com/auth/' + @EAMail

  # path = page.current_path
  #
  puts url = URI.parse(current_url)

  visit url + @MS_id

end

Given ("Edit link should not be appeared") do
  puts expect(page.has_xpath?('//*[@id="container"]/div[9]/ul/li[contains(.,"Edit Manuscript Details")]')).to be false

  sleep 1
end


Given ("i check redio button of conflict of interest") do

  sleep 1
  page.first(:xpath, "//input[@type='radio'][@name='SubmissionQuestionsAnswersList[0].EditorialAnswer_YES']").click
  step %Q{I click  on Update}
  sleep 1
  box = page.find(:xpath, "//*[@id='div_MsTypeSubmissionQuestion_Comment_1']")
  expect(box) == page.find(:xpath, "//*[@id='div_MsTypeSubmissionQuestion_Comment_1']").visible?
  message = page.find(:xpath, "//*[@id='validationSummary']/ul/li")
  expect(message) == "Please complete the submission questions answers."

end


Given /^I Uplaod invalid files in this fileds Manuscript PDF File and Additional File$/ do
  page.find(:xpath, "//input[@name='PdfFile']").send_keys "#{ENV['DATAPATH']}testi.mp3"
  page.find(:xpath, "//input[@name='AdditionalFile']").send_keys "#{ENV['DATAPATH']}testi.mp3"
  step %Q{I click  on Update}

  # message2 = page.find(:xpath, "//*[@id='validationSummary']/ul/li[1]")
  expect(page.has_selector?("//*[@id='validationSummary']/ul/li[1]")).to be_truthy
  expect(page.has_selector?("//*[@id='validationSummary']/ul/li[2]")).to be_truthy
end

Given /^i delete ms title$/ do
  page.find(:xpath, "//*[@id='MsTitle']").native.clear
  step %Q{I click  on Update}
sleep 5
  puts expect(page.has_selector?("//li[contains(text(),'Please enter the manuscript title.')]")).to be_truthy
end

Given /^I can upload and dowenload the Additional$/ do
  page.find(:xpath, "//input[@name='AdditionalFile']").send_keys "#{ENV['DATAPATH']}test1.pdf"
  page.find(:xpath, "//input[@name='SupplementaryMaterials']").send_keys "#{ENV['DATAPATH']}test2.pdf"
  page.first(:xpath, "//*[@id='SupplementaryDescr']").send_keys("test")
  step %Q{I click  on Update}
  page.first(:xpath, "//a[text()[contains(.,'Additional File')]]").click
  sleep 1
  # # step %Q{I pause}
  page.find(:xpath, "//*[@id='form0']/table/tbody/tr[8]/td[2]/a[2]").click
  page.driver.browser.switch_to.alert.accept

  clear_downloads
end

Given /^i can delete file$/ do
  page.find(:xpath, "//input[@name='AdditionalFile']").send_keys "#{ENV['DATAPATH']}test1.pdf"
  step %Q{I click  on Update}

  page.find(:xpath, "//*[@id='form0']/table/tbody/tr[7]/td[2]/a[2]").click

  puts page.driver.browser.switch_to.alert.text
  a = page.driver.browser.switch_to.alert
  if a.text == 'something'
    a.dismiss
  else
    a.accept
  end
  puts expect(page.has_no_xpath?("//a[text()[contains(.,'Additional File')]]")).to be_truthy

end
Given /^click on "(.*)" to Ms details$/ do |back|
  click_link back

  puts expect(page.has_link?('Edit Manuscript Details')).to be_truthy

end

Given /^admin can edit the selection from Yes to No and vice versa$/ do
  sleep 2
  page.find("//*[@id='form0']/table/tbody/tr[8]/td[2]/input[@type = 'file']").send_keys "#{ENV['DATAPATH']}6837404.pdf"

  find("//*[@id='SupplementaryDescr']").native.clear
  @supplementary = 'ssssssssssssssssssssssssssss'
  find("//*[@id='SupplementaryDescr']").send_keys(@supplementary)
  @tyie = page.find("//*[@id='SelectedMsTypeId']/option[@selected]").text
  puts @tyie
  types = ["Research Article", "Clinical Study", "Review Article", "Letter to the Editor", "Case Report"]
  page.find("//td[contains(text(),'conflicts of interest')]/../following-sibling::tr[1]//input[@value='No']").click if types.include?("#{@tyie}")
  page.find("//td[contains(text(),'data availability')]/../following-sibling::tr[1]//input[@value='Yes']").click if types.first(2).include?("#{@tyie}")
  page.find("//td[contains(text(),'funding')]/../following-sibling::tr[1]//input[@value='Yes']").click if types.first(2).include?("#{@tyie}")
  sleep 2
  step %Q{I click  on Update}
  msgConfrim = page.find("//*[@id='sp_Message']/b").text

  expect(msgConfrim == 'Operation Completed Successfully.').to be true
  sleep 1
end

Given ("Choose ms which is flagged as re-review") do

  ms_review_id = select_from_dbs("mtsv2", "select * from [dbo].[ManuscriptsRereview] Where ConfirmedRereviewDate IS NULL AND RereviewDate >= '2018-01-01 00:00:00'")

  ids = []
  ms_review_id.each do |row|
    @R_id = row['ManuscriptId']
    ids << @R_id
    @R_id = ids.sample
  end
  puts @R_id


  use_id = select_from_dbs("mtsv2", "SELECT UserId FROM dbo.staffmanuscripts WHERE ManuscriptId = '#{@R_id}'")

  ud = []
  use_id.each do |row|
    @usee_id = row['UserId']
    ud << @usee_id
  end

  puts @usee_id


  use_email = select_from_dbs("mtsv2", "SELECT Email FROM dbo.Users WHERE userId = '#{@usee_id}'")

  uE = []
  use_email.each do |row|
    @ma = row['Email']
    ud << @ma
  end

  puts @ma

end


Given ("login as EA who handle this ms") do

  visit 'http://beta.admin.mts.hindawi.com/auth/' + @ma
# step %Q{I pause}
  puts url = URI.parse(current_url)

  visit url + @R_id

end

Given("assert that Not Finalized is allowed in Recommendation dropdown list") do


  puts expect(page.has_selector?("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]")).to be true

  # step %Q{I pause}

  page.find("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]/a").click


  options = page.all("//*[@id='SelectedRecommendationId']//option")
  reco_options = []
  options.each do |opt|
    puts opt.text
    reco_options << opt.text
  end
  puts expect(reco_options.include? 'Not Finalized').to be true
end


Given("I logged as EQA") do
  visit "http://beta.admin.mts.hindawi.com/auth/amr.abdulkarim@hindawi.com"

  find(:xpath, "//*[@id='ctl00_NavigationBar1_LeftNavBar']").hover
  sleep 1

  find("//*[@id='ctl00_NavigationBar1_LeftNavBar']/div//ul[@class='cssMenu']//ul//li[contains(., 'Staff Manuscripts')]").click
  sleep 1

  find("//*[@id='container']/div[9]/ul/li[1]/a").click
  sleep 1


  loop do
    rows = page.all("//*[@id='MtsTable']/tbody/tr/td[2]/div/a")
    matrixx = []
    rows.each do |row|
      @MSiddd = row
      matrixx << @MSiddd
      @MSiddd = matrixx.sample

      @IDDD = @MSiddd.text
    end
    puts @IDDD

    @MSiddd.click



    page.find("//*[@id='container']/div[9]/ul[1]/li[contains(., 'Re-Review Manuscript')]/a").click

    @review = page.find("//input[@type='checkbox'][@name='IsRereviewManuscript']")
    break if @review.checked? == false
    page.evaluate_script('window.history.back()')
    page.evaluate_script('window.history.back()')

  end
  check("IsRereviewManuscript")
  sleep 1
  click_button "Save"
  sleep 1

  a = page.driver.browser.switch_to.alert
  if a.text == 'something'
    a.dismiss
  else
    a.accept
  end


  yyy = @IDDD.split(/\.|\(|\)/)
  puts yyy
  @idx = yyy[0]

  puts @idx
end


Given ("I check that MS Re-review date is the same date of checking the re-review link") do
sleep 3
  re_review_date = select_from_dbs("mtsv2", "select RereviewDate, ConfirmedRereviewDate from [dbo].[ManuscriptsRereview] Where ManuscriptId='#{@idx}'")

  re_review_date.each do |row|
    @D_R = row['RereviewDate']
    @con_d = row['ConfirmedRereviewDate']
  end


  puts @D_R

  @ok = @D_R.to_s

  sss = @ok.split(/\s/)

  puts @date = sss[0]


  @time = Time.now

  @Cdate = @time.to_s
  fff = @Cdate.split(/\s/)

  puts @currentTime = fff[0]


  puts expect(@date == @currentTime).to be true
  puts expect(@con_d.nil?).to be true


end

Given ("I logged as EA who handles the ms and changed the recommendation to Not Finalized") do
sleep 1
  us_id = select_from_dbs("mtsv2", "SELECT UserId FROM dbo.staffmanuscripts WHERE ManuscriptId = '#{@idx}'")

  us_id.each do |row|
    @U_d = row['UserId']
  end

sleep 1
emilos = select_from_dbs("mtsv2", "SELECT Email FROM dbo.Users WHERE userId = '#{@U_d}'")

  emilos.each do |row|
    @emaily_d = row['Email']
  end

sleep 1
visit 'http://beta.admin.mts.hindawi.com/auth/' + @emaily_d
  sleep 1
  puts url = URI.parse(current_url)
  sleep 1
  visit url + @idx
  sleep 1
  page.find("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]/a").click

  sleep 2
  page.find("//option[@value='Not']").click
  sleep 2
page.find("//*[@id='form0']/table/tbody/tr[8]/td[2]/input[@type = 'file']").send_keys "#{ENV['DATAPATH']}6837404.pdf"

find("//*[@id='SupplementaryDescr']").native.clear
@supplementary = 'ssssssssssssssssssssssssssss'
find("//*[@id='SupplementaryDescr']").send_keys(@supplementary)

sleep 2
@tyie = page.find("//*[@id='SelectedMsTypeId']/option[@selected]").text
puts @tyie
types = ["Research Article", "Clinical Study", "Review Article", "Letter to the Editor", "Case Report"]
page.find("//td[contains(text(),'conflicts of interest')]/../following-sibling::tr[1]//input[@value='No']").click if types.include?("#{@tyie}")
page.find("//td[contains(text(),'data availability')]/../following-sibling::tr[1]//input[@value='Yes']").click if types.first(2).include?("#{@tyie}")
page.find("//td[contains(text(),'funding')]/../following-sibling::tr[1]//input[@value='Yes']").click if types.first(2).include?("#{@tyie}")
sleep 1

sleep 2
  page.find("//*[@id='form0']/table/tbody/tr[31]/td[2]/input").click
  sleep 1
  welcome = select_from_dbs("mtsv2", "select  ConfirmedRereviewDate from [dbo].[ManuscriptsRereview] Where ManuscriptId='#{@idx}'")

  welcome.each do |row|
    @con_x = row['ConfirmedRereviewDate']
  end
  puts @con_x

  @okk = @con_x.to_s

  cony = @okk.split(/\s/)

  puts @dat = cony[0]

  @time = Time.now

  @c_date = @time.to_s
  fff = @c_date.split(/\s/)

  puts @currentTime = fff[0]

  puts expect(@dat == @currentTime).to be true

  revo_id = select_from_dbs("mtsv2", "select  RereviewId from [dbo].[ManuscriptsRereview] Where ManuscriptId='#{@idx}'")

  revo_id.each do |row|
    @revy_dd = row['RereviewId']
  end

sleep 1
  conny_id = select_from_dbs("mtsv2", "select  ConfirmedRereviewDate from [dbo].[ManuscriptsRereviewDates] Where RereviewId='#{@revy_dd}'")

  conny_id.each do |row|
    @conny_dd = row['ConfirmedRereviewDate']
  end
  @sury = @conny_dd.to_s

  cony2 = @sury.split(/\s/)

  puts @sury_datee = cony2[0]

  puts expect(@sury_datee == @dat).to be true
end

Given ("For a re-review MS, EA change the recommendation to Not finalized") do
  aerr = []
  re_rev_pap = select_from_dbs("mtsv2", "select * from [dbo].[ManuscriptsRereview] where confirmedRereviewDate IS NUll")
  re_rev_pap.each do |row|
    @re_rev_ids = row['ManuscriptId']
    aerr << @re_rev_ids
  end
  @re_rev_samp = aerr.sample

  puts @re_rev_samp


  not_finlized = execute_dbs_query("mtsv2",  "UPDATE Manuscripts SET CurrentRecommendationId = 'Not' where ManuscriptId ='#{@re_rev_samp}'")

  t_ime = Time.now
  @tt_ime = t_ime.strftime('%Y-%m-%d %T.%L')

  puts @tt_ime
  noot_finlized = execute_dbs_query("mtsv2", "UPDATE ManuscriptsRereview SET ConfirmedRereviewDate = '#{@tt_ime}' where ManuscriptId ='#{@re_rev_samp}'")
  sleep 1
  reminders = select_from_dbs("mtsv2", "SELECT DISTINCT SendDate,Type, ManuscriptId FROM Reminders WHERE ManuscriptId = '#{@re_rev_samp}' ORDER BY SendDate  DESC ")

  types = []
  datess = []
  reminders.each do |row|
    @nos = row['Type']
    types << @nos
    @dates = row['SendDate']
    datess << @dates
  end
  re_date = []
  puts @date = datess[0]
  @date1 = @date.to_s
  re_date = @date1.split(/\s/)
sleep 1
  @reminder_date = re_date[0]
  puts @type = types[0]


end
Given /^I choose approved ms$/ do
  # visit "http://beta.admin.mts.hindawi.com/auth/Sara.Zakareya@hindawi.com"
  # def open_ms
  r = []
  msanu_id = select_from_dbs("mtsv2", "SELECT * FROM dbo.MaterialCheckerManuscripts WHERE ActualAssignDate between '2018-01-01' and '2018-12-30'  AND Status='notyet'")
  msanu_id.each do |row|
    @msanu_id = row['ManuscriptId']
    r << @msanu_id
    @msanu_id =r.sample
  end
  puts @msanu_id
  user_id = select_from_dbs("mtsv2", "SELECT UserId FROM dbo.StaffManuscripts WHERE ManuscriptId = '#{@msanu_id}'")
  user_id.each do |row|
    @UserId = row['UserId']
  end
  puts @UserId
  eA_mail = select_from_dbs("mtsv2", "select Email from dbo.Users where UserId = '#{@UserId}'")

  eA_mail.each do |row|
    @EAMail = row['Email']
  end
  puts @EAMail
  visit 'http://beta.admin.mts.hindawi.com/auth/'+ @EAMail
  sleep 1
  url = URI.parse(current_url)
  visit url + @msanu_id
  sleep 1

  page.find("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]/a").click

  # puts  page.has_xpath?("//input[@type='file'][@name='SupplementaryMaterials'][disabled='disabled']")
  sleep 1
  puts find(:xpath,"//*[@id='form0']/table/tbody/tr[8]/td[2]/input").disabled?
end


############################
########### And ############
############################
And /^click next again$/ do
  find(:xpath, '//*[@id="passwordNext"]/content/span').click
  sleep 1
end

And /^click next$/ do
  page.find(:id, 'identifierNext').click
end

And /^Click Search button$/ do
  page.find(:xpath, '//button[@id="submit"]').click
end

And /^click on MS ID$/ do
  find(:xpath, "//*[@id='MtsTable']/tbody/tr[1]/td[3]/div/a").click
  sleep 1
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


And /^Assert that DB save the new answers as well as the old ones$/ do

  puts @IDDD
sleep 5
  qstAns = select_from_dbs("mtsv2", "select * from [dbo].[SubmissionQuestionAnswer] Where ManuscriptId = '#{@IDDD}'")
  auth_answers = []
  editorialAnswers = []
  questions = []
  qstAns.each do |row|
    @sub_ans = row['Answer']
    @ED_ans = row['EditorialAnswer']
    @qsts = row['MsTypeSubmissionQuestionId']
    auth_answers << @sub_ans
    editorialAnswers << @ED_ans
    questions << @qsts

  end

  puts auth_answers

  puts editorialAnswers

  puts questions

  puts @tyie
  chg_ED_answers = ["No", "Yes", "Yes"]
  other_Ed_answers =["No"]
  if @tyie=="Research Article" || @tyie=="Clinical Study"



  puts expect(chg_ED_answers == editorialAnswers).to be true

  else
    puts expect(other_Ed_answers == editorialAnswers).to be true
end

end
And /^Select research article ms and navigate to EA account and validate completion of answers of Questions$/ do

  looop2
  page.first(:xpath, "//*[@id='SubmissionQuestionsAnswersList[0].EditorialAnswer_Yes']").click
  step %Q{I click  on Update}
  puts expect(page.has_xpath?("//*[@id='validationSummary']/ul/li[contains(text(),'Please complete the submission questions answers.')]")).to be true
end


And(/^I login to Admin MTS$/) do
  if page.has_selector?(:id, "identifierId")
    step %Q{I enter username mts.hindawi@gmail.com}
    step %Q{I click on Next button "identifierNext"}
    step %Q{I enter password Mts123456}
    step %Q{I click on Next button "passwordNext"}
  end
end



############################
########## When ############
############################

When /^user search by Manuscript ID$/ do
  step %Q{open Admin MTS}
  step %Q{the user enter valid Manuscript number "#{@ms_id}"}
  sleep 1
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
  sleep 1
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
  sleep 1
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
  sleep 1
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
  sleep 1
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
  sleep 1
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
  sleep 1
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


Then /^Validation "(.*)" should be displayed$/ do |message|
  msg = find("//*[@id ='sp_Message']/b").text
  puts expect(message == msg).to be true
  sleep 1
end

Then("Reminders “Editor Not Decision After Completed Reviews​ and Editor Not Decision After Minor Rev”​ shall be on hold") do


  sleep 1
  @time = Time.now

  @c_date = @time.to_s
  fff = @c_date.split(/\s/)

  @currentTime = fff[0]


  puts expect(@reminder_date == @currentTime && @type == '3' && @type == '7').to be false

end


Then("I choose a  specific journal and I check if the dropdown lists of Issues and MS types are following this journal") do

  step %Q{Staff Manuscripts is opened}
  loop do
    xx = page.all("//table[@id='MtsTable']/tbody/tr/td[3]/a")
    matrix = []
    xx.each do |row|
      @MSidd = row
      matrix << @MSidd
      @MSidd = matrix.sample

      @IDDD = @MSidd.text
    end
    puts @IDDD
    @MSidd.click

    sleep 1
    @journal_id = page.find("//*[@id='msDetailes']//td[contains(text(),'Journal')]//..//following-sibling::td[2]").text
    puts @journal_id

    break if page.has_selector?("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]")
    page.evaluate_script('window.history.back()')
  end

  journal_ids = select_from_dbs("mtsv2", "select JournalId from [dbo].[Journals] where FullName='#{@journal_id}'")
  journal_ids.each do |row|
    @j_id = row['JournalId']
  end

  puts @j_id
  issue_ids = select_from_dbs("mtsv2", "select IssueId from Issues where JournalId='#{@j_id}' AND IsArchived='0' AND IsCanceled='0' ORDER BY IssueId ASC")
  issues_names = []
  issue_ids.each do |row|
    @issue = row['IssueId']
    issues_names << @issue
  end
  puts @db_length = issues_names.length
  puts issues_names

  page.find("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]/a").click
  sp_names = []
  sp = page.all("//select[@name='SelectedIssueId']/option")
  sp.each do |row|
    @sp_n = row.text
    sp_names << @sp_n

  end

  list_types = page.all("//select[@id='SelectedMsTypeId']/option")
  list_ttypes = []
  list_types.each do |row|
    @ty = row.text
    list_ttypes << @ty
  end
  typos = []
  typos = list_ttypes.sort do |a, b|
    a.upcase <=> b.upcase
  end
  puts typos
  puts @list_length = sp_names.length
  xxx = []
  xxx = sp_names.sort do |a, b|
    a.upcase <=> b.upcase
  end
  puts xxx

  expect(@db_length == @list_length).to be true
  expect(xxx == issues_names).to be true


  ms_types = select_from_dbs("mtsv2","select MsTypeId from [dbo].[JournalsMsTypes] where JournalId ='#{@j_id}'")
  ms_ttypes = []
  ms_types.each do |row|
    @type = row['MsTypeId']

    names = select_from_dbs("mtsv2", "select MsTypeName from [dbo].[MsTypes] where MsTypeId='#{@type}'")
    names.each do |row|
      @name = row['MsTypeName']
      ms_ttypes << @name
    end

  end

  teto = []
  teto = ms_ttypes.sort do |a, b|
    a.upcase <=> b.upcase
  end
  puts teto

  expect(teto == typos).to be true
  expect(teto.length == typos.length).to be true
end

Then("Check new changes in MTs website at editor-author-reviewer of this MS") do

  ed_auth_ids = select_from_dbs(  "mtsv2", "select CurrentEditorId, AuthorId from manuscripts where manuscriptid='#{@msddz}'")
  ed_auth_ids.each do |row|
    @co_author = row['AuthorId']
    @editor = row['CurrentEditorId']
  end

  puts @co_author
  puts @editor

  emails = select_from_dbs( "mtsv2", "select Email from users where userid = '#{@co_author}'")
  emails.each do |row|
    @author_email = row['Email']
  end

  emails_s = select_from_dbs( "mtsv2", "select Email from users where userid = '#{@editor}'")

  emails_s.each do |row|
    @editor_email = row['Email']
  end

  puts @author_email
  puts @editor_email

  reviewer_user_id = select_from_dbs("mtsv2", "select UserId from [dbo].[ReviewersAnswers] where ManuscriptId ='#{@msddz}'")
  reviwers_ids = []
  reviewer_user_id.each do |row|
    @reviewer_id = row['UserId']
    reviwers_ids << @reviewer_id
  end
  @revwyer_id = reviwers_ids.sample

  puts @revwyer_id


  r_email = select_from_dbs("mtsv2", "select Email from Users where UserId='#{@revwyer_id}'")
  r_email.each do |row|
    @mailo = row['Email']
  end
  puts @mailo
  sleep 1


  visit 'http://beta.mts.hindawi.com/sally.safwat@hindawi.com/sa123456/' + @mailo

  page.find("//*[@id='container']/div[5]/div/ul/li[contains(.,'Reviewer Activities')]/a").click

  @no = @zz.split('/')
  puts @no[1]
  sleep 1
  page.find("//*[@id ='container']/div[5]/div/table/tbody/tr/td[contains(., '#{@no[1]}')]/a").click

  page.find("//*[@id='content']/div/table/tbody/tr[1]/td[2]/div[1]/a").click
  sleep 1

  if @no[1].include?("v1")
    File.open("#{ENV['Download_Dir']}/#{@no[1]}.pdf", 'rb') do |io|
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
        # page.text
        puts expect(page.should have_content('Author 3')).to be true
      end
    end
  elsif @no[1].include?("v2")

    File.open("#{ENV['Download_Dir']}/#{@no[1]}.pdf", 'rb') do |io|
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
        page.text
        puts expect(page.should have_content('Author 3')).to be true
      end
      sleep 2
      # @session.driver.browser.action.context_click(self.native).perform

    end


  end

  clear_downloads
  sleep 1


  visit 'http://beta.mts.hindawi.com/sally.safwat@hindawi.com/sa123456/' + @author_email

  page.find("//*[@id ='container']/div[5]/div/ul/li[contains(.,'Author Activities')]/a").click

  page.find("//*[@id ='container']/div[5]/div/table/tbody/tr/td[contains(., '#{@no[1]}')]/a").click
  page.find("//*[@id='content']/div/table/tbody/tr[1]/td[2]/div[1]/a").click
  sleep 1

  if @no[1].include?("v1")
    File.open("#{ENV['DOWNLOAD_DIR']}/#{@no[1]}.pdf", 'rb') do |io|
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
        # page.text
        puts expect(page.should have_content('Author 3')).to be true
      end
    end
  elsif @no[1].include?("v2")

    File.open("#{ENV['DOWNLOAD_DIR']}/#{@no[1]}.pdf", 'rb') do |io|
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
        page.text
        puts expect(page.should have_content('Author 3')).to be true
      end
      sleep 10
      # @session.driver.browser.action.context_click(self.native).perform

    end


  end

  clear_downloads


  if @issu_acronm == 'regular'
    visit 'http://beta.mts.hindawi.com/sally.safwat@hindawi.com/sa123456/' + @editor_email
    page.find("//*[@id='container']/div[5]//a[text()[normalize-space(.) = 'Editor Activities']]").click

    page.find("//*[@id ='container']/div[5]/div/table/tbody/tr/td[contains(., '#{@no[1]}')]/a").click
    page.find("//*[@id='content']/div/table/tbody/tr[1]/td[2]/div[1]/a").click
    sleep 1

    chekdown
    clear_downloads

  else

    editor = select_from_dbs("mtsv2", "select EditorsEdCategories.userid
from EditorsEdCategories left outer join users
on EditorsEdCategories.userid=users.userid
left outer join journals
on EditorsEdCategories.journalid=journals.journalid
where( EditorsEdCategories.termenddate is null or termenddate >getdate())
and journals.issold=0
and journals.isceased=0
and users.email='#{@editor_email}'")

    editor.each do |row|
      @edtor = row
    end


    puts @edtor


    g_editor = select_from_dbs("mtsv2", "select EditorsIssues.UserId
from EditorsIssues left outer join users
on EditorsIssues.userid=users.UserId
where
 EditorsIssues.userid in (select currenteditorid from manuscripts where manuscriptid = '#{@msddz}')
 and email ='#{@editor_email}'")

    g_editor.each do |row|
      @gdtor = row
    end

    puts @gdtor


    lg_editor = select_from_dbs("mtsv2", "select EditorsIssues.UserId
from EditorsIssues left outer join users
on EditorsIssues.userid=users.UserId
where IsLeadGuestEditor='1'
 and EditorsIssues.userid in (select currenteditorid from manuscripts where manuscriptid = '#{@msddz}')
 and email ='#{@editor_email}'")

    lg_editor.each do |row|
      @lgdtor = row
    end

    puts @lgdtor


    if @edtor.nil? == false

      visit 'http://beta.mts.hindawi.com/sally.safwat@hindawi.com/sa123456/' + @editor_email
      sleep 1
      page.find("//*[@id='container']/div[5]//a[text()[normalize-space(.) = 'Editor Activities']]").click
      sleep 1
      @no = @zz.split('/')
      page.find("//*[@id ='container']/div[5]/div/table/tbody/tr/td[contains(., '#{@no[1]}')]/a").click
      sleep 1
      page.find("//*[@id='content']/div/table/tbody/tr[1]/td[2]/div[1]/a").click
      sleep 1
      chekdown
      clear_downloads


    elsif @gdtor.nil? == false


      visit 'http://beta.mts.hindawi.com/sally.safwat@hindawi.com/sa123456/' + @editor_email
      sleep 1
      page.find("//*[@id='container']/div[5]//a[text()[normalize-space(.) = 'Guest Editor Activities']]").click
      sleep 1
      page.find("//*[@id='container']/div[5]/div/table/tbody/tr[contains(., '#{@issu_acronm}')]/td//following-sibling::td[4]").click
      @no = @zz.split('/')
      sleep 1
      page.find("//*[@id ='container']/div[5]//tr//td[contains(., '#{@no[1]}')]/a").click
      sleep 1
      page.find("//*[@id='content']/div/table/tbody/tr[1]/td[2]/div[1]/a").click
      sleep 1
      chekdown
      clear_downloads


    elsif @lgdtor.nil? == false

      visit 'http://beta.mts.hindawi.com/sally.safwat@hindawi.com/sa123456/' + @editor_email
      sleep 1
      page.find("//*[@id='container']/div[5]//a[text()[normalize-space(.) = 'Lead Guest Editor Activities']]").click
      sleep 1
      page.find("//*[@id='container']/div[5]/div/table/tbody/tr[contains(., '#{@issu_acronm}')]/td//following-sibling::td[4]").click
      sleep 1
      @no = @zz.split('/')
      page.find("//*[@id ='container']/div[5]/div/table/tbody/tr/td[contains(., '#{@no[1]}')]/a").click
      sleep 1
      page.find("//*[@id='content']/div/table/tbody/tr[1]/td[2]/div[1]/a").click
      sleep 1
      chekdown
      clear_downloads

    end
  end
end

###############################################
# ##############When######################
##########################################
#
#
When("I choose random MS and click on Edit Manuscript") do

  selectMS
  page.find("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]/a").click
  sleep 1
  loop do
    if page.has_selector?("//b[text()='You are not authorized to view this page.']")
      page.evaluate_script('window.history.back()')
      sleep 1
      page.evaluate_script('window.history.back()')
      sleep 1
      selectMS
      page.find("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]/a").click
    end
    break if page.has_selector?("//*[@id='form0']/table/tbody/tr[1]/td[1]")
  end
end


When("I click  on Update") do
  find("//*[@id='form0']/table/tbody/tr[31]/td[2]/input").click
  sleep 1
end

When("I choose ms from db") do
  sleep 1
  msid = select_from_dbs("mtsv2", "select ManuscriptId from manuscripts Where CurrentRecommendationId = 'EdMajor' and MSSubmitDate >= '2018-01-01 00:00:00'")
  idez = []
  msid.each do |row|
    @msdd = row['ManuscriptId']
    idez << @msdd
  end
  @msddz = idez.sample
  puts @msddz

  sleep 1
  issueidz = select_from_dbs("mtsv2", "Select IssueId from manuscripts where  manuscriptid ='#{@msddz}'")
  issueidz.each do |row|

    @issu_acronm = row['IssueId']
  end

  puts @issu_acronm

  sleep 1
  use = select_from_dbs("mtsv2", "select UserId from staffmanuscripts where manuscriptid ='#{@msddz}'")
  use.each do |row|
    @user = row['UserId']
  end
  puts @user

  email = select_from_dbs("mtsv2", "select Email from users where userid ='#{@user}'")
  email.each do |row|
    @emeil = row['Email']
  end
  puts @emeil

  visit 'http://beta.admin.mts.hindawi.com/auth/' + @emeil
  sleep 1
  puts url = URI.parse(current_url)

  visit url + @msddz
  sleep 2
# break if page.has_selector?("//*[@id='container']/div[9]/ul/li[contains(.,'Edit Manuscript Details')]")
  page.find("//a[contains(text(),'Edit Manuscript Details')]").click

  sleep 1
  # end

end