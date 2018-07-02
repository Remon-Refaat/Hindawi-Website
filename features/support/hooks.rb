After do |scenario|
  take_screenshot(scenario.name) if scenario.failed?
end

def take_screenshot(scenario)
  scenario_name = scenario.gsub /[^\w\-]/, ' '
  time = Time.now.strftime("%Y-%m-%d %H%M")
  screenshot_path = "#{time} - #{scenario_name}.png" #{ENV['SCREENSHOTS_DIR']}/
  page.save_screenshot(screenshot_path)
end

Around do |scenario,block|
  Timeout.timeout(600) do
    block.call
  end
end
