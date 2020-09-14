require "faraday"
require "nokogiri"

require "yifysubs/version"
require "yifysubs/error"
require "yifysubs/response"
require "yifysubs/response/raise_error"
require "yifysubs/response/html"
require "yifysubs/subtitle_result_set"
require "yifysubs/subtitle"

module Yifysubs

  # Yifysubs.com is a very complete and reliable catalog of subtitles.
  # If you're reading this you probably know they don't have an API.
  #
  # This gem will help you communicate with Yifysubs.com easily.
  #
  # == Searches
  #
  # Yifysubs.com handles two kinds of searches:
  #
  #   a) Search by Film or TV Show 'title'
  #   e.g. "The Big Bang Theory", "The Hobbit", etc.
  #
  #   b) Search for a particular 'release'
  #   e.g. "The Big Bang Theory s01e01" or "The Hobbit HDTV"
  #
  # There are certain keywords that trigger one search or the other,
  # this gem initially will support the second type (by release)
  # so make sure to format your queries properly.
  #
  extend self

  #ENDPOINT     = "https://www.yifysubtitles.com"
  ENDPOINT     = "https://yifysubtitles.org"
  #ENDPOINT     = "https://yts-subs.com"
  
  RELEASE_PATH = "subtitles/release"
  IMDB_PATH = "movie-imdb"

  # Public: Search for a particular release.
  #
  # query - The String to be found.
  #
  # Examples
  #
  #   Yifysubs.search('The Big Bang Theory s01e01')
  #   # => [#<Yifysubs::SubtitleResult:0x007feb7c9473b0
  #     @attributes={:id=>"136037", :name=>"The.Big.Bang.Theory.."]
  #
  # Returns the Subtitles found.
  def self.search(query=nil)
    params = { q: query, l: '', r: true } unless query.nil?
    params ||= {}

    response = connection.get do |req|
      req.url RELEASE_PATH, params
      req.headers['Cookie'] = "LanguageFilter=#{@lang_id};" if @lang_id
    end

    html = response.body
    Yifysubs::SubtitleResultSet.build(html).instances
  end
  def self.endpoint_url
    ENDPOINT
  end

  
  
  def self.find_imdb(imdbid)
     params ||= {}
     requrl = IMDB_PATH+"/"+imdbid
      response = connection.get do |req|
        req.url requrl, params
        req.headers['Cookie'] = "ys-lang=#{@lang_id};" if @lang_id
      end

      html = response.body
      Rails.logger.debug("find_imdb requrl:"+requrl)
      Yifysubs::SubtitleResultSet.build(html).instances
    end

  

  # Public: Set the language id for the search filter.
  #
  # lang_id - The id of the language. Maximum 3, comma separated.
  #           Ids can be found at http://subscene.com/filter
  #
  # Examples
  #
  #   Yifysubs.language = 13 # English
  #   Yifysubs.search("...") # Results will be only English subtitles
  #   Yifysubs.language = "13,38" # English, Spanish
  #   ...
  #
  def language=(lang_id)
    @lang_id = lang_id
  end
  def language_name=(lang_name)
    if lang_name.match(",")
      lang_array=lang_name.split(",")
      ret=[]
      lang_array.each do |l|
        ret<<languages_ids(l) unless languages_ids(l).nil?
      end
      @lang_id=ret.join("-")
    else
      @lang_id = languages_ids(lang_name)    
    end
  end
  def self.lang_id
    @lang_id
  end
  
  def self.languages_ids(name)
     langs = { "Albanian" => 2, "Arabic" => 21, "Bengali" => 35, "Brazilian Portuguese" => 3, "Bulgarian" => 36, "Chinese" => 30, "Croatian" => 23, "Czech" => 32, "Danish" => 4, "Dutch" => 5, "Farsi/Persian" => 6, "Finnish" => 7, "Greek" => 9, "Hebrew" => 25, "Hungarian" => 34, "Indonesian" => 10, "Italian" => 28, "Japanese" => 11, "Korean" => 12, "Lithuanian" => 38, "Macedonian" => 24, "Malay" => 13, "Norwegian" => 26, "Polish" => 31, "Portuguese" => 14, "Romanian" => 22, "Russian" => 29, "Serbian" => 20, "Slovenian" => 33, "Spanish" => 15, "Swedish" => 27, "Thai" => 16, "Turkish" => 17, "Urdu" => 37, "Vietnamese" => 18, "English" => 1, "French" => 19, "German" => 8 }
     if langs.has_key?(name)
       langs[name]
     else
       nil
     end

   end


  private

  def connection
    @connection ||= Faraday.new(url: ENDPOINT) do |faraday|
      faraday.response :logger if ENV['DEBUG']
      faraday.adapter  Faraday.default_adapter
      faraday.use      Yifysubs::Response::HTML
      faraday.use      Yifysubs::Response::RaiseError
    end
  end


 
end
