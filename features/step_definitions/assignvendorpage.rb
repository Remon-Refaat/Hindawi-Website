##############################
########## Given #############
##############################
Given /^Login into Admin MTS$/ do
  step %Q{Navigate to "http://beta.admin.mts.hindawi.com"}
  if page.has_selector?("//input[@type='email']")
    fill_in "identifierId", with: 'mts.hindawi@gmail.com'
    find("//*[@id='identifierNext']/content/span").click
    find("//*[@id='password']/div[1]/div/div[1]/input").send_keys("Mts123456")
    find("//*[@id='passwordNext']/content/span").click
    sleep 5
  end
end


Given /^Navigate to "(.*)", open Assign vendor page and verify that the last saved selection is displayed$/ do |url|
  new_window = window_opened_by do
    page.execute_script("window.open()")
  end
  within_window new_window do
    step %Q{Navigate to "#{url}"}
    step %Q{Open "Assign Vendor" page from the main menu}
    step %Q{The last saved selection is displayed}
  end
end

##############################
########## And ###############
##############################
And /^Open "(.*)" page from the main menu$/ do |link|
  find("//a[contains(text(), '#{link}')]").click
end

And /^Hover on the main menu of the page$/ do
  find("//a[@href='/admin/']").hover
end

And /^Open "Assign Vendor" page from the hover$/ do
      find("//*[@id='ctl00_NavigationBar1_LeftNavBar']//li[9]/a").click
end

And /^Search with "(.*)"$/ do |keyword|
   find("//input[@type='search']").send_keys keyword
end

And /^Remove "(.*)" from the search field$/ do |arg|
  find("//input[@type='search']").send_keys :backspace
end



# And /^Assign another vendor to a certain journal$/ do
#   @journal = page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").sample
#   @journal_name = @journal.text
#   @vendors = page.all("//td[contains(text(),'#{@journal_name}')]/following-sibling::td/select/option")
#   @previous_selected_option = @vendors.detect {|option| option if option.selected?}
#   unselected_options = @vendors.select {|option| option if option.selected? == false}
#   @selected_options = unselected_options.sample
#   @selected_options.click
#   @@selected_options_name = @selected_options.text
#   @previous_vendor_name = @previous_selected_option.text

# end

And /^Assign another vendor to a certain journal$/ do
  @journal = page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").sample
 puts @journal_name = @journal.text
  @vendors = page.all("//td[contains(text(),'#{@journal_name}')]/following-sibling::td/select/option")
  previous_selected_option = @vendors.detect {|option| option if option.selected?}
  unselected_options = @vendors.select {|option| option if option.selected? == false}
  selected_options = unselected_options.sample
  selected_options.click
 puts @previous_vendor_name = previous_selected_option.text
  puts @selected_options_name = selected_options.text

end

And /^Open the drop down list and choose the same vendor which is already selected$/ do
  journal = page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").sample
  journal_name = journal.text
  vendors = page.all("//td[contains(text(),'#{journal_name}')]/following-sibling::td/select/option")
  selected_option = vendors.detect {|option| option if option.selected?}
  selected_option.click
end

And /^Assign another vendor to a different journal-1$/ do
  journal_1 = page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]")
  loop do
    sampled_journal = journal_1.sample
    @journal_name_1 = sampled_journal.text
    break if @journal_name_1 != @journal_name
  end
  @vendors_1 = page.all("//td[contains(text(),'#{@journal_name_1}')]/following-sibling::td/select/option")
  @previous_option_1 = @vendors_1.detect {|option| option if option.selected?}
  unselected_options = @vendors_1.select {|option| option if option.selected? == false}
  selected_options = unselected_options.sample
  selected_options.click
  puts @journal_name_1
  puts @previous_vendor_name_1 = @previous_option_1.text
  puts @vendors_name_1 = selected_options.text


end

And(/^Assign another vendor to a different journal-2$/) do
  journal_2 = page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]")
  loop do
    sampled_journal = journal_2.sample
    @journal_name_2 = sampled_journal.text
    break if (@journal_name_2 != @journal_name) && (@journal_name_2 != @journal_name_1)
  end
  @vendors_2 = page.all("//td[contains(text(),'#{@journal_name_2}')]/following-sibling::td/select/option")
  @previous_option_2 = @vendors_2.detect {|option| option if option.selected?}
  unselected_options = @vendors_2.select {|option| option if option.selected? == false}
  selected_options = unselected_options.sample
  selected_options.click
  puts @journal_name_2
  puts @previous_vendor_name_2 = @previous_option_2.text
  puts @vendors_name_2 = selected_options.text

end
And /^make any modifications in the page$/ do
  step %Q{Assign another vendor to a different journal-1}
  step %Q{Assign another vendor to a different journal-2}
end

And /^Make refresh to the page$/ do
  Capybara.page.driver.browser.navigate.refresh
end
And /^Make a new submission 1 with type "(.*)" in "(.*)"$/ do |type, section|
  submission_window = window_opened_by do
    page.execute_script("window.open()")
  end
  within_window submission_window do
    new_submission(type, section)
    @manuscriptid_1 = find("//*[@id='container']/div[5]/div[2]/div/p[1]/a").text
    puts @manuscriptid_1
  end
end
And /^Make a new submission 2 with type "(.*)" in "(.*)"$/ do |type, section|
  submission_window = window_opened_by do
    page.execute_script("window.open()")
  end
  within_window submission_window do
    new_submission(type, section)
    @manuscriptid_2 = find("//*[@id='container']/div[5]/div[2]/div/p[1]/a").text
  end
end

And /^Make flag to journals as ceased, sold, in test mode$/ do
  ####make them active firstly
  execute_dbs_query("UPDATE dbo.Journals SET IsSold=0 WHERE FullName='Behavioural Neurology'
UPDATE dbo.Journals SET IsCeased=0 WHERE FullName='Biochemistry Research International'
UPDATE dbo.Journals SET InTestMode=0 WHERE FullName='Bone Marrow Research'")
  ####then make them not active
  execute_dbs_query("UPDATE dbo.Journals SET IsSold=1 WHERE FullName='Behavioural Neurology'
UPDATE dbo.Journals SET IsCeased=1 WHERE FullName='Biochemistry Research International'
UPDATE dbo.Journals SET InTestMode=1 WHERE FullName='Bone Marrow Research'")
end

And /^Make flag to journals as active$/ do
  ####make them not active firstly
  execute_dbs_query("UPDATE dbo.Journals SET IsSold=1 WHERE FullName='Behavioural Neurology'
UPDATE dbo.Journals SET IsCeased=1 WHERE FullName='Biochemistry Research International'
UPDATE dbo.Journals SET InTestMode=1 WHERE FullName='Bone Marrow Research'")
  ####then make them active
  execute_dbs_query("UPDATE dbo.Journals SET IsSold=0 WHERE FullName='Behavioural Neurology'
UPDATE dbo.Journals SET IsCeased=0 WHERE FullName='Biochemistry Research International'
UPDATE dbo.Journals SET InTestMode=0 WHERE FullName='Bone Marrow Research'")
end

And /^check the total number of journals assigned to each vendor$/ do
   @hindawi_counter = (find("//*[@id='MtsTable']//td[contains(text(),'Hindawi')]/following-sibling::td").text).to_i
   @spi_counter = (find("//*[@id='MtsTable']//td[contains(text(),'SPI')]/following-sibling::td").text).to_i
   @sps_counter = (find("//*[@id='MtsTable']//td[contains(text(),'SPS')]/following-sibling::td").text).to_i

end

And /^Choose a certain journal-selected journal$/ do
  journal = page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").sample
  @selected_journal_name = journal.text
end

And /^In a new browser, navigate to "(.*)", Assign another vendor and Press on Save$/ do |url|
  Capybara.using_session(:selenium_chrome) do
    visit url
    login
    visit url
    step %Q{Open "Assign Vendor" page from the main menu}
    vendors = page.all("//td[contains(text(),'#{@selected_journal_name}')]/following-sibling::td/select/option")
    unselected_options = vendors.select {|option| option if option.selected? == false}
    puts unselected_options.length
    selected_options = unselected_options.sample
    puts @selected_options_name = selected_options.text
    selected_options.click
    Capybara.current_session.driver.quit
  end
end

And /^Clear the search field$/ do
  find("//input[@type='search']").send_keys :backspace, :backspace, :backspace
end

And /^Return the first vendor to the journal$/ do
  @previous_selected_option.click
end

And /^Check the list of journals before searching$/ do
  @journalscount1 = page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").length
end

And /^Try to Assign the same vendor to the same journal at the first browser$/ do
  find("//td[contains(text(),'#{@selected_journal_name}')]/following-sibling::td/select/option[contains(text(),'#{@selected_options_name}')]")
end

And /^Assign another vendor to a certain journal after filtration$/ do

  @journal = page.all("//*[@id='DataTables_Table_0']/tbody/tr[not(@style='display: none;')]/td[1]").sample
  puts @journal_name = @journal.text
  @vendors = page.all("//td[contains(text(),'#{@journal_name}')]/following-sibling::td/select/option")
  unselected_options = @vendors.select {|option| option if option.selected? == false}
  selected_options = unselected_options.sample
  selected_options.click
  @selected_options_name = selected_options.text

end

##############################
########## When ##############
##############################

When(/^Press on button Save$/) do
  find("//input[@type='submit']").click
end

##############################
########## Then ##############
##############################
# Then /^Press on "(.*)"$/ do |link|
#   click_link link
# end

Then /^"(.*)" link is displayed in the main menu$/ do |link|
  within("//*[@id='container']/div[9]") do
    expect(page.has_selector?("//a[contains(text(), '#{link}')]")).to be_truthy
  end
end


Then /^"(.*)" page is opened$/ do |title|
  expect(page.has_selector?("//h1[contains(text(),'#{title}')]")).to be_truthy
end

Then /^"(.*)" link is displayed in the hover menu$/ do |link|
  within("//*[@id='ctl00_NavigationBar1_LeftNavBar']/div/ul/li") do
    expect(page.has_selector?("//a[contains(text(), '#{link}')]")).to be_truthy
  end
end


Then /^"(.*)" page is not displayed in the main menu or in the hover menu$/ do |link|
  error_1 = []
  error_2 = []
  begin
    within("//*[@id='container']/div[9]") do
      expect(page.has_selector?("//a[contains(text(), '#{link}')]")).to be_falsey
    end
  rescue RSpec::Expectations::ExpectationNotMetError
    error_1 << "The page is found in the main menu"
  end
  begin
    within("//*[@id='ctl00_NavigationBar1_LeftNavBar']/div/ul/li") do
      expect(page.has_selector?("//a[contains(text(), '#{link}')]")).to be_falsey
    end
  rescue RSpec::Expectations::ExpectationNotMetError
    error_2 << "The page is found in the hover menu"
  end
  errors = error_1 + error_2
  expect(errors).to eq([])
end

Then /^"(.*)" page does not opened for "(.*)"$/ do |title,useremail|
  url = page.current_url
   step %Q{Navigate to "#{url}assign.vendor/"}
  expect(page.has_selector?("//h1[contains(text(),'#{title}')]")).to be_falsey
end


Then /^Search with "(.*)" and make sure that the displayed journals are only all results that contain the keywords$/ do |keyword|
  journals_before = []
  journals_after = []
  page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").each do |journal|
    if (journal.text).include? keyword
      journals_before << journal.text
    end
  end
  step %Q{Search with "#{keyword}"}
  page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").each do |journal|
    journals_after << journal.text
  end
  expect(journals_before).to eq journals_after
end

Then /^The displayed journals' names contain the keyword "(.*)"$/ do |keyword|
  @journal_no1 = page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").length
  errors = []
  page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").each do |journal|
    begin
      expect((journal.text).include? keyword).to be_truthy
    rescue RSpec::Expectations::ExpectationNotMetError
      errors << journal.text
    end

  end
end

Then /^"(.*)" message is displayed$/ do |message|
  expect(find("//*[contains(text(),'#{message}')]").text).to eq message
end


Then /^The displayed journals' names contain the keyword "(.*)" and the number of journals is changed$/ do |keyword|
  journal_no2 = page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").length
  error1 = []
  error2 = []
  page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").each do |journal|
    begin
      expect((journal.text).include? keyword).to be_truthy
    rescue RSpec::Expectations::ExpectationNotMetError
      error1 << journal.text
    end
  end
  begin
    expect(@journal_no1).not_to eq journal_no2
  rescue RSpec::Expectations::ExpectationNotMetError
    error2 << "The number of journals are identical"
  end
  errors = error1 + error2
  expect(errors).to eq([])
end


Then /^The list of journals is displayed alphabetically$/ do
  journals_names = []
  journals = page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]")
  journals.each do |journal|
    journals_names << journal.text
    end
  expect(journals_names).to eq journals_names.sort(&:casecmp)
end

Then /^Drop down list Editorial Communication Vendor is displayed next to each journal$/ do
  error = []
  page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").each do |journal|
    begin
      expect(page.has_selector?("//td[contains(text(),'#{journal.text}')]/following-sibling::td/select")).to be_truthy
    rescue RSpec::Expectations::ExpectationNotMetError
      error << journal.text
    end
   expect(error).to eq([])
  end
end

Then /^The full list of journals will be displayed$/ do
   journalscount2 = page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").length
  expect(@journalscount1).to eq(journalscount2)
end

Then /^Drop down list contains the following "(.*)" items:$/ do |num, table|
  journal = page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").sample
  journal_name = journal.text
  firstoptions = []
  secondoptions = []
  length_error = []
  equality_error = []
  options = page.all("//td[contains(text(),'#{journal_name}')]/following-sibling::td/select/option")
  begin
    expect(options.length).to eq(num.to_i)
  rescue RSpec::Expectations::ExpectationNotMetError
    length_error << "Length is not equal to 3"
  end
  options.each do |option|
    firstoptions << option.text
  end
  table.rows.each do |row|
    secondoptions << row[0]
  end
  begin
    expect(firstoptions).to eq(secondoptions)
  rescue RSpec::Expectations::ExpectationNotMetError
    equality_error << "firstoptions is not equal to secondoptions"
  end
  final = length_error + equality_error
   expect(final).to eq([])
end


Then /^Save button is inactive$/ do
  expect(find("//input[@type='submit']").disabled?).to be_truthy
end

Then /^Save button is active$/ do
  expect(find("//input[@type='submit']").disabled?).to be_falsey
end


Then /^The same Drop down list contains the following "(.*)" items:$/ do |num, table|
  firstoptions = []
  secondoptions = []
  length_error = []
  equality_error = []
  begin
    expect(@vendors.length).to eq(num.to_i)
  rescue RSpec::Expectations::ExpectationNotMetError
    length_error << "Length is not equal to 3"
  end

  # @vendors.each do |option|
  page.all("//td[contains(text(),'#{@journal_name}')]/following-sibling::td/select/option").each do |option|
    firstoptions << option.text
  end
  table.rows.each do |row|
    secondoptions << row[0]
  end
  begin
    expect(firstoptions).to eq(secondoptions)
  rescue RSpec::Expectations::ExpectationNotMetError
    equality_error << "firstoptions is not equal to secondoptions"
  end
  final = length_error + equality_error
  expect(final).to eq([])
end

Then /^The last saved selection in drop down list shall be displayed as the default selection$/ do

  selected_options = find("//td[contains(text(),'#{@journal_name}')]/following-sibling::td/select/option[contains(text(),'#{@selected_options_name}')]")
  expect(selected_options.selected?).to be_truthy

   # expect(@selected_options.selected?).to be_truthy
  end


Then /^Summary Table displays Editorial Communication Vendor alphabetically$/ do
  vendor_names = []
  vendors = page.all("//*[@id='MtsTable']/tbody/tr/td[1]")
  vendors.each do |vendor|
    vendor_names << vendor.text
  end
  expect(vendor_names).to eq vendor_names.sort(&:casecmp)
end



Then /^The page contains only one Save button$/ do
  expect(page.all("//input[@value='Save']").length).to eq(1)
end

Then /^Editorial Communication Vendor in Summary Table displays only the following list$/ do |table|
  firstoptions = []
  secondoptions = []
  vendor_list = page.all("//*[@id='MtsTable']/tbody/tr/td[1]")
  vendor_list.each do |item|
    firstoptions << item.text
  end
  table.rows.each do |row|
    secondoptions << row[0]
  end
  expect(firstoptions).to eq(secondoptions)
end


Then(/^No change is applied to the page$/) do
  error1 = []
  error2 = []
  vendors_name_1 = (page.all("//td[contains(text(),'#{@journal_name_1}')]/following-sibling::td/select/option").detect {|option| option if option.selected?}).text
  vendors_name_2 = (page.all("//td[contains(text(),'#{@journal_name_2}')]/following-sibling::td/select/option").detect {|option| option if option.selected?}).text
  begin
    expect(vendors_name_1).to eq @previous_vendor_name_1
  rescue RSpec::Expectations::ExpectationNotMetError
    error1 << "change is applied to vendors_1"
  end
  begin
    expect(vendors_name_2).to eq @previous_vendor_name_1
  rescue RSpec::Expectations::ExpectationNotMetError
    error2 << "change is applied to vendors_2"
  end
  errors = error1 + error2
  expect(errors).to eq([])
end

Then /^New vendor is saved$/ do
  # selected_option = @vendors.detect {|option| option if option.selected?}
  # selected_option_name = selected_option.text
  # expect(@vendors_name).to eq(selected_option_name)
  selected_option = page.all("//td[contains(text(),'#{@journal_name}')]/following-sibling::td/select/option").detect{|option| option if option.selected?}
  selected_option_name = selected_option.text
   puts @selected_options_name
  puts selected_option_name
   expect(selected_option_name).to eq(@selected_options_name)

end

Then /^New vendor is saved for all journals$/ do
  selected_option = page.all("//td[contains(text(),'#{@journal_name}')]/following-sibling::td/select/option").detect{|option| option if option.selected?}
  selected_option_1 = page.all("//td[contains(text(),'#{@journal_name_1}')]/following-sibling::td/select/option").detect {|option| option if option.selected?}
  selected_option_2 = page.all("//td[contains(text(),'#{@journal_name_2}')]/following-sibling::td/select/option").detect {|option| option if option.selected?}
  selected_option_name = selected_option.text
  selected_option_1_name = selected_option_1.text
  selected_option_2_name = selected_option_2.text
  selected_options = [@selected_options_name, @vendors_name_1, @vendors_name_2]
  saved_options = [selected_option_name, selected_option_1_name, selected_option_2_name]
  expect(selected_options).to eq(saved_options)


end


Then /^journals "(should|should not)" be displayed in the list of journals$/ do |assertion|
  error1 = []
  error2 = []
  error3 = []
  @ceased_journal = "Biochemistry Research International"
  @sold_journal = "Behavioural Neurology"
  @testmode_journal = "Bone Marrow Research"
  begin
    expect(page.has_selector?("//td[contains(text(),'#{@ceased_journal}')]") == false).to eq(assertion == "should not")
  rescue RSpec::Expectations::ExpectationNotMetError
    error1 << "Ceased Journal"
  end
  begin
    expect(page.has_selector?("//td[contains(text(),'#{@sold_journal}')]") == false).to eq(assertion == "should not")
  rescue RSpec::Expectations::ExpectationNotMetError
    error2 << "Sold Journal"
  end
  begin
    expect(page.has_selector?("//td[contains(text(),'#{@testmode_journal}')]") == false).to eq(assertion == "should not")
  rescue RSpec::Expectations::ExpectationNotMetError
    error3 << "Test Mode Journal"
  end

  errors = error1 + error2 + error3

  expect(errors).to eq([])
end


Then /^Number of Journals Assigned column displays the total number of journals assigned to each vendor$/ do
  actual_counter = []
  expected_counter = []
  hindawi = []
  spi = []
  sps = []
  page.all("//*[@id='MtsTable']/tbody/tr/td[2]").each do |counter|
    actual_counter << (counter.text).to_i
  end

  page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[1]").each do |journal|
    hindawi << journal.text if find("//td[normalize-space()='#{journal.text}']/following-sibling::td/select/option[@selected='selected']").text == "Hindawi"
    spi << journal.text if find("//td[normalize-space()='#{journal.text}']/following-sibling::td/select/option[@selected='selected']").text == "SPI"
    sps << journal.text if find("//td[normalize-space()='#{journal.text}']/following-sibling::td/select/option[@selected='selected']").text == "SPS"
  end
  expected_counter << hindawi.length << spi.length << sps.length
  expect(actual_counter).to eq(expected_counter)
end


Then /^Number of Journals Assigned column is updated only upon clicking the Save button$/ do
  new_hindawi_counter = (find("//*[@id='MtsTable']//td[contains(text(),'Hindawi')]/following-sibling::td").text).to_i
  new_SPI_counter = (find("//*[@id='MtsTable']//td[contains(text(),'SPI')]/following-sibling::td").text).to_i
  new_sps_counter = (find("//*[@id='MtsTable']//td[contains(text(),'SPS')]/following-sibling::td").text).to_i

  if @previous_vendor_name == "Hindawi" && @selected_options_name == "SPI"
    expect([new_hindawi_counter, new_SPI_counter, new_sps_counter]).to eq([@hindawi_counter - 1, @spi_counter + 1, @sps_counter])
  elsif @previous_vendor_name == "Hindawi" && @selected_options_name == "SPS"
    expect([new_hindawi_counter, new_SPI_counter, new_sps_counter]).to eq([@hindawi_counter - 1, @spi_counter, @sps_counter + 1])
  elsif @previous_vendor_name == "SPI" && @selected_options_name == "Hindawi"
    expect([new_hindawi_counter, new_SPI_counter, new_sps_counter]).to eq([@hindawi_counter + 1, @spi_counter - 1, @sps_counter])
  elsif @previous_vendor_name == "SPI" && @selected_options_name == "SPS"
    expect([new_hindawi_counter, new_SPI_counter, new_sps_counter]).to eq([@hindawi_counter, @spi_counter - 1, @sps_counter + 1])
  elsif @previous_vendor_name == "SPS" && @selected_options_name == "Hindawi"
    expect([new_hindawi_counter, new_SPI_counter, new_sps_counter]).to eq([@hindawi_counter + 1, @spi_counter, @sps_counter - 1])
  else
    expect([new_hindawi_counter, new_SPI_counter, new_sps_counter]).to eq([@hindawi_counter, @spi_counter + 1, @sps_counter - 1])
  end

end

And /^Auto-assign tool will assign EA for the submission 1$/ do
  execute_dbs_query("UPDATE SubmissionsSendMail SET EQSReleaseDate=GETDATE() WHERE ManuscriptId=#{@manuscriptid_1}")
end

And /^Auto-asign tool will assign EA for the submission 2$/ do
  execute_dbs_query("UPDATE SubmissionsSendMail SET EQSReleaseDate=GETDATE() WHERE ManuscriptId=#{@manuscriptid_2}")
end

Then(/^Make sure that new submission 1 is assigned to the editorial assistant of vendor 1$/) do
  x = select_from_dbs("SELECT  journals.EditorialVendor
FROM dbo.Staffs LEFT OUTER JOIN dbo.Users
ON Users.UserId = Staffs.UserId
LEFT OUTER JOIN dbo.Seniors
ON seniors.UserId=dbo.Staffs.SeniorId
LEFT OUTER JOIN dbo.SeniorJournals
ON SeniorJournals.UserId = Seniors.UserId
LEFT OUTER JOIN dbo.Journals
ON Journals.JournalId = SeniorJournals.JournalId
LEFT OUTER JOIN dbo.StaffManuscripts
ON staffmanuscripts.UserId=staffs.UserId
AND staffmanuscripts.JournalId=journals.JournalId
WHERE dbo.SeniorJournals.UnassignDate IS NULL
AND dbo.StaffManuscripts.ManuscriptId='#{@manuscriptid_1}'")
  x.each do |y|
    @journal_vendor = y['EditorialVendor']
  end
  expect(@journal_vendor).to eq(@selected_options_name)
end

When /^Assign another vendor to the same journal$/ do
  @vendors = page.all("//td[contains(text(),'#{@journal_name}')]/following-sibling::td/select/option")
  @previous_selected_option = @vendors.detect {|option| option if option.selected?}
  unselected_options = @vendors.select {|option| option if option.selected? == false}
  @selected_options = unselected_options.sample
  @selected_options.click
  puts @previous_vendor_name = @previous_selected_option.text
  puts @vendors_name = @selected_options.text

end

Then /^Make sure that new submission 2 is assigned to the editorial assistant of vendor 2$/ do
  x = select_from_dbs("SELECT  journals.EditorialVendor
FROM dbo.Staffs LEFT OUTER JOIN dbo.Users
ON Users.UserId = Staffs.UserId
LEFT OUTER JOIN dbo.Seniors
ON seniors.UserId=dbo.Staffs.SeniorId
LEFT OUTER JOIN dbo.SeniorJournals
ON SeniorJournals.UserId = Seniors.UserId
LEFT OUTER JOIN dbo.Journals
ON Journals.JournalId = SeniorJournals.JournalId
LEFT OUTER JOIN dbo.StaffManuscripts
ON staffmanuscripts.UserId=staffs.UserId
AND staffmanuscripts.JournalId=journals.JournalId
WHERE dbo.SeniorJournals.UnassignDate IS NULL
AND dbo.StaffManuscripts.ManuscriptId='#{@manuscriptid_2}'")
  x.each do |y|
    @vendor_affiliation = y['EditorialVendor']
  end
  expect(@vendor_affiliation).to eq(@vendors_name)
end

Then /^Drop down list of all vendors is dimmed$/ do
  active_ddl = []
  page.all("//select").each do |ddl|
    begin
      expect(ddl.disabled?).to be_truthy
    rescue RSpec::Expectations::ExpectationNotMetError
      active_ddl << "active ddl"
    end
  end
  expect(active_ddl).to eq([])
end



Then /^The last saved selection is displayed$/ do
  current_name = find("//td[contains(text(),'#{@journal_name}')]/following-sibling::td/select/option[@selected='selected']").text
  expect(current_name).to eq(@vendors_name)
   end



When(/^Return to the previous selected item$/) do
find("//td[contains(text(),'#{@journal_name}')]/following-sibling::td/select/option[contains(text(),'#{@previous_vendor_name}')]").click
  #@previous_selected_option.click
end

Then /^Make sure that the journal is assigned to the correct vendor once in the database$/ do
  x = select_from_dbs("SELECT COUNT(EditorialVendor) FROM journals WHERE FullName='#{@selected_journal_name}' ")
  x.each do |row|
    @vendor_count = row[""]
  end
  expect(@vendor_count).to eq(1)
end


Then(/^The previous selected item shall be displayed as the default selection$/) do
  selected_options = find("//td[contains(text(),'#{@journal_name}')]/following-sibling::td/select/option[contains(text(),'#{@previous_vendor_name}')]")
   expect(selected_options.selected?).to be_truthy
  # expect(@previous_selected_option.selected?).to be_truthy
end


And /^Assign vendor "(.*)" to a certain journal for vendor "(.*)"$/ do |newvendor, previousvendor|
  x = select_from_dbs("SELECT top 1 FullName FROM journals WHERE EditorialVendor ='#{previousvendor}' and IsSold=0 and IsCeased=0 and InTestMode=0")
  x.each do |row|
    @journal_name = row["FullName"]
  end
  selected_option = find("//td[contains(text(),'#{@journal_name}')]/following-sibling::td/select/option[normalize-space()='#{newvendor}']")
  selected_option.click
end

Then /^Make sure that new submission 1 is assigned to one of certain editorial assistant$/ do
  sleep 5
  ea_emails = ["norhan.rizq@hindawi.com", "amany.hemeda@hindawi.com", "marina.adel@hindawi.com", "huda.qabeel@hindawi.com"]
email_query = select_from_dbs("SELECT Email FROM dbo.StaffManuscripts LEFT OUTER JOIN dbo.Users ON Users.UserId = StaffManuscripts.UserId WHERE ManuscriptId='#{@manuscriptid_1}'")
sleep 5
email_query.each do |row|
 @actual_email = row["Email"]
end
  expect(ea_emails.include?(@actual_email)).to be_truthy
end


Then /^Make sure that filtration dropdown list contains "(.*)", "(.*)", "(.*)"$/ do |vendor1, vendor2, vendor3|
  expected_options = []
  actual_options = []
  vendors_filteration = page.all("//*[@id='ddlSearchJournal']/option")
  options = vendors_filteration.select {|option| option if option.text != "--Please Select--"}
  options.each do |option|
    actual_options << (option.text).strip
  end
  expected_options << vendor1 << vendor2 << vendor3
  expect(actual_options).to eq(expected_options)
end

When /^Select one of the vendor from the drop down list$/ do
  vendors_filteration = page.all("//*[@id='ddlSearchJournal']/option")
  options = vendors_filteration.select {|option| option if option.text != "--Please Select--"}
  @option = options.sample
  @option.click
end

Then /^Only the journals assigned to this vendor will be displayed$/ do
  error = []
  selected_vendors = page.all("//*[@id='DataTables_Table_0']/tbody/tr[not(@style='display: none;')]/td[2]//option[@selected='selected']")
  selected_vendors.each do |selected_vendor|
    begin
      expect(selected_vendor.text).to eq(@option.text.strip)
    rescue
      error << selected_vendor
    end
     expect(error).to eq([])
  end
end



Then /^All the journals assigned to this vendor will be displayed$/ do
  vendor_before = []
  vendor_after = []
  page.all("//*[@id='DataTables_Table_0']/tbody/tr[not(@style='display: none;')]/td[2]//option[@selected='selected']").each do |selected_option|
    if selected_option.text.strip == @option.text.strip
      vendor_before << selected_option.text.strip
    end
  end
  find("//*[@id='ddlSearchJournal']//option[contains(text(),'Please')]").click
  page.all("//*[@id='DataTables_Table_0']/tbody/tr/td[2]//option[@selected='selected']").each do |selected_option|
    if selected_option.text.strip == @option.text.strip
    vendor_after << selected_option.text.strip
      end
  end
  expect(vendor_before.length).to eq(vendor_after.length)
end

