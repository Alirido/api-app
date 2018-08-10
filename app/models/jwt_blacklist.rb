class JWTBlacklist
	include Mongoid::Document
	include Mongoid::Timestamps
	include Devise::JWT::RevocationStrategies::Blacklist

	
	# self.table_name = 'jwt_blacklist'

end