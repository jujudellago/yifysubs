class Yifysubs::SubtitleResult

  attr_accessor :attributes, :id, :name, :url, :lang, :rated,
    :user, :user_id, :comment, :files_count, :hearing_impaired, :download_url

  def initialize(attributes)
    @attributes = attributes

    @id      = @attributes[:id]
    @name    = @attributes[:name]
    @url     = @attributes[:url]
    @download_url = @attributes[:download_url]
    @lang    = @attributes[:lang]
    @rated   = @attributes[:rated]
    @user    = @attributes[:user]
    @user_id = @attributes[:user_id]
    @comment = @attributes[:comment]
    @files_count = @attributes[:files_count]
    @hearing_impaired = @attributes[:hearing_impaired]
  end

  def self.build(html)
    subtitle_url = (html.css("td[3] a").attribute("href").value rescue nil)
    download_url = subtitle_url.gsub("\/subtitles","\/subtitle")
    download_url = download_url+".zip"
    id =  (html.attribute("data-id").to_s rescue nil)
    sp = (html.css("td[3] span.text-muted").text.strip rescue nil)
    name = (html.css("td[3]").text.strip rescue nil)
    name.gsub!(sp,"")
    lang = (html.css("td.flag-cell span.sub-lang").text.strip rescue nil)
    rated = (html.css("td.rating-cell span.label").text.strip rescue nil)
    user_id = (html.css("td.uploader-cell a").text.strip rescue nil)
    user = (html.css("td.uploader-cell a").attribute("href").value rescue nil)
    Rails.logger.debug "sub url: #{subtitle_url} - download_url:#{download_url} - id:#{id} - lang:#{lang} - name:#{name} - rated:#{rated} - user_id:#{user_id} - user:#{user}"

    new({
      id:     id,
      name:    name,
      url:     subtitle_url,
      download_url: download_url,
      lang:    lang,
      rated:   rated,
      user:    user,
      user_id: user_id,
      comment: nil,
      files_count: nil,
      hearing_impaired: nil
    })
  end
end
