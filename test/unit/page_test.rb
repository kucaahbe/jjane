require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test "check update of url for child page" do
    page = pages(:home).children.new(:name => 'home',
				     :title => 'lala',
				     :link => 'lala',
				     :_type_ => 'static',
				     :_layout_ => 'application'
				    )
    page.save!
    assert page.url == 'home/lala'
  end

  test "check update of url for root page" do
    assert pages(:home).update_attribute(:name,'home')
  end
end
