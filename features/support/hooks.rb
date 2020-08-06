# Before('@first') do |senario|
#   unless $setup_is_done
#     puts "Firs Run ..."
#     step %Q{I pause}
#     step %Q{Navigate to "http://beta.mts.hindawi.com/remon.refaat@hindawi.com/123456"}
#     $setup_is_done = true
#   end
# end
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
