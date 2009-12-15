module PagesHelper #:nodoc:

  def published_img(page)
#    engine_image page.published? ? 'page.png' : 'unpublished-page.png'
    engine_image('page.png', :class => :sortable)
  end

end 
