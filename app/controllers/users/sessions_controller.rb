class Users::SessionsController < Devise::SessionsController
before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    user = User.find_by_email(params[:user][:email])
    if user && user.valid_password?(params[:user][:password])
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      current_user.update_attributes(fcm_token: params[:fcm_token], device_type: params[:device_type])
      yield resource if block_given?
      respond_to do |format|
        format.json {
          render :json => {:status => true, :message => "Suceessfully",:data => user_info(user)}
        }
        format.html {super}
      end
    else
      respond_to do |format|
        format.json {
          render :json => {:status => false, :message => "Invalid id password", :data => nil}
        }
        format.html {super}
      end
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end

  private

  def user_info(user)
    {
      :user =>{
        :first_name => user.first_name,
        :last_name  => user.last_name,
        :email => user.email,
        :access_token => user.access_token
      }
    }
  end
end