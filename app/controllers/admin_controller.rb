# coding: utf-8
class AdminController < ApplicationController

  def login
    unless session[:current_user].nil?
      return redirect_to(:action => "index")
    end
    if request.post?
      user = User.authenticate(params[:username], params[:password])
      if user
        session[:current_user] = user
        redirect_to(:action => "index")
      else
        flash.now[:notice]="登陆失败"
        render :layout=>"sign"
      end
    else
      render :layout=>"sign"
    end

  end

  def logout
    session.clear
    redirect_to(:action => "login")
  end

  def index
  end

  def init_admin
    admin_user = User.find_by_username("admin");
    if admin_user.nil?
      admin_user = User.create(:username => "admin", :password => "admin", :role => "admin")
      admin_user.save()
      render :text => "添加成功"
    else
      render :text => "管理员已经存在"
    end
    
  end

end
