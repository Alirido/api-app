require_dependency 'moslemcorners/auth'

class UsersController < ApplicationController
	# before_action :authenticate_user!
	before_action :authenticateMember, except: [:create]

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

	def create
		# user = User.send(set_type.pluralize).new(user_params)
		if set_type = 'Doctor'
			user = Doctor.new(user_params)
		else
			user = Member.new(user_params)
		end
		user.type = set_type

		user.token = MoslemCorners::Auth.issue({user: user.id.to_s})
		role = Role.find_by(name: set_type)
		user.role = role
		# binding.pry
		if user.save
			session[:user_id] = user.id
			render json: user, each_serializer: UserSerializer, status: 201
		else
			binding.pry
			render json: {Status: "Cannot create #{params[:type]}"}
			# , Role: set_type
		end
	end

	def update
	end


	private

	def set_type
		case params[:type]
		when 'Doctor'
			'Doctor'
		when 'Member'
			'Member'
		end
	end

	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation)
	end

end
