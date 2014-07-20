# encoding : utf-8
require 'json'
require 'csv'

class TEDTalksCSVToJSON

  def initialize

  end

  def run
    data = Hash.new
    CSV.foreach("../list.csv") do |line|
      id = line[1]
      data[id] = {
        :id => id,
        :url => line[2],
        :speaker => line[3],
        :name => line[4],
        :summary => line[5],
        :event => line[6],
        :duration => line[7]
      }
    end
    puts JSON.pretty_generate(data)
    
  end

end
TEDTalksCSVToJSON.new(*ARGV).run()
