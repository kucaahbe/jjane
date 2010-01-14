require 'paperclip'
class AttachedFile < ActiveRecord::Base
  acts_as_nested_set :parent_column => :directory_id
  has_attached_file :atachment

  validates_uniqueness_of :name, :scope => :directory_id

  def file?
    self.atachment_file_name
  end

  def directory?
    !self.file?
  end

  def name
    if self.file?
      super+'.'+self.atachment.original_filename.gsub(/^.+\./,'').downcase
    else
      super
    end
  end
end
