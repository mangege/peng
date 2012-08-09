# -*- encoding : utf-8 -*-
module SalesHelper
  def get_type(type_value)
    sale_type = Sale::SALE_TYPE
    sale_type = sale_type.map { |t|t.reverse}
    Hash[*sale_type.flatten][type_value]
  end

  def select_store_all
    stores = Store.all.map { |u| [u.name,u.id]}
    stores.insert(0,['请选择',''])
  end

  def select_store_all_admin
    stores = Store.all.map { |u| [u.name,u.id]}
  end
end
