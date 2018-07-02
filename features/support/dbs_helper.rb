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
