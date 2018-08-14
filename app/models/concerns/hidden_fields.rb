# Module Utils::HiddenFields
#   extend ActiveSupport::Concern

#   def serializable_hash(options={})
#     options[:except] = Array(options[:except])

#     if options[:force_except]
#       options[:except].concat Array(options[:force_except])
#     else
#       # Don't hide anything of HIDDEN_FIELDS is not defined
#       options[:except].concat(HIDDEN_FIELDS || [])
#     end
#     super(options)
#   end
# end