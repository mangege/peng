# -*- encoding : utf-8 -*-
class CreateSales < ActiveRecord::Migration
  def self.up
    create_table :sales do |t|
      t.integer :sale_type
      t.float :inlay
      t.float :pt
      t.float :gold
      t.float :kgold
      t.float :day
      t.date :sale_time
      t.references :store
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :sales
  end
end
