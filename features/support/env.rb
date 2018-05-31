require 'selenium-webdriver'
require 'rspec'
# include ::RSpec::Matchers
require 'rspec/expectations'
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'



Capybara.register_driver :chrome do |app|
  path = Dir.pwd
  chrome_path  = path + '/resources/chromedriver.exe'
  caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => [ "--start-maximized" ]})
  Selenium::WebDriver::Chrome::driver_path = chrome_path
  Capybara::Selenium::Driver.new(app, {:browser => :chrome, :desired_capabilities => caps})
end

Capybara::default_driver = :chrome

ENV['DATA_DIR'] = Dir.pwd + '/data'

#
# path = Dir.pwd
# chrome_path  = path + '/resources/chromedriver.exe'
# Selenium::WebDriver::Chrome::driver_path = chrome_path
# driver = Selenium::WebDriver.for :chrome