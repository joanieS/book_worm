class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:email], params[:password])
    binding.pry
    respond_to do |f|
      if user
        flash[:success] = "You have been logged in."
        f.js { render js: "window.location='#{root_url}'" }
      else
        @msg = "Email or password was invalid"
        f.js { render 'layouts/form_failure', locals: {msg: @msg} }
      end
    end
  end

  def destroy
    logout
    flash[:success] = "You have been logged out."
    render js: "window.location='#{root_path}'"
  end
end
