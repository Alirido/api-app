class SessionsController < Devise::SessionsController
	respond_to :json
	# skip_before_action :authenticate_user!
	# skip_before_action :authenticate

	private

	def respond_with(resource, _opts = {})
		render json: resource
	end

	def respond_to_on_destroy
		head :no_content
	end
end