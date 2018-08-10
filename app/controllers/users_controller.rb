class UsersController < ApplicationController
	skip_before_action :authenticate_user!
	# binding.pry
	def index
		users = User.all.order(email: :asc).page(params[:page])

		render json: {users: users, totalpages: users.total_pages}, each_serializer: UserSerializer, status: 200
	end

	def show
	    user = User.find(params[:id])

	    render json: user, each_serializer: UserSerializer
	    # , except: [:pswrd]
	end
end
