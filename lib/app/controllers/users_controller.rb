class UsersController < AdminController #:nodoc:
  before_filter :find_user, :except => [:index, :new, :create]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      notice :created
      redirect_to users_path
    else
      render :action => "new"
    end
  end

  def update
    if @user.update_attributes(params[:user])
      notice :updated
      redirect_to users_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @user.destroy

    redirect_to users_url
  end

  private

  def find_user
    @user = find_model
  end
end
