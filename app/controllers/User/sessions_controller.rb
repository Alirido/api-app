# frozen_string_literal: true
require_dependency 'moslemcorners/auth'

class User::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  skip_before_action :authenticate_user!
  respond_to :json

  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
    render json: {user: {id: resource.id, email: resource.email}, token: resource.token} 
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    # set_flash_message!(:notice, :signed_in)
    token = MoslemCorners::Auth.issue({user: resource.id.to_s}) 
    resource.update_attribute(:token, token)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
    render json: {user: {id: resource.id, email: resource.email}, token: resource.token}
  end

  # DELETE /resource/sign_out
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    # set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    respond_to_on_destroy
    render json: {status: "Logged out successfully!"}
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
