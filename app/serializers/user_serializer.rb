class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role_id

  # belongs_to :role
  attribute :id do
      object.id.to_s
  end

  # attribute :role_id do
  # 	object.role.name
  # end

end
