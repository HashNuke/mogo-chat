require 'sprockets'
require 'rake/sprocketstask'
require 'bourbon'
require 'filewatcher'

sprockets = Sprockets::Environment.new("./") do |env|
  env.logger = Logger.new(STDOUT)
  env.append_path 'assets/javascripts'
  env.append_path 'assets/stylesheets'
  env.append_path 'assets/images'
end

assets = %w( application.js application.css )
asset_output = "priv/static/assets"
extra_dirs = ["images", "partials"]

extra_dirs.each do |dir|
  Dir.glob("assets/#{dir}/*.*") do |f|
    assets.push File.basename(f)
  end
end


namespace :assets do

  desc "Compile assets"
  task :compile do
    begin
      assets.each do |asset|
        debugger if sprockets[asset].nil?
        sprockets[asset].write_to "#{asset_output}/#{asset}"
      end
    rescue => e
      puts "Error #{e.inspect}"
    end
  end


  desc "Watch assets for changes and compile"
  task :watch do
    watch_list = ["assets/javascripts/", "assets/stylesheets/", "assets/images/"]

    FileWatcher.new(watch_list, "Watching assets for compliation...").watch do |filename|

      begin
        assets.each do |asset|
          puts asset
          sprockets[asset].write_to "#{asset_output}/#{asset}"
        end
      rescue => e
        puts "Error #{e.inspect}"
      end

    end
  end

end
