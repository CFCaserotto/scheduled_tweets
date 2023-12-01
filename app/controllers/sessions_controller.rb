class SessionsController < ApplicationController
    def new
    end
    def create
      #binding.break
      user = User.find_by(email: params[:email])
      if user.present? && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_path, notice: "Logged in successfully"
      else
        flash[:alert] = "Invalid email or password"
        puts "Flash messages: #{flash.inspect}"
        render :new, status: :unprocessable_entity
      end
    end
    def destroy
      if session[:user_id].present?
        session[:user_id] = nil
        redirect_to root_path, notice: "Logged out"
      else
        redirect_to root_path
      end
    end
end