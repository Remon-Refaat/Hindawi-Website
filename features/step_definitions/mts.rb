##############################
########## Given #############
##############################
Given /^Navigate to "(.*)"$/ do |url|
  visit url
end


Given /^Choose (\d+) authors$/ do |authorsnum|
  @authorsnum = authorsnum
  select authorsnum, from: "Authors_SelectedAuthorCount"
end

Given /^Add the data of all authors$/ do |table|
  i = 0
  table.hashes.each do |row|
    fill_in "Authors_AuthorList_#{i}__FirstName", with: row['First Name']
    fill_in "Authors_AuthorList_#{i}__LastName", with: row['Last Name']
    fill_in "Authors_AuthorList_#{i}__Email", with: row['Email Address']
    fill_in "Authors_AuthorList_#{i}__Affiliation", with: row['Affiliation']
    select row['Country'], from: "Authors_AuthorList_#{i}__CountryId"
    if row['Corresponding Author'].downcase == "yes"
      choose "AuthorList[#{i}].IsCorresponding"
    end
    i += 1
  end
end

##############################
########## And ###############
##############################

And /^Press on "(.*)"$/ do |btn|
  click_button btn
end
And /^Click on "(.*)"$/ do |link|
  within(:xpath, '//*[@id="container"]/div[5]') do
     click_link link
  end
end

And /^Select a random journal$/ do
  journals = page.all(:xpath,"//div[@id='myul']//a")
  journals[rand(journals.length)].click
  page_title = find(:xpath, '//*[@id="container"]/div[5]/h1').text
  if (page_title).include?("Select an Issue")
    click_link 'Regular Issues'
  elsif (page_title).include?("Select a Subject Area")
    find(:xpath,'//*[@id="container"]/div[5]/div/div[1]/ul/li[1]/a').click
    if (page_title).include?("Select an Issue")
    click_link 'Regular Issues'
    end
    end
  end
And /^Choose "(\d+)" authors$/ do |num|
  first(:xpath, "//div/select/option[#{num}]").click
end

And /^Add title of the manuscript$/ do
  title = Faker::Book.title
  fill_in 'Manuscript_Title', with: title
end

And /^Choose a file "(.*)" for "(.*)"$/ do |file, type|
  find(:xpath, "//input[@name='#{type}']").send_keys ENV['DATAPATH'] + file
end
And /^Select the answers of the questions "(.*)", "(.*)", and "(.*)"$/ do |ans1, ans2, ans3|

  types = ["Research Article", "Clinical Study", "Review Article", "Letter to the Editor", "Case Report"]
  find("//td[contains(text(),'conflicts of interest')]/../following-sibling::tr[1]//input[@value='#{ans1}']").click if types.include?("#{@article}")
  find("//td[contains(text(),'data availability')]/../following-sibling::tr[1]//input[@value='#{ans2}']").click if types.first(2).include?("#{@article}")
  find("//td[contains(text(),'funding')]/../following-sibling::tr[1]//input[@value='#{ans3}']").click if types.first(2).include?("#{@article}")

end

And /^Choose an invalid manuscript file type and Press on "(.*)"$/ do |btn, table|

  table.rows.each do |file|
    find(:xpath, "//input[@name='ManuscriptFile']").send_keys ENV['DATAPATH'] + file[0] #.gsub('"','').gsub('[','').gsub(']','')
    click_button btn
    step %Q{"Manuscript file can only be submitted in PDF (.pdf) or Word (.doc, .docx) formats." will be displayed}
    end
end
And /^Go to "(.*)"$/ do |journal|
  visit "http://beta.mts.hindawi.com/submit/journals/"
  click_link journal
end

And /^Click the MS ID$/ do
  @ms_id=find("//div[2]//p[1]/a").text
  find("//div[2]//p[1]/a").click
end

And /^Download the pdf file$/ do
  find("//div[1]/a/img").click
end

##############################
########## When ##############
##############################

##############################
########## Then ##############
##############################
Then /^"(.*)" will be displayed$/ do |message|
  expect(first(:xpath, "//*[text()='#{message}']").text).to eq(message)
end

Then /^I verify the appearance of "(.*)" error$/ do |error, table|
  errors = []
  table.rows.each do |email|
    first(:id, 'Authors_AuthorList_0__Email').native.clear
    first(:id, 'Authors_AuthorList_0__Email').send_keys email
    step %Q{Choose a file "test1.docx" for "ManuscriptFile"}
    step %Q{Press on "Submit"}
    begin
      step %Q{"#{error}" will be displayed}
    rescue
      errors << "Failed email is #{email}"
    end
  end
  expect(errors.empty?).to be_truthy
end

Then /^Make sure that all fields are reset$/ do
errors1 =[]
error2 = []
error3 = []
  textfields = page.all(:xpath, "//table[@class='table_border']//input[@type='text']")
  textfields.each do |field|
begin
    expect(field['value'].empty?).to be_truthy
rescue
  errors1 << field['value']
end
end

  selection = page.all(:xpath, "//table[@class='table_border']//select").length
i = 0
  while i < selection
    countries = page.all(:xpath, "//table[@class='table_border']//select[@id='Authors_AuthorList_#{i}__CountryId']/option")
    selected_option = countries.detect {|country| country if country.selected?}
    begin
      expect(selected_option.text).to eq '-- Please Select --'
    rescue
     error2 << selected_option.text
    end
    i += 1
  end

  correspondingauthors = page.all(:xpath, "//table[@class='table_border']//input[@type='radio']")
  correspondingauthors.each do |correspondingauthor|
begin
  expect((correspondingauthor).selected?).to be_falsey
rescue
 error3 << %Q{radio button is selected}
end
  end
error = []
error = errors1 + error2 + error3
expect(error.empty?).to be true
 end
Then /^Click on all links and verify the title of the page$/ do |table|
  error = []
  table.hashes.each do |elem|
    new_window = window_opened_by do
      first(:xpath, "#{elem['linkxpath']}").click
    end
    within_window new_window do
begin
  expect(first(:xpath, "#{elem['pagexpath']}").text).to eq elem['title']
rescue
  error << "The page is #{elem['title']}"
end
      page.execute_script("window.close()")
    end
  end
  expect(error).to eq([])

end

Then /^The following validation messages will be displayed$/ do |table|
  error = []
  table.hashes.each do |msg|
   begin
    expect(page.has_selector?("//li[contains(text(),'#{msg['messages']}')]")).to be_truthy
    rescue
      error << msg['messages']
   end
  end
  puts error
  expect(error).to eq([])
  end
Then /^Red asterisk is displayed beside the mandatory fields$/ do |table|
error1 = []
error2 = []
error3 = []
error4 = []
error5 = []
error6 = []
errors = []
  i = 0
  while i < @authorsnum
    table.rows.each do |field|
      begin
        expect(page.has_selector?("//input[@id='Authors_AuthorList_#{i}__#{field[0]}']//following-sibling::span")).to be_truthy
      rescue
      error1 << field[0]
      end
      end
    begin
        expect(page.has_selector?("//select[@id='Authors_AuthorList_#{i}__CountryId']//following-sibling::span")).to be_truthy
    rescue
      error2 << "Country"
    end
     i += 1
  end
  begin
  expect(page.has_selector?("//form//thead//td[6]//following-sibling::span")).to be_truthy
  rescue
    error3 << "Corresponding Author"
  end
  begin
  expect(page.has_selector?("//input[@id='Manuscript_Title']//following-sibling::span")).to be_truthy
  rescue
    error4 << "Manuscript Title"
  end
  begin
  expect(page.has_selector?("//select[@id='Manuscript_TypeId']//following-sibling::span")).to be_truthy
  rescue
    error5 << "Manuscript Type"
  end
  begin
  expect(page.has_selector?("//form/div[3]/table//tr[3]/td[2]/input//following-sibling::span")).to be_truthy
  rescue
    error6 << "Manuscript File"
  end
errors = error1 + error2 + error3 + error4 + error5 + error6
  expect(errors).to eq([])
end

Then /^The submitting author should be the corresponding author automatic$/ do
  expect(find("//input[@id='AuthorList[0].IsCorresponding']").selected?).to be_truthy
end

Then /^Verify that the file is downloaded$/ do
  path = "#{ENV['DOWNLOAD_DIR']}/#{@ms_id}.v1.docx"
  sleep 5
  File.exist?(path).should be_truthy
  clear_downloads
end


And(/^Select a random Article Type$/) do
  @article = page.find("//*[@id='Manuscript_TypeId']/option[2]").text
  page.find("//*[@id='Manuscript_TypeId']/option[2]").click
end