# -*- encoding : utf-8 -*-
class AddOldToSales < ActiveRecord::Migration
  def self.up
    add_column :sales, :old_gold, :float
    add_column :sales, :old_pt, :float
  end

  def self.down
    remove_column :sales, :old_gold
    remove_column :sales, :old_pt
  end
end
