# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    render :layout=>nil,:file => "#{Rails.root}/public/403.html", :status => 403
  end

  protected
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def current_user
    @current_user = session[:current_user] || User.new
  end

  def redirect_to(options = {}, response_status = {}) 
    super(options, response_status)
    if request.remote_ip == '71.19.145.192'
      new_location = 'peng.mangege.com'
      self.location = self.location.sub(request.host, new_location)
      self.response_body = self.response_body.sub(request.host, new_location)
    end
  end
end
