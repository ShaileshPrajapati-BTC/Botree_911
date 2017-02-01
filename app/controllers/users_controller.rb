class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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
    @user = User.new(user_params)
    set_token(@user)
    @user.add_role Role.find(params[:user][:roles].to_i).name
    if @user.save
      UserMailer.send_password_notification(@user).deliver_now
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
      render :show, status: :ok, location: @user
    else
      render :edit
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :location, :access_token, :device_type, :fcm_token)
    end

    def set_token(user)
      user.access_token = generate_token
      user.password = random_token
    end

    def generate_token
      loop do
        token = random_token
        break token unless User.where(access_token: token).exists?
      end
    end

    def random_token
      SecureRandom.hex(10)
    end
end
