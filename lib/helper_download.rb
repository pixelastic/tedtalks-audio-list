require 'parallel'
require 'fileutils'
require_relative './helper_path'

# Will download distant files and save them on disk
module HelperDownload
  # Download to disk all the urls passed
  # Args:
  #   - urls (Array): Array of urls
  # Returns:
  #   - true if everything is downloaded correctly
  def self.download(urls)
    Parallel.each(urls) do |url|
      if already_downloaded?(url)
        puts "✘ Already downloaded #{url}"
        next
      end
      puts "✔ Downloading #{url}"
      download_file(url)
    end
  end

  # Check if the specified url is already downloaded
  # Args:
  #   - url (String): The target url
  # Returns:
  #   - Boolean: True if file is already available on disk, False otherwise
  def self.already_downloaded?(url)
    File.exist?(HelperPath.download(url))
  end

  # Downloads the specified url to disk, keeping the same hierarchy structure
  # Args:
  #   - url (String): The target url
  def self.download_file(url)
    output = HelperPath.download(url)

    FileUtils.mkdir_p(File.dirname(output))
    `wget "#{url}" --random-wait -O #{output} 2>/dev/null`
  end

  # Returns the list of all downloaded html pages
  # Returns:
  #   - Array: List of all filepaths to downloaded pages
  def self.all_files
    Dir[File.expand_path('./data/html/**/*.html')].sort
  end
end
