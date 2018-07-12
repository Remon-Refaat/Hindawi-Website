require 'selenium-webdriver'
require 'rspec'
include ::RSpec::Matchers
require 'rspec/expectations'
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara-screenshot/cucumber'
require 'tiny_tds'
require 'pdf-reader'
PDF::Reader::MalformedPDFError

ENV['PROJECT_DIR'] = Dir.pwd
ENV['DATA_DIR'] = ENV['PROJECT_DIR'] + '/data'
ENV['SCREENSHOTS_DIR'] = ENV['PROJECT_DIR'] + '/screenshots'


Capybara.register_driver :chrome do |app|
  path = Dir.pwd
  chrome_path  = path + '/resources/chromedriver.exe'
  caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => [ "--start-maximized" ]})
  Selenium::WebDriver::Chrome::driver_path = chrome_path
  pref = {
      downloads: {
          prompt_for_download: false,
          default_directory: ENV['DOWNLOAD_DIR']
      }
  }
  Capybara::Selenium::Driver.new(app, {:browser => :chrome, :desired_capabilities => caps, :prefs => pref})
end

Capybara::default_driver = :chrome
Capybara.default_selector = :xpath
Capybara.default_max_wait_time = 2
Capybara.save_path = ENV['SCREENSHOTS_DIR']
Capybara::Screenshot.autosave_on_failure = false
Capybara::Screenshot.append_timestamp = false
Capybara::Node::Element
ENV['DOWNLOAD_DIR'] = Dir.pwd + '/downloads'