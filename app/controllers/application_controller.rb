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

end
