require 'test_helper'

class NodeTest < ActiveSupport::TestCase
  test 'automatic creating meta for node 1' do
    node = Node.create!(
      :title => 'test node',
      :user_id => '1'
    )
    assert node.meta
  end

  test 'automatic creating meta for node 2' do
    node = Node.new(
      :title => 'test node',
      :user_id => '1'
    )
    node.save!
    assert node.meta
  end
end
