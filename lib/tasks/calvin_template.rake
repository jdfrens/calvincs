namespace :template do
  def css_files
    ["/includes/templates/global.css", "/includes/templates/9/style.css", "/includes/templates/9/style-print.css"]
  end

  task :css do
    css_files.each do |path|
      sh "wget -O public/stylesheets/#{File.basename(path)} http://www.calvin.edu#{path} "
    end
  end
end
