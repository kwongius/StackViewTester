#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'
require 'json'
require 'erb'
require 'fastimage'

src_dir = File.expand_path(File.dirname(__FILE__))
images_dir = File.join src_dir, "../Images/"
output_dir = File.join src_dir, "../_comparison/"

base_class_name = 'UIStackView'
class_names = ['OAStackView', 'TZStackView', 'FDStackView']
all_class_names = [base_class_name] + class_names

FileUtils::mkdir_p(output_dir)
if !Pathname.new(images_dir).readable?
  abort("Unable to read images")
end
tests = Pathname.new(images_dir).children.flat_map {|p| p.children.select { |e| e.directory? && e.basename.to_s.start_with?("test") } }

def get_data(path, class_name)
    path = path.join("#{class_name}_results")
    return path.open { |f| JSON.parse(f.read) } if path.readable?
    return {"success" => false}
end

class TestResult
    attr_accessor :name
    attr_accessor :images
    attr_accessor :relative_images
    attr_accessor :results
end

results = tests.map { |test|
    res = TestResult.new()
    res.name = test.basename.to_s
    res.images = all_class_names.map { |e| test.join("#{test.basename.to_s}_#{e}.png") }
    res.relative_images = res.images.map { |e| e.relative_path_from(Pathname.new(output_dir)) }
    res.results = all_class_names.map { |class_name| get_data(test, class_name) }
    res
}

html = ERB.new(Pathname.new(src_dir).join("templates/comparison.html.erb").read).result(binding)
File.write(Pathname.new(output_dir).join("stackViewComparison.html"), html)
puts "Exported!"
puts "View the file at: #{File.expand_path(output_dir)}"
