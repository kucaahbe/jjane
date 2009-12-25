class JJaneNode < ActiveRecord::Base
  set_table_name :nodes

  belongs_to :user
  belongs_to :page
#  belongs_to :attached_file, :foreign_key => :file_id

  has_one    :meta,
    :class_name => 'JJaneMeta',
    :foreign_key => :node_id,
    :dependent => :destroy
  accepts_nested_attributes_for :meta

  attr_accessible :title, :content, :preview, :page_id, :user_id, :meta_attributes

  validates_presence_of :title, :page_id, :user_id

  def url
    self.page.url+'/'+self.id.to_s
  end

  # @article.author
  #def author
  #  self.user.name
  #end

  # сколько слов должно рисоваться в предпросмотре статьи
  #(article.preview(20) - 20 слов)
  def content(words=nil)
    if words
      s=StringScanner.new(self.content)
      words.times { s.scan_until(/ /) }
      s.pre_match
    else
      super
    end
  end

end
