# Usage:
#   class ArticlesController < JJaneCrudController
#     set_model Article
#   end
class JJaneCrudController < JJaneAdminController

  def self.set_model(model_class_name,instance_variable=nil)
    instance_variable = model_class_name.to_s unless instance_variable
    class_eval <<-"end_eval"
    def initialize
      super
      @model = #{model_class_name}
      @thing = "#{instance_variable}".tableize
      @things = "#{instance_variable}".tableize.singularize
    end
    end_eval
  end

  before_filter :find_model, :only => [:show, :edit, :update, :destroy]

  def index
    instance_variable_set "@#{@thing}".to_sym, @model.all
  end

  def show
  end

  def new
    instance_variable_set "@#{@things}".to_sym, @model.new
  end

  def create(redirect_place = "#{@thing}_url".to_sym)
    instance_variable_set "@#{@things}".to_sym, @model.new(params["#{@things}".to_sym])
    if instance_variable_get("@#{@things}").save
      notice @model, :created
      redirect_to method(redirect_place).call
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update(redirect_place = "#{@thing}_url".to_sym)
    if instance_variable_get("@#{@things}").update_attributes(params["#{@things}".to_sym])
      notice @model, :updated
      redirect_to method(redirect_place).call
    else
      render :action => 'edit'
    end
  end

  def destroy(redirect_place = "#{@thing}_url".to_sym)
    instance_variable_get("@#{@things}").destroy

    redirect_to method(redirect_place).call
  end

  private

  def find_model
    instance_variable_set "@#{@things}".to_sym, @model.find(params[:id])
  end
end
