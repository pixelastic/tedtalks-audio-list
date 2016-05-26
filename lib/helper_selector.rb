require 'action_view'
# Convenience methods to parse an HTML Nokogiri object and extract relevant data
# for saving the the records
module HelperSelector
  # MUST BE OVERRIDDEN IN CHILD
  # Will return the filename (without filepath) of the record once saved on disk
  # Args:
  #   - data (Hash): Hash version of the data that will be written inside the
  #   file
  # Returns:
  #   - String: Filename of the file to save
  #   - If returns false, the file is not saved
  def filename(_data)
    puts '✗✗✗✗✗✗'
    puts 'You must define the `filename(data)` method of your custom selector'
    puts '✗✗✗✗✗✗'
    fail 'No filename'
  end

  # CAN BE OVERRIDDEN IN CHILD
  # Given the data and original filepath, check if the file should be save on
  # disk or not. Default to always true
  # Args:
  #   - data (Hash): The data hash to save
  #   - file (String): The original filepath
  # Returns:
  #   - Boolean: true if we should save the file, false if not
  def save_record?(_data, _file)
    true
  end

  # Returns the content of a specific attribute of a specific selector
  # Args:
  #   - doc (Nokogiri): The Nokogiri document representation
  #   - selector (String|Element): A CSS selector targeting an element or
  #   directly the element
  #   - attribute (String): The name of the attribute to read
  def attribute(doc, selector_or_element, attribute)
    if selector_or_element.is_a? String
      target_element = element(doc, selector_or_element)
    else
      target_element = selector_or_element
    end

    # No node found, can't find an attribute
    if target_element.respond_to?(:length) && target_element.length == 0
      return nil
    end
    return nil if target_element.nil?

    target_element.attribute(attribute).text
  end

  # Returns the HTML node of a specific selector
  # Args:
  #   - doc (Nokogiri): The Nokogiri document representation
  #   - selector (String): A CSS selector targeting an element
  def element(doc, selector)
    doc.css(selector)
  end

  # Truncates the string after the specified max length
  def truncate(string, length:200)
    ActionView::Base.new.truncate(string, length: length)
  end
end
