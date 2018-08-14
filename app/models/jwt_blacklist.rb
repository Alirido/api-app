class JWTBlacklist
	include Mongoid::Document
	include Mongoid::Timestamps
	include Devise::JWT::RevocationStrategies::Blacklist

	field :jti, type: String
	field :exp, type: DateTime
	
	index({jti: 1}, {unique: true})

	# self.table_name = 'jwt_blacklist'

end