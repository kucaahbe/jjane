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

  def published?
    self.node.published?
  end

  def get_nodes page=nil, sorting_by=nil, sorting_order=nil, limit=nil
    time_now = Time.now
    sorting_by ||= self.sort_by
    sorting_order ||= sort_order
    limit ||= self.pagination
    self.nodes.paginate :page => page,
      :order => "#{sorting_by} #{sorting_order}",
      :per_page => limit,
      :conditions => [
"IFNULL(start_publishing,:time_now+1) <= :time_now AND IFNULL(end_publishing,:time_now+1) > :time_now",
{ :time_now => time_now }
    ]
  end

  def get_node_by_id(id)
    node = self.nodes.find(id)
    if node.published?
      node
    else
      nil
    end
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

    def layouts
      layouts_dir=File.join(RAILS_ROOT,'app','views','layouts','**')
      layouts_names = []
      Dir.glob(layouts_dir) { |fname| layouts_names << File.basename(fname).sub(/(.html.erb|.erb)$/,'') }
      layouts_names
    end

    def sort_by_values
      %w[title  created_at updated_at start_publishing end_publishing]
    end

    def sort_order_values
      { 'ASC' => true, 'DESC' => false }
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
  end

  def add_node
    self.create_node(:title => 'new page', :user_id => self.user_id )
  end

  def set_pagination
    self.pagination=5 if self.class.nodes_types.include?(self.page_type)
  end

  def sort_order
    sort_order_asc ? 'ASC' : 'DESC'
  end
end
