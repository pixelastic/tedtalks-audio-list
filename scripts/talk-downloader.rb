# encoding : utf-8
require 'date'
require 'curb'
require 'json'

# We will scrap the TEDTalks API and save on disk on JSON file for each talk.
# Usage :
#  talk-downloader 42 # Will download Talk #42 and save metatalk on disk
#  talk-downloader 1 10 # Will download all talks from #1 to #10 and save
#  metatalk on disk
class TalkDownloader

  def initialize(*args)
    @apikey = "dtdkyg6kdy7jzcb26zvqd3yb"

    if (args.size == 0)
      puts "You must specify the talk id to download"
      return
    end
    if (args.size == 1)
      @id_from = @id_to = args[0].to_i
    end
    if (args.size == 2)
      @id_from = args[0].to_i
      @id_to = args[1].to_i
    end
  end

  def get_talk(id)
    url = "https://api.ted.com/v1/talks/#{id}.json?api-key=#{@apikey}"
    data = JSON.parse(Curl.get(url).body_str)

    return nil unless data
    return data['talk']
  end

  def get_speakers(talk)
    speakers = []
    talk['speakers'].each do |speaker|
      speakers << speaker['speaker']['name']
    end
    return speakers
  end

  def get_tags(talk)
    tags = []
    talk['tags'].each do |tag|
      tags << tag['tag']
    end
    return tags
  end

  def get_podcast_url(talk)
    internal_media = talk['media']['internal']
    return nil unless internal_media['audio-podcast']
    return internal_media['audio-podcast']['uri']
  end

  def get_date(talk)
    return DateTime.parse(talk['recorded_at'])
  end

  def run
    (@id_from..@id_to).each do |id|
      puts "Downloading ##{id}"
      output_file = "../src/talks/#{id}.json"

      talk = get_talk(id)
      unless talk
        puts "Talk ##{id} not found"
        next
      end

      output_talk = {
        :id => talk['id'],
        :name => talk['name'],
        :speakers => get_speakers(talk),
        :description => talk['description'],
        :slug => talk['slug'],
        :date => get_date(talk),
        :event => talk['event']['name'],
        :url => get_podcast_url(talk),
        :tags => get_tags(talk)
      }

      # Writing it to file
      File.open(output_file, "w") do |file|
        file.write(JSON.pretty_generate(output_talk))
      end

      # To avoid hitting the Query Per Second quota, we'll sleep a bit
      sleep(1)
    end

  end

end
TalkDownloader.new(*ARGV).run()

