require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  test "Link::generate_short_url should return 7 characters" do
    assert_equal Link.generate_short_url.size, 7
  end

  test "should not save link without original URL" do
    link = Link.new
    assert_not link.save
    assert_includes link.errors.messages[:original_url], "can't be blank"
  end

  test "should not save link without short URL" do
    link = Link.new
    assert_not link.save
    assert_includes link.errors.messages[:short_url], "can't be blank"
  end

  test "should not save duplicate original URL" do
    url = "http://test.site.com"
    link = Link.new(original_url: url, short_url: Link.generate_short_url)
    assert link.save

    dup_link = Link.new(original_url: url, short_url: Link.generate_short_url)
    assert_not dup_link.save
    assert_includes dup_link.errors.messages[:original_url], "has already been taken"
  end

  test "should not save duplicate short URL" do
    short_url = Link.generate_short_url
    link = Link.new(original_url: "http://test.site.com", short_url: short_url)
    assert link.save

    dup_link = Link.new(original_url:"http://test.sample.com", short_url: short_url)
    assert_not dup_link.save
    assert_includes dup_link.errors.messages[:short_url], "has already been taken"
  end
end
