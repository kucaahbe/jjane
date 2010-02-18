class Page < ActiveRecord::Base
  attr_protected :url,:lft,:rgt

  acts_as_nested_set

  # associations
  has_many :nodes, :dependent => :destroy
  belongs_to :node, :dependent => :destroy
  belongs_to :user

  accepts_nested_attributes_for :node
  #serialize :nav, Hash#TODO or TODEL

  # validations
  validates_presence_of :name, :link, :menu, :page_type, :user_id
  validates_uniqueness_of :link, :scope => :parent_id
  validates_uniqueness_of :name
  validates_numericality_of :pagination, :allow_nil => true, :only_integer => true, :greater_than => 0
  validates_format_of :link,
    :with => /^[a-zA-Z][\w_]+$/
  validates_format_of :name, :with => /^[a-z,_]+$/

  # callbacks
  before_save :calculate_url
  before_create :add_node, :set_pagination

  def title
    self.node.title
  rescue
    ''
  end

  def content
    self.node.content
  rescue
    ''
  end

  def meta
    self.node.meta
  end

  def visible_in_menu?(name)
    self.send "nav_#{name}".to_sym
  end

  def have_children?
    not self.children.empty?
  end

  def published?#TODO
    true
  end

  #-- 
  #PUBLIC CLASS METHODS
  #++
  class << self

    def home_page
      root
    end

    def menus_columns
      columns = []
      self.columns.each { |column| columns << column.name if column.name =~ /^nav_/ }
      return columns.sort
    end

    def menus
      menus = []
      self.menus_columns.each { |column| menus << column.slice(4,column.length-3) }
      return menus
    end

    def menu_exists?(name)
      self.menus.include?(name) ? true : false
    end

    def static_page_types
      pages_dir=File.join(RAILS_ROOT,'app','views','pages','**')
      static_page_types = []
      Dir.glob(pages_dir) { |fname| static_page_types << File.basename(fname) }

      static_page_types = static_page_types - self.nodes_types
    end

    def nodes_types
      nodes_dir=File.join(RAILS_ROOT,'app','views','nodes','**')
      nodes_types = []
      Dir.glob(nodes_dir) { |fname| nodes_types << File.basename(fname) }
      nodes_types
    end
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

  def add_node
    self.create_node(:title => 'new page', :user_id => self.user_id )
  end

  def set_pagination
    self.pagination=5 if self.class.nodes_types.include?(self.page_type)
  end
end
