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


Given /^login As Author via "(.*)" with "(.*)", "(.*)" and "(.*)"$/  do |url,admin_email, admin_pass, role_email|
  visit url+"/"+admin_email+"/"+admin_pass+"/"+role_email
end


Given /^Set the "(.*)" as "(.*)"$/ do |email,table|
  u_id = 0
  user_id= select_from_dbs("Select UserId From Users where Email ='#{email}'")
  user_id.each do |row|
    u_id = row["UserId"]
  end
      case table
   when "Bad-debt"
     execute_dbs_query("INSERT INTO BadDebts
   VALUES (#{u_id},'CRIS',964625,300,'USD','2018-01-20');")
     puts "Bad-debt is set"
   when "Sanctioned"
     execute_dbs_query("INSERT INTO BlackListedAuthors
        VALUES (#{u_id},'2013-08-20' ,null,'',123456,null);")
     puts "Sanctioned is set"
   end
   end
Given /^Select Journal "(.*)"$/ do |journal|
  page.find(:xpath, "//*[@id='LeftNavBar']/div/ul/li[1]/a").click
  page.find(:xpath, "//a[contains(.,'#{journal}')]").click
  page_title = find(:xpath, '//*[@id="container"]/div[5]/h1').text
  check_for_manuscript_page_title(page_title)
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
  check_for_manuscript_page_title(page_title)

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

And /^Should be found on the Author Activities list with  "(.*)" Status$/ do |status|
  ms_id = find(:xpath, "//*[@id='container']/div[5]/div[2]/div/p[1]/a").text
  click_link 'Author Activities'
  expect(find(:xpath, "//*[@id='container']/div[5]/div/table/tbody/tr[1]/td[1]/span").text.include?(ms_id)).to be_truthy
  expect(find(:xpath,"//*[@id='container']/div[5]/div/table/tbody/tr[1]/td[4]").text).to eql(status)
end


And /^I verify the appearance of questions$/ do |table|
  errors = []
  table.rows.each do |type,questions|
    case type
    when "Research Article"
      step %Q{Choose the Article type "#{type}"}
      all_questions = get_displayed_questions(2)
      if all_questions != questions
        errors << "not matched question for type "#{type}"}
      end
    when "Review Article"
      step %Q{Choose the Article type "#{type}"}
      all_questions = get_displayed_questions(3)
      if all_questions != questions
        errors << "not matched question for type #{type}"
      end
    when "Letter to the Editor"
      step %Q{Choose the Article type "#{type}"}
      all_questions = get_displayed_questions(4)
      if all_questions != questions
        errors << "not matched question for type #{type}"
      end
    when "Clinical Study"
      step %Q{Choose the Article type "#{type}"}
      all_questions = get_displayed_questions(19)
      if all_questions != questions
        errors << "not matched question for type #{type}"
      end
    when "Case Report"
      step %Q{Choose the Article type "#{type}"}
      all_questions = get_displayed_questions(20)
      if all_questions != questions
        errors << "not matched question for type #{type}"
      end
    end
  end
  expect(errors).to eq([])
end

And ("back to Submit a Manuscript page") do

  within(:id, "navigation") do
    click_link 'Submit a Manuscript'

  end
end

And /^Delete "(.*)" From "(.*)" table$/ do |email,table|
  u_id = 0
  user_id= select_from_dbs("Select UserId From Users where Email ='#{email}'")
  user_id.each do |row|
    u_id = row["UserId"]
  end
  case table
  when "Bad-debt"
     execute_dbs_query("DELETE FROM BadDebts
     WHERE UserId='#{u_id}'")
    puts "deleted"
  when "Sanctioned"
    execute_dbs_query("DELETE FROM BlackListedAuthors
     WHERE UserId='#{u_id}'")
    puts "deleted"
  end
end
And(/^Select a random Article Type$/) do
  @article = page.find("//*[@id='Manuscript_TypeId']/option[2]").text
  page.find("//*[@id='Manuscript_TypeId']/option[2]").click
end



And /^Hover on circles$/ do
  page.first(:xpath,"//*[@id='tr_MsTypeSubmissionQuestion_MSType_2']/td/span[1]").hover
  #OR
  #page.driver.browser.action.move_to(page.find(:xpath,"//a[@href='/admin/']").native).perform
end
And /^Choose the Article type "(.*)"$/ do |type|
  @article = type
  select type, from: 'Manuscript_TypeId'
end


And /I verify the appearance of text box to enter your justification$/ do |table|
  errors = []
  table.rows.each do |type,q1,q2, q3|
    case type
    when "Research Article"
      step %Q{Choose the Article type "#{(type)}"}
      if  !(textbox_has_displayed(0,q1))
        errors << "textbox not displayed "
      end
      if  !(textbox_has_displayed(1,q2))
        errors << "textbox not displayed "
      end
      if  !(textbox_has_displayed(2,q3))
        errors << "textbox not displayed "
      end
    when "Review Article"
      step %Q{Choose the Article type "#{type}"}
      if  !(textbox_has_displayed(3,q1))
        errors << "textbox not displayed "
      end
    when "Letter to the Editor"
      step %Q{Choose the Article type "#{type}"}
      if  !(textbox_has_displayed(4,q1))
        errors << "textbox not displayed "
      end
    when "Clinical Study"
      step %Q{Choose the Article type "#{type}"}
      if  !(textbox_has_displayed(5,q1))
        errors << "textbox not displayed "
      end
      if  !(textbox_has_displayed(6,q2))
        errors << "textbox not displayed "
      end
      if  !(textbox_has_displayed(7,q3))
        errors << "textbox not displayed "
      end
    when "Case Report"
      step %Q{Choose the Article type "#{type}"}
      if  !(textbox_has_displayed(8,q1))
        errors << "textbox not displayed "
      end
    end
  end
  expect(errors).to eq([])
end

And ("Open manuscript details page") do
  find(:xpath, "//*[@id='container']/div[5]/div/table/tbody/tr[1]/td[1]/a/img").click
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

Then /^The submitting author "(.*)" should be the displayed with bold style$/ do |email|
  full_name = 0
  user_name= select_from_dbs("Select FullName From Users where Email ='#{email}'")
  user_name.each do |row|
    full_name = row["FullName"]
  end
  expect(find(:xpath, "//*[@id='content']/div/table/tbody//b").text).to eql(full_name)
end


Then /^Information displayed$/ do
  sleep 5
  expect(page.has_selector?("//*[@id='tr_MsTypeSubmissionQuestion_MSType_2']/td/span/span/text()")).to be_truthy
end



################### DEF#######################

def check_for_manuscript_page_title(page_title)
  if (page_title).include?("Select an Issue")
    click_link 'Regular Issues'
  elsif (page_title).include?("Select a Subject Area")
    find(:xpath,'//*[@id="container"]/div[5]/div/div[1]/ul/li[1]/a').click
    if (page_title).include?("Select an Issue")
      click_link 'Regular Issues'
    end
  end


  def get_displayed_questions (ms_type_number)
    all_questions = []
    questions = page.all(:xpath, "//*[@id='tr_MsTypeSubmissionQuestion_MSType_#{ms_type_number}']/td")
    questions.each do |element|
      all_questions << element.text
    end
    return all_questions.join(", ")
  end

  def textbox_has_displayed (index, answer )
    find(:id,"SubmissionQuestionList[#{index}].Answer_#{answer}").click
    if page.has_selector?(:xpath, "//*[@id='SubmissionQuestionList[#{index}].Comment']")
      return true
    else
      return false
    end
  end


end
