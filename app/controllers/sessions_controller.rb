class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:email], params[:password], params[:remember_me])
    respond_to do |f|
      if user
        flash[:success] = "You have been logged in."
        f.js { render js: "window.location='#{root_url}'" }
      else
        flash[:alert] = "Email or password was invalid"
      end
    end
  end

  def destroy
    logout
    flash[:success] = "You have been logged out."
    render js: "window.location='#{root_path}'"
  end
end
