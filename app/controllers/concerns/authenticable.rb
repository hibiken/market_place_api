module Authenticable

  # Overrides Devise current_user method.
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    unless current_user.present?
      render json: { errors: "Not authenticated, response.headers['Authorization'] = #{request.headers['Authorization']}" }, status: 401
    end
  end

  def user_signed_in?
    current_user.present?
  end
end
