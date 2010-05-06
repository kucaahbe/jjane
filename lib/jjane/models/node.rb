class Node < ActiveRecord::Base

  @@has_meta = false

  # associations
  belongs_to :user
  belongs_to :page
  belongs_to :meta, :dependent => :destroy

  # attributes
  accepts_nested_attributes_for :meta
  attr_accessible :title, :content, :preview, :page_id, :user_id, :meta_attributes, :start_publishing, :end_publishing

  # validations
  validates_presence_of :user_id

  # callbacks
  before_create :add_meta

  class <<self
    def has_meta
      @@has_meta = true
    end
  end

  def url
    self.page.url+'/'+self.id.to_s
  end

  def initialize(attributes = nil)#:nodoc:
    self.build_meta
    if attributes and attributes.has_key?(:meta)
      meta_attrs = attributes[:meta]
      attributes.delete(:meta)
      attributes.merge!(:meta_attributes => meta_attrs)
    end
    super
    self.start_publishing = Time.now
  end

  def update_attributes(attributes)#:nodoc:
    if attributes.has_key?(:meta)
      meta_attrs = attributes[:meta]
      attributes.delete(:meta)
      self.meta.update_attributes(meta_attrs)
    end
    super(attributes)
  end

  def author
    user.name
  end

  def published?
    time_now = Time.now
    if started_publishing_since?(time_now) and (not ended_publishing_untill?(time_now))
      true
    else
      false
    end
  end

  private

  def add_meta
    self.create_meta unless self.meta
  end

  def started_publishing_since?(time)
    !self.start_publishing.nil? && self.start_publishing < time ? true : false
  end

  def ended_publishing_untill?(time)
    if self.end_publishing.nil? 
      false
    else
      self.end_publishing > time ? false : true
    end
  end
end
