class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
<<<<<<< HEAD

    private

    def correct_user
        unless params[:id].to_i == current_user.id
          flash[:alert] = "You can only access your profile"
          redirect_to current_user
        end
    end

    def require_sign_in
      unless current_user
        flash[:alert] = "You must be logged in to do that"

        redirect_to new_session_path
      end
    end
=======
>>>>>>> 88a740581ec58727348298b674faa22a7990f9aa
end
