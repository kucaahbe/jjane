class AttachedFile < ActiveRecord::Base

  EXT_REGEXP = /\w+$/

    acts_as_nested_set :parent_column => :directory_id, :dependent => :destroy

  has_attached_file :atachment,
    :url => "/attachments/:id/:id_:style.:extension",
    :whiny => false,
    :styles => { 
    :thumb => "100x100#",
    :medium => "300x200#",
    :big => "800x600#"
  }

  before_validation :set_name
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :directory_id

  def file?
    self.atachment_file_size
  end

  def directory?
    !self.file?
  end

  def size
    (self.atachment_file_size/1024).to_s+"Kb" if self.atachment_file_size
  end

  def extension
    self.atachment.content_type.slice(EXT_REGEXP) if self.file?#BUGHERE
  end

  def url(scheme = :original, include_updated_timestamps = true)
    self.atachment.url(scheme,include_updated_timestamps) if self.file?
  end

  def <=>(another)
    me = self;
    if me.directory? and another.directory?
      me.name <=> another.name
    else
      me.directory? ? -1 : 1
    end
  end

  private

  def set_name
    if self.file? and self.new_record?
      self.name = self.atachment_file_name.gsub(/\.\w+$/,'')
      self.name = Time.now.to_s(:number)+'_'+self.name if self.class.find_by_name_and_directory_id(self.name,self.directory_id)
    end
  end
end
