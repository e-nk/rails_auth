class Api::V1::SessionsController < Devise::SessionsController
  before_action :sign_in_params, only: :create
  before_action :load_user, only: :create
  before_action :valid_token, only: :destroy
  skip_before_action :verify_signed_out_user, only: :destroy

  def create
    if @user&.valid_password?(sign_in_params[:password])
      json_response "Logged in successfully", true, {
        user: {
          id: @user.id,
          email: @user.email,
          created_at: @user.created_at,
          updated_at: @user.updated_at,
          authentication_token: @user.authentication_token
        }
      }, :ok
    else
      json_response "Unauthorized", false, {}, :unauthorized
    end
  end

  def destroy
    sign_out @user
    @user.generate_new_authentication_token
    json_response "Logged out successfully", true, {}, :ok
  end


  private

  def sign_in_params
    params.require(:sign_in).permit(:email, :password)
  end

  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
    unless @user
      json_response "Couldn't find user", false, {}, :not_found
    end
  end

  def valid_token
    @user = User.find_by authentication_token: request.headers["AUTH-TOKEN"]
    if @user
      @user
    else
      json_response "Invalid token", false, {}, :unauthorized
    end
  end
end
