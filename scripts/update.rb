#!/usr/bin/env ruby
# encoding : utf-8
require 'open-uri'
require 'nokogiri'

# Will read the official Audio TEDTalks RSS, and dowloading any metadata for
# talks we do not yet have
class TalkUpdater

  def initialize(*args)
    @rss_url = "http://feeds.feedburner.com/TEDTalks_audio"
  end

  def get_new_talks
    puts "Reading new talks from RSS"
    doc = Nokogiri::XML(open(@rss_url, 'r').read)

    talks = []
    for node in doc.root.xpath('//item')
      talks << node.xpath('jwplayer:talkId').text.to_i
    end
    talks.sort!
    
    return talks
  end

  def get_existing_talks
    talks = []
    Dir['../src/talks/*.json'].each do |file|
      talks << File.basename(file, File.extname(file)).to_i
    end
    talks.sort!
    return talks
  end

  def run
    new_talks = get_new_talks
    existing_talks = get_existing_talks

    # Keeping new talks not already downloaded
    talks = []
    new_talks.each do |new_talk_id|
      next if existing_talks.include?(new_talk_id)
      talks << new_talk_id
    end

    if talks.length ==  0
      puts "No new talks to download"
      return
    end

    talks.each do |talk_id|
      puts "Downloading ##{talk_id}"
      %x[./talk-downloader #{talk_id}]
    end
    
  end


end
TalkUpdater.new().run()

