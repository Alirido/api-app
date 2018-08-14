require 'swagger/blocks'
require_dependency 'moslemcorners/auth'

class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    include Swagger::Blocks
    # before_action :authenticate_user!
    # before_action :authenticate, :if => proc {JANGAN DIPAKAI PROC NYA}
    # respond_to :json

    def verified_member?
        !!try_current_member
    end

    def verified_docter?
        !!try_current_docter
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
                    if user.role.name == 'Member'
                        @current_member ||= user
                    else # Belum selesai, perlu didalemin lagi bagian ini, karna asal nulis
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

    def try_current_docter
        if auth_present? && uid_present?
            begin
                decrypted_uid = auth['user']
            rescue
                nil
            end
            if decrypted_uid == uid
                begin
                    user = User.find(decrypted_uid)
                    if user.role.name == 'Docter'
                        @current_docter ||= user
                    else # Belum selesai, perlu didalemin lagi bagian ini, karna asal nulis
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

    def authenticateDocter
        render json: { status: '401', message: 'unauthorized access' }, status: 401 unless verified_docter?
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
