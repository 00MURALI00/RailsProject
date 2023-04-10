# frozen_string_literal: true

class Api::Users::RegistrationController < Api::ApiController
  skip_before_action :doorkeeper_authorize!, only: %i[create]
  protect_from_forgery with: :null_session

  include DoorkeeperRegisterable

  def create
    client_app = Doorkeeper::Application.find_by(uid: user_params[:client_id])
    if client_app
      return render json: { error: I18n.t('api.user.registration.invalid_client_id') }, status: :unprocessable_entity
    end

    allowed_params = user_params.except(:client_id)
    user = User.new(allowed_params)
    if user.save
      render json: render_user(user, client_app), status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def user_params
    params.permit(:email, :password, :client_id)
  end
end
