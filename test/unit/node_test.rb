require 'test_helper'

=begin
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

  test 'don\'t create meta if no validation' do
    node = Node.new
    node.save
    assert (not node.meta)
  end
end
=end
