require "yifysubs/subtitle_result"

class Yifysubs::SubtitleResultSet
  attr_reader :instances

  def initialize(attributes)
    @instances = attributes[:instances]
  end

  def self.build(html)
    instances = html.css(".fav-subs tbody > tr").collect do |item|
      Yifysubs::SubtitleResult.build(item)
    end
    if instances.nil? || instances.size==0
      instances = html.css("tbody > tr").collect do |item|
        Yifysubs::SubtitleResult.build(item)
      end
    end

    new({
      instances: instances
    })
  end
end
