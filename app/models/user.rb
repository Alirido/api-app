require 'bcrypt'
require 'moslemcorners/common_model'

class User
  include BCrypt
  include Mongoid::Document
  include MoslemCorners::CommonModel

  belongs_to :role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, 
         :validatable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :token, type: String, default: ''

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  
  # For inheritance
  field :type,      type: String



  paginates_per 5


  HIDDEN_FIELDS = [:role_id, :token]


  def serializable_hash(options={})
    options[:except] = Array(options[:except])

    if options[:force_except]
      options[:except].concat Array(options[:force_except])
    else
      options[:except].concat HIDDEN_FIELDS
    end
    super(options)
  end
end
