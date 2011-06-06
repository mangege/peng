# coding: utf-8
class Store < ActiveRecord::Base
  has_many :users
  has_many :sales

  validates_presence_of :name, :message => "店铺名不允许为空"
end
