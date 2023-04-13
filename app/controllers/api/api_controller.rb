# frozen_string_literal: true

module Api
  class ApiController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json
  # helper method to access the current user from the doorkeeper token
  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
  end
end
