class AddDefaultValue < ActiveRecord::Migration
  def self.up
    change_column :sales, :inlay, :decimal, :precision => 12, :scale => 2, :default => 0, null: false
    change_column :sales, :pt, :decimal, :precision => 12, :scale => 2, :default => 0, null: false
    change_column :sales, :gold, :decimal, :precision => 12, :scale => 2, :default => 0, null: false
    change_column :sales, :kgold, :decimal, :precision => 12, :scale => 2, :default => 0, null: false
    change_column :sales, :day, :decimal, :precision => 12, :scale => 2, :default => 0, null: false
    change_column :sales, :other, :decimal, :precision => 12, :scale => 2, :default => 0, null: false
    change_column :sales, :old_gold, :decimal, :precision => 12, :scale => 2, :default => 0, null: false
    change_column :sales, :old_pt, :decimal, :precision => 12, :scale => 2, :default => 0, null: false
    change_column :sales, :gold_jade, :decimal, :precision => 12, :scale => 2, :default => 0, null: false
    change_column :sales, :color_stone, :decimal, :precision => 12, :scale => 2, :default => 0, null: false
  end

  def self.down
    change_column :sales, :inlay, :float
    change_column :sales, :pt, :float
    change_column :sales, :gold, :float
    change_column :sales, :kgold, :float
    change_column :sales, :day, :float
    change_column :sales, :other, :float
    change_column :sales, :old_gold, :float
    change_column :sales, :old_pt, :float
    change_column :sales, :gold_jade, :float
    change_column :sales, :color_stone, :float
  end
end
