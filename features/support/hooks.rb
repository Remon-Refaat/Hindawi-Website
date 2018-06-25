After do |scenario|
  take_screenshot(scenario.name) if scenario.failed?
end

def take_screenshot(scenario)
  scenario_name = scenario.gsub /[^\w\-]/, ' '
  time = Time.now.strftime("%Y-%m-%d %H%M")
  screenshot_path = "#{time} - #{scenario_name}.png" #{ENV['SCREENSHOTS_DIR']}/
  page.save_screenshot(screenshot_path)
end

Before do
 # page.driver.browser.manage.window.maximize
  step %Q{Login to "http://beta.mts.hindawi.com/login/"}
  step %Q{Sign in using the email address "remon.refaat@hindawi.com" and the password "123456"}
  step %{Press on "Sign In"}
end

After do |scenario|
STDOUT.puts "I completed #{scenario.name} scenario"
end

After('@remon','not @emad') do |scenario|
  STDOUT.puts %Q{Plesae write the #{scenario.name} scenario}
end

Around do |scenario,block|
  Timeout.timeout(600) do
    block.call
  end
end
