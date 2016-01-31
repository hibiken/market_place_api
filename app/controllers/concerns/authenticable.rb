module Authenticable

  # Overrides Devise current_user method.
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    unless current_user.present?
      render json: { errors: "Not authenticated" }, status: 401
    end
  end
end
