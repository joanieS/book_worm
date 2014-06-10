class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |f| 
      if @user.save
        flash[:success] = "You have been registered."
        f.js { render js: "window.location='#{root_url}'" }
      else
        f.js { render js: 'register_failure', msg: print_errors_for(@user) }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def print_errors_for(user)
    messages = user.errors.full_messages
    error_string = "Your account couldn't be created: "
    messages.each { |message| error_string << "#{message}. " }
    error_string
  end
end
