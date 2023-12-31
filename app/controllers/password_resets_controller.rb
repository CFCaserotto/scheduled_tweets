class PasswordResetsController < ApplicationController
    
    def new
    end
    
    def create
      @user = User.find_by(email: params[:email])

      if @user.present?
        #send email     
        PasswordMailer.with(user: @user).reset.deliver_later
      end
      redirect_to root_path, notice: "If an account with that email is found, we will send a link to reset your password"
    end

    def edit
        #binding.break
        @user = User.find_signed!(params[:token], purpose: "password_reset")
    rescue ActiveSupport::MessageVerifier::InvalidSignature
        redirect_to sign_in_path, alert: "Your token has expires. Please try again"
    end
    def update
        #binding.break
        @user = User.find_signed!(params[:token], purpose: "password_reset")
        if @user.update(password_params)
          redirect_to sign_in_path, notice: "Your password was reset successfully. Pls sign in"
        else
          render :edit, status: :unprocessable_entity
        end
    end

    private
    def password_params
        params.require(:user).permit(:password, :password_confirmation)
    end
end