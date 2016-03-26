# 2016, Johannes Fahrenkrug, springenwerk.com

require 'json'

languages = []

File.foreach('xcode-languages.txt') do |line, line_num|
  /^(?<name>.*)\ \((?<symbol>.*)\)$/ =~ line
  languages.push({:name => name, :symbol => symbol})
end

File.open("xcode-languages.json", "w") do |f|
  f.write(JSON.pretty_generate(languages))
end
