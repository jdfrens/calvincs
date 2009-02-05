desc "Tasks for CruiseControl.rb to run"
task :cruise => [:spec, :features]
