##################GIVEN##########################
Given /^login As admin  with "(.*)" and "(.*)"$/ do |email, pass|
  fill_in 'identifierId', :with => email
  page.find(:id, 'identifierNext').click
  sleep 2
  fill_in 'password', :with => pass
  find(:xpath, '//*[@id="passwordNext"]/content/span').click
  sleep 3
end
Given /^Open "(.*)" Page$/ do |page_name|
  unless page.has_selector?(:xpath,"//h1[contains(text(),'#{page_name}')]")
    step %Q{Navigate to "http://beta.admin.mms.hindawi.com/auth/dalia.elrawy@hindawi.com"}
    step %Q{Click on "Coordinator Activities" link from container section}
    step %Q{Click on "#{page_name}" link from container section}
  end
  if(page_name == 'Domain Messages')
    @row_count = page.all(:xpath, "//*[@id='MtsTable']/tbody/tr").count
    @col_count = page.all(:xpath, "//*[@id='MtsTable']/thead/tr/th").count
    @rand_index = (rand(@row_count-1))+1
  end
end
# ###############AND#############################
And /^Click on "(.*)" link from container section$/ do |link|
  within(:xpath, '//*[@id="container"]/div[9]') do
    click_link link
  end
end
And /^Click on "(.*)" link$/ do |link|
  click_link link
end
And /^Click on "(.*)" link for any Institution$/ do |link|
  @domain_Name = find(:xpath, "//*[@id='MtsTable']/tbody/tr[#{@rand_index}]/td[3]").text
  @domain_email = find(:xpath, "//*[@id='MtsTable']/tbody/tr[#{@rand_index}]/td[2]").text
  find(:xpath, "//*[@id='MtsTable']/tbody/tr[#{@rand_index}]/td[4]").click
end
And ("Get the Domain Message on Update account from DB")do
  id = select_from_dbs("SELECT DISTINCT  DomainsMembership.ConsortiumDomainsMembershipID FROM dbo.ConsortiumDomainsMembership LEFT OUTER JOIN dbo.DomainsMembership
ON DomainsMembership.ConsortiumDomainsMembershipID = ConsortiumDomainsMembership.ConsortiumDomainsMembershipID
Where ConsortiumDomainsMembershipName ='#{@domain_Name}'")
  id.each do |row|
    @inst_id = row["ConsortiumDomainsMembershipID"]
  end
message = select_from_dbs("SELECT Top 1 Message FROM dbo.DomainsMembershipMessages where ConsortiumDomainsMembershipID =#{@inst_id}  ORDER BY LastUpdateDate DESC")
  message.each do |row|
    @domain_message = row["Message"].to_s
  end
end
And /^"(.*)" domain message$/ do |update_by|
  case update_by
  when "add new"
    @update_message = "<p>Queen's University Belfast is a member of Hindawi's Institutional Membership program. APCs for accepted manuscripts with funding from RCUK or COAF will be paid by your institution.</p>
<p>Please contact <a href='mailto:openaccess@qub.ac.uk'>openaccess@qub.ac.uk</a> or visit <a href='http://libguides.qub.ac.uk/openaccess'>http://libguides.qub.ac.uk/openaccess</a> for more details.</p>"
    find(:id, "Message").native.clear
    fill_in 'Message', :with => @update_message
    find(:xpath, "//input[@type='submit'][@name='SubmitButton']").click
     when "update"
    fill_in('Message', with: 'text to append', fill_options: {clear: :none})
    find(:xpath, "//input[@type='submit'][@name='SubmitButton']").click
    find(:xpath, "//td[contains(text(),'#{@domain_email}')]/following-sibling::td[2]").click
    @update_message = find(:id, "Message").text
  when "delete"
    find(:id, "Message").native.clear
    find(:xpath, "//input[@type='submit'][@name='SubmitButton']").click
    find(:xpath,"//td[contains(text(),'#{@domain_email}')]/following-sibling::td[2]").click
    @update_message = find(:id, "Message").text
  end
end
And("Go to MMS site")do
  step %Q{Navigate to "http://beta.mms.hindawi.com/doaa.asl@hindawi.com/123456/#{@domain_email}"}
end
And("Open update account page")do
  find(:xpath, "//a[text()='Update Account']").click
end
And ("back to MMS admin site") do
  step %Q{Navigate to "http://beta.admin.mms.hindawi.com/auth/dalia.elrawy@hindawi.com"}
end
And("Select random institution")do
  @domain_email = find(:xpath, "//*[@id='MtsTable']/tbody/tr[#{@rand_index}]/td[2]").text
end
And /^"(.*)" message which displayed on update account page$/ do |update_by|
  case update_by
  when "add new"
    @domain_message = "<p>Queen's University Belfast is a member of Hindawi's Institutional Membership program. APCs for accepted manuscripts with funding from RCUK or COAF will be paid by your institution.</p>
<p>Please contact <a href='mailto:openaccess@qub.ac.uk'>openaccess@qub.ac.uk</a> or visit <a href='http://libguides.qub.ac.uk/openaccess'>http://libguides.qub.ac.uk/openaccess</a> for more details.</p>"
    find(:id, "UpdatedMessageBody").native.clear
    fill_in 'UpdatedMessageBody', :with => @domain_message
    find(:xpath, "//input[@type='submit'][@value='Save']").click
  when "update"
    fill_in('UpdatedMessageBody', with: 'text to append', fill_options: {clear: :none})
    find(:xpath, "//input[@type='submit'][@value='Save']").click
    sleep 2
    @domain_message = find(:id, "UpdatedMessageBody").text
  when "delete"
    find(:id, "UpdatedMessageBody").native.clear
    find(:xpath, "//input[@type='submit'][@value='Save']").click
    sleep 2
    @domain_message = find(:id, "UpdatedMessageBody").text
  end
end
And("Open the Edit message page")do
  find(:xpath, "//td[contains(text(),'#{@domain_email}')]/following-sibling::td[2]").click
end
And /^Click on "(.*)" button$/ do |button|
  find(:xpath, "//input[@type='submit'][@value='#{button}']").click
end
##################THEN###########################
Then /^The "(.*)" page should be opened$/ do |title|
    expect(page).to have_title title
   end
Then ("The Institutions table should be displayed") do
  expect(page.has_selector?(:id, "MtsTable")).to be_truthy
end
Then /^"(.*)" should be as table headers$/ do |table_header|
  table_headres = []
  list = page.all(:xpath,"//*[@id='MtsTable']//th")
  list.each do |element|
    table_headres << element.text
      end
  expect(table_headres.join(", ")).to eql(table_header)
end
Then("The table should be sortable and ordered by serial.") do
  list_of_ser = []
  ser = page.all(:xpath, "//table[@id='MtsTable']//td[1]")
  ser.each do |element|
    list_of_ser << (element.text).to_i
  end
  expect(list_of_ser == list_of_ser.sort).to be_truthy
 end
Then /^The system should be redirect to "(.*)" Page$/ do |page_name|
  expect(page.has_selector?(:xpath, "//h1[contains(text(),'#{page_name}')]")).to be_truthy
end
Then ("The system should re-order the table right") do
  expect(@is_Sorted).to be_truthy
end
Then ("The system should redirects to home page") do
  expect(page.has_selector?(:xpath, "//a[contains(normalize-space(text()),'Institution Membership Coordinator')]")).to be_truthy
end
Then ("The domain name on edit domain message page should be same as domain name on institutions table") do
d_name= find(:xpath, "//*[@id='form0']/table/tbody/tr[1]/td[2]").text
  expect(d_name).to eq(@domain_Name)
end
Then ("The two messages should be the same") do
    expect(page.find(:id, "Message" ).text.to_s.gsub("\n","")).to eq(@domain_message.gsub("\r","").gsub("\n",""))
end
Then ("The domain message should be updated")do
   message = find(:id, "UpdatedMessageBody").text
   expect(message.to_s.gsub("\n","").gsub("\r","")).to eq(@update_message.gsub("\r","").gsub("\n",""))
end
Then ("The number of institutions should be displayed above the table") do
  expect(page.has_selector?(:xpath, "//div[contains(normalize-space(text()),'[#{@row_count}]')]")).to be_truthy
end
Then /"(.*)" field should be displayed$/ do |field_name|
  expect(page.has_selector?(:xpath, "//td[contains(text(),'#{field_name}')]")).to be_truthy
end
Then ("Message text box should be displayed") do
  expect(page.has_selector?(:id, "Message")).to be_truthy
end
Then /^"(.*)" button should be displayed$/ do |button_name|
  expect(page.has_selector?(:xpath, "//input[@type='submit'][@value='#{button_name}']")).to be_truthy
end
Then /^The "(.*)" should be displayed with the right URL$/ do |page_name|
  case page_name
  when "Domain Messages"
    expect(page.current_url).to eq("http://beta.admin.mms.hindawi.com/institution.membership.coordinator/domain.messages/")
    puts page.current_url
  when "Edit Domain Message"
    expect(page.current_url.include? "http://beta.admin.mms.hindawi.com/institution.membership.coordinator/domain.messages/edit").to be_truthy
    puts page.current_url
  end
end
Then /^The "(.*)" link should be displayed$/ do |link_name|
  expect(page.has_selector?(:xpath, "//a[contains(normalize-space(text()),'#{link_name}')]")).to be_truthy
end
##############################WHEN#######################################
When /^Click on arrow which displayed beside table headers for each column$/ do |table|
  errors = []
  @is_Sorted = nil
  column_data_befor_click_on_arrow = []
  column_data_after_click_on_arrow = []
  table.hashes.each do |row|
    case row['Order By']
    when  "ASC"
      i=1
      while (i<=@col_count) do
        column_data_befor_click_on_arrow = get_column_data("//*[@id='MtsTable']/thead/tr/th[#{i}]","//*[@id='MtsTable']/tbody/tr/td[#{i}]")
        page.find(:xpath,"//*[@id='MtsTable']/thead/tr/th[#{i}]").click # Click on Arrow
        column_data_after_click_on_arrow = get_column_data("//*[@id='MtsTable']/thead/tr/th[#{i}]","//*[@id='MtsTable']/tbody/tr/td[#{i}]")
        if (column_data_befor_click_on_arrow.sort != column_data_after_click_on_arrow)
          puts column_data_befor_click_on_arrow
          puts column_data_after_click_on_arrow
          errors << "Not sorted"
        end
        i= i+1
        column_data_befor_click_on_arrow.clear
        column_data_after_click_on_arrow.clear
      end
    when "DES"
      i=1
      while (i<=@col_count) do
        column_data_befor_click_on_arrow = get_column_data("//*[@id='MtsTable']/thead/tr/th[#{i}]","//*[@id='MtsTable']/tbody/tr/td[#{i}]")
        page.find(:xpath,"//*[@id='MtsTable']/thead/tr/th[#{i}]").click # Click on Arrow
        sleep 2
        column_data_after_click_on_arrow = get_column_data("//*[@id='MtsTable']/thead/tr/th[#{i}]","//*[@id='MtsTable']/tbody/tr/td[#{i}]")
        if ((column_data_befor_click_on_arrow.sort).reverse != column_data_after_click_on_arrow)
          puts column_data_befor_click_on_arrow.reverse
          puts column_data_after_click_on_arrow
          errors << "Not sorted"
        end
        i= i+1
        column_data_befor_click_on_arrow.clear
        column_data_after_click_on_arrow.clear
      end
    end
    if (errors.any?)
      puts errors
      @is_Sorted = false
    else
      @is_Sorted = true
    end
  end
end
######################## DEF###########################################################
def get_column_data(header_xpath, column_xpath)
    temp =[]
  header = page.find(:xpath,header_xpath).text
  column_data = page.all(:xpath, column_xpath)
  if(header == 'Ser')
    column_data.each do |element|
      temp << element.text.to_i
    end
  else
    column_data.each do |element|
      temp << element.text.downcase
    end
  end
  return temp
end

