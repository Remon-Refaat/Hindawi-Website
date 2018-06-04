require 'selenium-webdriver'
require 'rspec'
# include ::RSpec::Matchers
require 'rspec/expectations'
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara-screenshot/cucumber'



#############################################
########### Environment Variables ###########
#############################################

ENV['PROJECT_DIR'] = Dir.pwd
ENV['DATA_DIR'] = ENV['PROJECT_DIR'] + '/data'
ENV['SCREENSHOTS_DIR'] = ENV['PROJECT_DIR'] + '/screenshots'

#############################################
################ Capybara ###################
#############################################
Capybara.register_driver :chrome do |app|
  path = Dir.pwd
  chrome_path  = path + '/resources/chromedriver.exe'
  caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => [ "--start-maximized" ]})
  Selenium::WebDriver::Chrome::driver_path = chrome_path
  Capybara::Selenium::Driver.new(app, {:browser => :chrome, :desired_capabilities => caps})
end

Capybara.default_driver = :chrome
Capybara.default_selector = :xpath
Capybara.default_max_wait_time = 5
Capybara.save_path = ENV['SCREENSHOTS_DIR']
Capybara::Screenshot.autosave_on_failure = false
Capybara::Screenshot.append_timestamp = false


