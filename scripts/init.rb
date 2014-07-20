# encoding : utf-8
require 'json'
require 'csv'

class TEDTalksCSVToJSON

  def initialize

  end

  def run
    data = Hash.new
    CSV.foreach("../src/audio-list.csv") do |line|
      id = line[0]
      data[id] = {
        :id => id,
        :speaker => line[1],
        :name => line[2],
        :url => line[3]
      }
    end
    puts JSON.pretty_generate(data)
    
  end

end
TEDTalksCSVToJSON.new(*ARGV).run()
