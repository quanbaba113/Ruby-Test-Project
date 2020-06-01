Before do |scenario|
  @scenario_start_time = Time.now
end

After do |scenario|
  if scenario.status == :pending
    if @is_on_responsive_flow == false
      puts "Not on responsive flow"
    end
  end

  if scenario.status == :failed
    if page.has_content?('We are currently offline for maintenance.')
      puts "Environment seems to be down. 'We are currently offline for maintenance' message found."
      scenario.status = :pending
    end
    if page.all('.error_title').length > 0
      puts "System Error"
      scenario.status = :pending
    end
    if page.has_content?("500 Internal Server Error")
      puts "Environment seems to be down. '500 Internal Server Error' message found."
      scenario.status = :pending
    end
  end

  open('output.out', 'a') do |f|
    if scenario.name[/Examples/].nil?
      scenario_name = scenario.name
      example_id = "1"
    else
      scenario_name = scenario.name[/.*Examples/].gsub(", Examples", "")
      example_id = scenario.name[/Examples.*/].gsub("Examples ", "").gsub("(#", "").gsub(")", "")
    end
    scenario_time = Time.now - @scenario_start_time
    my_cell_values = ''
    if scenario.methods.include? :cell_values
      my_cell_values = scenario.cell_values.join("|")
    end
    f.puts [example_id, scenario.feature.name,scenario_name, my_cell_values ,scenario.location.to_s,scenario.status.to_s, scenario_time ].join("\t")
  end
end