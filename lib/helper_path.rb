require 'uri'
# Convenience methods for dealing with filepaths
module HelperPath
  # Sanitize a filename so it can be written on disk without any risk.
  # Removes all special chars.
  # Args:
  #   - filepath (String): Original filepath
  # Returns:
  #   - String: Sanitized filepath
  def self.sanitize(filename)
    filename.gsub(%r{[^0-9A-Za-z.\-/]}, '_')
  end

  # Transform a string to camelCase
  # Args:
  #   - string (String): A string in underscore_form
  # Returns:
  #   String: The same string in camelCase form
  def self.camelize(underscore)
    camel = []
    underscore.split('_').each_with_index do |string, index|
      if index == 0
        camel << string
        next
      end
      string[0] = string[0].upcase
      camel << string
    end

    camel.join('')
  end

  # Returns the download path for any given url
  # Args:
  #   - url (String): Input url
  # Returns:
  #   - String: Download filepath
  def self.download(url)
    path = sanitize(URI(url).path)
    path = 'index.html' if path == ''
    path = File.expand_path(File.join('./data/html', path))
    path += '.html' unless File.extname(path) == '.html'
    path
  end

  # Returns the record path for any given HTML file
  # Args:
  #   - object_id (String): Unique object ID representing that record
  # Returns:
  #   - String: JSON record filepath
  def self.record(object_id)
    File.expand_path(File.join('./data/records', "#{sanitize(object_id)}.json"))
  end


end
