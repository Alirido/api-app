class UsersController < ApplicationController
	# before_action :authenticate_user!
	before_action :authenticateMember

	def index
		users = User.where(role_id: "5b6c1b2a1d5eaa4c5ca9b7a3").order(email: :asc).page(params[:page])
		role = Role.find(id: "5b6c1b2a1d5eaa4c5ca9b7a3")
		render json: {users: users, as: role.name, totalpages: users.total_pages}, each_serializer: UserSerializer, status: 200
	end

	def show
	    user = User.find(params[:id])

	    render json: user, each_serializer: UserSerializer
	    # , except: [:pswrd]
	end
end
