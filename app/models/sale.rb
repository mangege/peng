# -*- encoding : utf-8 -*-
class Sale < ActiveRecord::Base
  belongs_to :store
  belongs_to :user

  SALE_TYPE = [["外销",1],["内销",2]]

  validates_numericality_of :inlay,:pt,:gold,:kgold, :other, :old_gold, :old_pt, :gold_jade, :color_stone, :message => "营业额不能为空且要大于或等于0的数字,支持小数", :greater_than_or_equal_to => 0
  validate :valid_sale_time
  validate :valid_data_uni, :on => :create

  before_save :sum_day

  def new_material_sum
    inlay + kgold + pt + gold + other + gold_jade + color_stone
  end

  def old_material_sum
    old_gold + old_pt
  end

  protected
  def sum_day
    self.day = self.inlay + self.pt + self.gold + self.kgold + self.other + self.old_gold + self.old_pt + self.color_stone + self.gold_jade
  end

  private
  def valid_sale_time
    if sale_time > Date.current || sale_time < (Date.current - 31)
      errors.add(:sate_time,"日期必须要小于或等于今天,且只能录入前31天以内的数据")
    end
  end

  def valid_data_uni
    if Sale.count(:all,:conditions => ["store_id = ? and sale_type = ? and sale_time = ?",store_id,sale_type,sale_time]) > 0
      errors.add_to_base "每个店铺每种数据类型每天只能录入一条"
    end
  end

end
