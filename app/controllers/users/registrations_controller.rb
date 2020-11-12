class Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    build_resource

    unless @resource.present?
      raise DeviseTokenAuth::Errors::NoResourceDefinedError,
            "#{self.class.name} #build_resource does not define @resource,"\
            ' execution stopped.'
    end

    if @resource.save
      yield @resource if block_given?      

      @token = @resource.create_token
      @resource.save!
      update_auth_header
      render_create_success
    else
      clean_up_passwords @resource
      render_create_error
    end
  end

  def sign_up_params
    params.permit(:username, :email, :password)
  end
end