class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      flash[:success] = "You have been logged in."
      redirect_to root_url
    else
      flash[:alert] = "Email or password was invalid"
    end
  end

  def destroy
    logout
    render js: "window.location='#{root_path}'"
  end
end
