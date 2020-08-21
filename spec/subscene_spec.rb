require "spec_helper"

describe Yifysubs do
  it "has a version" do
    Yifysubs::VERSION.should be
  end

  describe ".search" do
    it "returns results" do
      stub_get("subtitles/release.aspx?q=the%2Bbig%2Bbang%2Btheory%2Bs01e01").
        to_return(:status => 200, :body => fixture("search_with_results.html"))
      stub_get("subtitles/release.aspx?q=the%20big%20bang%20theory%20s01e01").
        to_return(:status => 200, :body => fixture("search_with_results.html"))

      subs = Yifysubs.search("the big bang theory s01e01")
      subs.first.name.should == "The.Big.Bang.Theory.S01E01-08.HDTV.XviD-XOR"
    end

    it "returns subtitles filtered by language" do
      Yifysubs.language = 13

      stub_get("subtitles/release.aspx?q=the%2Bbig%2Bbang%2Btheory%2Bs01e01").
         with(:headers => { 'Cookie'=>'LanguageFilter=13;' }).
         to_return(:status => 200, :body => "")
      stub_get("subtitles/release.aspx?q=the%20big%20bang%20theory%20s01e01").
         with(:headers => { 'Cookie'=>'LanguageFilter=13;' }).
         to_return(:status => 200, :body => "")

      Yifysubs::SubtitleResultSet.stub(:build).and_return(stub.as_null_object)
      Yifysubs.search("the big bang theory s01e01")
    end
  end

  describe ".find" do
    it "returns subtitle" do
      stub_get("136037").to_return(:status => 200,
        :body => fixture("subtitle_sample.html"))

      Yifysubs.find(136037).
        name.should == "The.Big.Bang.Theory.S01E01-08.HDTV.XviD-XOR"
    end
  end
end
