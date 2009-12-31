class Node < ActiveRecord::Base

  # associations
  belongs_to :user
  belongs_to :page
  #belongs_to :attached_file, :foreign_key => :file_id
  belongs_to :meta, :dependent => :destroy

  # attributes
  accepts_nested_attributes_for :meta
  attr_accessible :title, :content, :preview, :page_id, :user_id, :meta_attributes

  # validations
  validates_presence_of :title, :user_id

  # callbacks
  before_save :add_meta

  def url
    self.page.url+'/'+self.id.to_s
  end

  private

  def add_meta
    self.create_meta unless self.meta
  end

end
