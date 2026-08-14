class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [ :name, :address, :city, :province, :postal_code ]
    )

    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [ :name, :address, :city, :province, :postal_code ]
    )
  end
end
