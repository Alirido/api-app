class UserSerializer < ActiveModel::Serializer
  attributes :id, :email

  # belongs_to :role
  attribute :id do
      object.id.to_s
  end

end
