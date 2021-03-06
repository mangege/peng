# -*- encoding : utf-8 -*-
module ApplicationHelper
  #添加字段验证错误消息到FLASH
  def add_errors_to_flash_now
    model_name = controller_name[0...-1]
    model = nil
    eval("model = @#{model_name}")
    if model.class.method_defined? :errors
      if model.errors.any?
        flash.now[:error] = []
        model.errors.full_messages.each { |msg|
          flash.now[:error] << msg
        }
      end
    end
  end

  def current_user
    session[:current_user] || User.new
  end
end
