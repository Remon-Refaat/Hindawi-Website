require 'tiny_tds'
def connect_to_dbs
  @client = TinyTds::Client.new username: 'abeer.fathy', password: 'r&f3Wlq5No',
                                host: 'ec2-52-0-207-90.compute-1.amazonaws.com', port: 32000,
                                database: 'mtsv2', azure:false
end

def select_from_dbs(query)
  connect_to_dbs
  @client.execute(query)
end

def execute_dbs_query(query)
  connect_to_dbs
  @client.execute(query).do
end



# client = TinyTds::Client.new username: 'abeer.fathy', password: 'r&f3Wlq5No',
#                               host: 'ec2-52-0-207-90.compute-1.amazonaws.com', port: 32000,
#                               database: 'mtsv2', azure:false





# results = client.execute("SELECT top 10 * FROM Users")
# puts results.fields
# results.each do |row|
  # puts "#{row["Email"]}, #{row["FirstName"]}"
  # puts row.select {|hash| hash.include? hash["UserId"] == '10102429'}
 # end

# s_result = client.execute("select * from SubmissionsSendMail WHERE ManuscriptId=6094614")
# puts s_result.first

# client.execute("UPDATE SubmissionsSendMail SET EQSReleaseDate = '2018-06-25' where ManuscriptId=6094614").do


# result = client.execute("select * from UserDomains where ManuscriptId=6094614")
# # puts result.first
# x = result.first
# puts x
# result.each do |row|
#   puts row
# end
# d_query = client.execute("DELETE FROM UserDomains where manuscriptid = 6094614")
# d_query.do
# # puts result
# q = client.execute("INSERT INTO UserDomains (UserId, DomainName, CreateDate, AddedBy, manuscriptid, Affiliation)
# VALUES (95782108, 'ucalgary.ca', 2018-60-13, ' ', 6094614, ' ')")
# q.insert
# # puts result




