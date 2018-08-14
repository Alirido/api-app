class DoctersController < ApplicationController
	before_action :authenticateDocter

	def index
		users = User.where(role_id: "5b6c1b2a1d5eaa4c5ca9b7a4").order(email: :asc).page(params[:page])
		role = Role.find_by(id: "5b6c1b2a1d5eaa4c5ca9b7a4")
		render json: {users: users, as: role.name, totalpages: users.total_pages}, each_serializer: UserSerializer, status: 200
	end
end
