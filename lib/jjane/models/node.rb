class Node < ActiveRecord::Base

  # associations
  belongs_to :user
  belongs_to :page
  belongs_to :meta, :dependent => :destroy

  # attributes
  accepts_nested_attributes_for :meta
  attr_accessible :title, :content, :preview, :page_id, :user_id, :meta_attributes

  # validations
  validates_presence_of :user_id

  # callbacks
  before_create :add_meta

  def url
    self.page.url+'/'+self.id.to_s
  end

  def initialize(attributes = nil)#:nodoc:
    if attributes and attributes.has_key?(:meta)
      meta_attrs = attributes[:meta]
      attributes.delete(:meta)
      attributes.merge!(:meta_attributes => meta_attrs)
    end
    super
  end

  def update_attributes(attributes)#:nodoc:
    if attributes.has_key?(:meta)
      meta_attrs = attributes[:meta]
      attributes.delete(:meta)
      self.meta.update_attributes(meta_attrs)
    end
    super(attributes)
  end

  private

  def add_meta
    self.create_meta unless self.meta
  end
end
