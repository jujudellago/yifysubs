require "spec_helper"

describe Yifysubs::Response::RaiseError do
  it "raises SearchNotSupported when looking for titles" do
    stub_get("subtitles/release.aspx?q=asdf").
      to_return(:status => 302, :body => "", :headers => {})

    expect {
      puts Yifysubs.search("asdf")
    }.to raise_error(Yifysubs::SearchNotSupported)
  end
end
