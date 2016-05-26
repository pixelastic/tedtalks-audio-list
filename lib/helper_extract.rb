require 'parallel'
require 'nokogiri'
require 'json'
require 'fileutils'
require_relative './helper_path'
# Convenience methods for extracting relevant data from a given HTML file.
# The very specific logic of what is relevant is left to the main extract script
class HelperExtract
  def initialize(selector)
    @selector = selector
    @selector_methods = get_selector_methods(@selector)
  end

  # Returns the list of `record_` methods from the given selector, along with
  # the field where to save them. We do it here once and for all to avoid
  # useless loops later.
  def get_selector_methods(selector)
    data = {}

    # We only keep the methods that start with `record_`
    selector.methods.each do |method|
      method_name = method.to_s
      next unless method_name =~ /^record_/
      object_key = method_name.gsub(/^record_/, '')
      # objectID is a special key in Algolia, so we need to make sure it is
      # correctly uppercased
      object_key = 'object_ID' if object_key == 'object_id'

      data[method] = HelperPath.camelize(object_key)
    end

    data
  end

  # Given a list of HTML files, will save all the matching extracted records on
  # disk as JSON
  def extract(files)
    Parallel.each(files) do |file|
      puts "✔ Extracting #{file}"
      extract_file(file)
    end
  end

  # Given one specific file, will create its JSON extracted version on disk
  # It will call every `record_` method defined in the selector on the HTML
  # rendering of the page
  def extract_file(file)
    html = File.open(file).read
    doc = Nokogiri::HTML(html)
    data = {}

    # Apply only `record_` methods to the doc to get the data
    @selector_methods.each do |method_name, object_key|
      value = @selector.send(method_name, doc)
      data[object_key] = value
    end

    # Check that the data seem legit
    unless @selector.save_record?(data, file)
      # Data is bad, we delete the previous json if we had one
      puts "✘ Incomplete data for #{file}"
      filename = @selector.filename(data)
      delete_json(filename) if filename != false
      return
    end

    # Save it to disk
    filename = @selector.filename(data)
    save_as_json(data, filename)
  end

  # Saves the specified data to disk, with the specified filename
  # Will store it in an easily readable JSON format, with ordered keys, to make
  # diff of files easier to read
  # Args:
  #   - data (Hash): Hash of data to save
  #   - filename (String): Filename to save the file
  def save_as_json(data, filename)
    # Where to save the content
    output = HelperPath.record(filename)
    FileUtils.mkdir_p(File.dirname(output))

    # Pretty-print and sort keys before saving
    content = JSON.pretty_generate(data.sort.to_h)
    # puts content
    File.write(output, content)
  end

  # Deletes the specified file. Used to cleanup the record list if a file
  # suddenly becomes blacklisted
  def delete_json(filename)
    filename = HelperPath.record(filename)
    return unless File.exist?(filename)
    FileUtils.rm(filename)
  end

  # Returns a list of all the records saved on disk
  # Returns:
  #   - Array: List of all records
  def self.all_records
    Dir[File.expand_path('./data/records/**/*.json')].sort.map do |file|
      JSON.parse(File.open(file).read)
    end
  end
end
