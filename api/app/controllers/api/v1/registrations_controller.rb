module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      before_action :ensure_params_exist, only: :create

      # signup
      def create
        user = User.new(user_params)
        if user.save
          json_response "Signup successful", true, { user: user }, :ok
        else
          json_response "Something wrong", false, { user: user }, :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def ensure_params_exist
        return if params[:user].present?
        json_response "missing params", false, {}, :bad_request
      end
    end
  end
end
