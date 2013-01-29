# -*- encoding : utf-8 -*-
class AdminController < ApplicationController

  def login
    unless session[:current_user].nil?
      return redirect_to(index_path)
    end
    if request.post?
      user = User.authenticate(params[:username], params[:password])
      if user
        session[:current_user] = user
        redirect_to(index_path)
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
    redirect_to(login_path)
  end

  def index
    authorize! :read, :admin
  end

  def init_admin
    admin_user = User.find_by_username("admin");
    if admin_user.nil?
      password = rand.to_s[2..-1]
      admin_user = User.create(:username => "admin", :password => password, :role => "admin")
      admin_user.save()
      render :text => "添加成功,密码为 #{password}"
    else
      render :text => "管理员已经存在"
    end
    
  end

end
