require 'swagger/blocks'
require_dependency 'moslemcorners/auth'

class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    include Swagger::Blocks
    # before_action :authenticate_user!
    # before_action :authenticate, :if => proc {JANGAN DIPAKAI PROC NYA}
    respond_to :json

    def verified_member?
        !!try_current_member
    end

    def verified_doctor?
        !!try_current_doctor
    end

    def try_current_member
        if auth_present? && uid_present?
            begin
                decrypted_uid = auth['user']
            rescue
                nil
            end
            if decrypted_uid == uid
                begin
                    user = User.find(decrypted_uid)
                    # binding.pry
                    if user.role.name == 'Member'
                        @current_member ||= user
                    else
                        nil
                    end
                rescue
                    nil
                end
            else
                nil
            end
        else
            nil
        end
    end

    def try_current_doctor
        if auth_present? && uid_present?
            begin
                decrypted_uid = auth['user']
            rescue
                nil
            end
            if decrypted_uid == uid
                begin
                    user = User.find(decrypted_uid)
                    if user.role.name == 'Doctor'
                        @current_doctor ||= user
                    else
                        nil
                    end
                rescue
                    nil
                end
            else
                nil
            end
        else
            nil
        end
    end

    def authenticateMember
        render json: { status: '401', message: 'unauthorized access' }, status: 401 unless verified_member?
    end

    def authenticateDoctor
        render json: { status: '401', message: 'unauthorized access' }, status: 401 unless verified_doctor?
    end

    private
    def token
        request.env['HTTP_AUTHORIZATION'].scan(/Bearer (.*)$/).flatten.last
    end

    def uid
        request.env['HTTP_UID']
    end

    def auth
        MoslemCorners::Auth.decode(token)
    end

    def auth_present?
        # request.headers.each { |key, value|  puts "#{key} => #{value}"}
        !!request.env.fetch('HTTP_AUTHORIZATION','').scan(/Bearer/).flatten.first
    end

    def uid_present?
        !!request.env.fetch('HTTP_UID','')
    end

    # def render_resource(resource)
    #     if resource.errors.empty?
    #         render json: {resource: resource}
    #         # , token: token }
    #     else
    #         validation_error(resource)
    #     end
    # end

    # def validation_error(resource)
    #     render json: {
    #       errors: [
    #         {
    #           status: '400',
    #           title: 'Bad Request',
    #           detail: resource.errors,
    #           code: '100'
    #         }
    #       ]
    #     }, status: :bad_request
    # end
end
