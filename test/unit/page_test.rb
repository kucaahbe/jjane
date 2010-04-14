require 'test_helper'

class PageTest < ActiveSupport::TestCase

  test 'creating node for static page' do
    puts pages(:static_page)
    page = Page.new pages(:static_page)
    page.save!
    node = page.node
    assert Node.exists?(node.id)
  end
=begin
  test "check update of url for child page" do
    page = Page.root.children.new(
      :menu => 'lolo',
      :link => 'lala',
      :page_type => 'static',
      :user_id => 1
    )
    page.save!
    assert page.url == 'home/lala'
  end

  test "check update of url for root page" do
    assert Page.root.update_attribute(:menu,'home')
  end
=end
end
