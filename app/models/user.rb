# coding: utf-8
class User < ActiveRecord::Base
  belongs_to :store
  has_many :sales

  validates_uniqueness_of :username, :message => "名称不能为空且不能重复"
  validates_presence_of :password, :message => "密码不能为空"
  validates_presence_of :role, :message => "角色必选"
  validate :valid_store

  ROLES = ['管理员','admin'],['雇员','employee'],['来宾','guest']


  def role?(base_role)
    base_role.to_s == role
  end

  def self.authenticate(username, password)
    user = self.find_by_username(username)
    if user and user.password != password
      user = nil
    end
    user
  end

  private
  def valid_store
    unless role.nil?
      if (role == "admin" or role == "guest")
        errors.add_to_base "管理员和来宾不用选择门店" unless store_id.nil?
      elsif role == "employee"
        errors.add_to_base "雇员必须要选择所属门店" if store_id.nil?
      end
    end
  end
end
