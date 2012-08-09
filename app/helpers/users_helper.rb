# -*- encoding : utf-8 -*-
module UsersHelper
  def select_store_all
    stores = Store.all.map { |u| [u.name,u.id]}
    stores.insert(0,['请选择',''])
  end

  def get_role(role_value)
    roles = User::ROLES
    roles = roles.map { |t|t.reverse}
    Hash[*roles.flatten][role_value]
  end
end
