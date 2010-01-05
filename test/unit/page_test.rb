require 'test_helper'

class PageTest < ActiveSupport::TestCase

  static_page = Page.new(
    :link => 'somelink',
    :menu => 'somemenu',
    :page_type => 'static',
    :user_id => 1
  )

  test 'creating node for static page' do
    page = static_page
    page.save!
    node = page.node
    assert Node.exists?(node.id)
  end

  test "check update of url for child page" do
    page = Page.first.children.new(
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
end
