require 'selenium-webdriver'
# require 'capybara'
# require 'capybara/dsl'
require 'capybara/cucumber'
# require 'capybara/rspec'
require 'rspec'
require 'faker'
require 'capybara-screenshot/cucumber'
require 'wannabe_bool'
include RSpec::Matchers
RSpec::Expectations::ExpectationNotMetError

#############################################
################ Capybara ###################
#############################################
path = Dir.pwd + '/resources/chromedriver.exe'
Selenium::WebDriver::Chrome.driver_path = path
Capybara.default_driver = :selenium_chrome
Capybara.page.driver.browser.manage.window.maximize



#############################################
########### Environment Variables ###########
#############################################
ENV['PROJECT_DIR'] = Dir.pwd
ENV['DATAPATH'] = ENV['PROJECT_DIR'] + '/data/'
ENV['SCREENSHOTS_DIR'] = ENV['PROJECT_DIR'] + '/screenshots'
ENV['Download_Dir'] = ENV['PROJECT_DIR'] + '/downloads'

#############################################
########### Configuration ###################
#############################################
Capybara.default_selector = :xpath
Capybara.default_max_wait_time = 0.5
Capybara.save_path = ENV['SCREENSHOTS_DIR']

Capybara::Screenshot.autosave_on_failure = false
Capybara::Screenshot.append_timestamp = false


