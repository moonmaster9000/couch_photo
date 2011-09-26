#!/usr/bin/env ruby

puts "running before script..."

cucumber_env = File.read("features/support/env.rb")

File.open("features/support/env.rb", "w") do |f| 
  f.write cucumber_env.gsub('admin:password@', '')
end

puts "before script finished!"
