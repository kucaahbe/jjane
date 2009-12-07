module JJane
  module Controllers
    # Usage:
    #   class ArticlesController < JJane::Controllers::Crud
    #     set_model Articles
    #   end
    class Crud < JJane::Controllers::Admin

      def self.set_model(model_class_name)
	@@model = model_class_name
	@@inst_variable_pluralized = model_class_name.to_s.tableize
	@@inst_variable_singularized = model_class_name.to_s.tableize.singularize
      end

      before_filter :find_model, :only => [:show, :edit, :update, :destroy]

      def index
	instance_variable_set :"@#{@@inst_variable_pluralized}", @@model.all
      end

      def show
      end

      def new
	instance_variable_set :"@#{@@inst_variable_singularized}", @@model.new
      end

      def create(redirect_place = :"#{@@inst_variable_pluralized}_url")
	instance_variable_set :"@#{@@inst_variable_singularized}", @@model.new(params[:"#{@@inst_variable_singularized}"])
	if instance_variable_get("@#{@@inst_variable_singularized}").save
	  notice @@model, :created
	  redirect_to method(redirect_place).call
	else
	  render :action => 'new'
	end
      end

      def edit
      end

      def update(redirect_place = :"#{@@inst_variable_pluralized}_url")
	if instance_variable_get("@#{@@inst_variable_singularized}").update_attributes(params[:"#{@@inst_variable_singularized}"])
	  notice @@model, :updated
	  redirect_to method(redirect_place).call
	else
	  render :action => 'edit'
	end
      end

      def destroy(redirect_place = :"#{@@inst_variable_pluralized}_url")
	instance_variable_get("@#{@@inst_variable_singularized}").destroy

	redirect_to method(redirect_place).call
      end

      private

      def find_model
	instance_variable_set :"@#{@@inst_variable_singularized}", @@model.find(params[:id])
      end
    end
  end
end
