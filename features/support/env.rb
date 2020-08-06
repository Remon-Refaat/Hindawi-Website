require 'selenium-webdriver'
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara/rspec'
require 'rspec'
require 'faker'
require 'capybara-screenshot/cucumber'
require 'wannabe_bool'
require 'byebug'
include RSpec::Matchers

#############################################
################ Capybara ###################
#############################################
# path = Dir.pwd + '/resources/chromedriver.exe'
# Selenium::WebDriver::Chrome.driver_path = path
# Capybara.default_driver = :selenium_chrome
Capybara.register_driver :chrome do |app|
  path = Dir.pwd
  chrome_path  = path + '/resources/chromedriver.exe'
  caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => [ "--start-maximized" ]})
  Selenium::WebDriver::Chrome::driver_path = chrome_path
  pref = {
      download: {
          prompt_for_download: false,
          default_directory: ENV['DOWNLOAD_DIR']
      }
  }
  Capybara::Selenium::Driver.new(app, {:browser => :chrome, :desired_capabilities => caps, :prefs => pref})
end

Capybara::default_driver = :chrome



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


