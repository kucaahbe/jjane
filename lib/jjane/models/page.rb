class Page < ActiveRecord::Base

  has_many :nodes, :class_name => 'JJaneNode'

  serialize :nav, Hash

  acts_as_nested_set

  validates_presence_of :link, :title

  validates_uniqueness_of :link, :scope => :parent_id

  validates_numericality_of :pagination, :greater_than => 0

  validates_format_of :link,
    :with => /^[a-zA-Z][\w_]+$/,
    :message => %q(должен состоять из латиницы цифр или знака '_',и начинаться с латинской буквы)

  before_save :calculate_url

  def self.home_page
    root
  end

  def uri
    '/'+self.url
  end

  def visible_in_menu?(name)
    self.send "nav_#{name}".to_sym
  end

  def some_child_visible_in_menu?(name)
    if self.have_children?
      self.leaves.exists?("nav_#{name}".to_sym => true)
    else
      false
    end
  end

  def have_children?
    not self.children.empty?
  end

  def published?#TODO
    true
  end

=begin
  def self.tree
    self.find :all, :order => :lft
  end

  def self.tree_with_level
    tree = []
    self.roots.each do |root|
      self.each_with_level(root.self_and_descendants) { |o,level| tree << {:self => o, :level => level} }
    end
    return tree
  end
=end

  def self.menus_columns
    columns = []
    self.columns.each { |column| columns << column.name if column.name =~ /^nav_/ }
    return columns.sort
  end

  def self.menus
    menus = []
    self.menus_columns.each { |column| menus << column.slice(4,column.length-3) }
    return menus
  end

  def self.menu_exists?(name)
    self.menus.include?(name) ? true : false
  end

  private

  def calculate_url
    url = self.link
    if parent_id
      parent = self.class.find(self.parent_id)
      parent.self_and_ancestors.each { |ancestor| url = ancestor.link+'/'+url }
    end
    self.url = url
    logger.info self.url
  end

end
