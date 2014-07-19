# encoding : utf-8
require 'open-uri'
require 'nokogiri'

class TEDTalksDownloader

  def initialize
    @list_url = 'http://feeds.feedburner.com/TEDTalks_audio'

  end

  def get_xml_list
    open(@list_url, 'r').read
  end


  def run
    doc = Nokogiri::XML(open(@list_url, 'r').read)
    for node in doc.root.xpath("//item")
      p node.xpath('./itunes:subtitle').text
    end

    # p get_xml_list

  end

  # def pre_run
  # end

  # def node_to_hash(node)
  #     title = node.xpath('./itunes:subtitle').text
  #     index = node.xpath('jwplayer:talkId').text
  #     url = node.xpath('./enclosure').attr('url').text
  #     date = DateTime.parse(node.xpath('./pubDate').text)

  #     return {
  #       'index' => index,
  #       'title' => title,
  #       'url' => url,
  #       'date' => date,
  #     }
  # end
end
TEDTalksDownloader.new(*ARGV).run()


