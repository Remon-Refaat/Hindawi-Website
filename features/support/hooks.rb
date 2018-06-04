## Before and after each scenario
# Before do |scenario|
#   STDOUT.puts %Q{I am testing "#{scenario.name}" scenario}
# end
#
# After do |scenario|
#   STDOUT.puts %Q{I completed "#{scenario.name}" scenario}
# end
#
# Around do |scenario, block|
#   Timeout.timeout(600) do
#     block.call
#   end
# end

## After each step
# AfterStep do |step|
#   STDOUT.puts %Q{I completed this step}
# end


## Tags
# Before('@first') do |senario|
#   STDOUT.puts %Q{My first tag is here}
# end
#
# Before('@second') do |senario|
#   unless $setup_is_done
#     STDOUT.puts %Q{My second tag is here}
#     $setup_is_done = true
#   end
# end











After do |scenario|
  take_screenshot(scenario.name) if scenario.failed?
end

def take_screenshot(scenario)
  scenario_name = scenario.gsub /[^\w\-]/, ' '
  time = Time.now.strftime("%Y-%m-%d %H%M")
  screenshot_path = "#{ENV['SCREENSHOTS_DIR']}/#{time} - #{scenario_name}.png"
  page.save_screenshot(screenshot_path)
end