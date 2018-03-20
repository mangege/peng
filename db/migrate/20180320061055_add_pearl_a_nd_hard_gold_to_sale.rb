class AddPearlANdHardGoldToSale < ActiveRecord::Migration
  def self.up
    add_column :sales, :pearl, :decimal, :precision => 12, :scale => 2, :default => 0.0, :null => false
    add_column :sales, :hard_gold, :decimal, :precision => 12, :scale => 2, :default => 0.0, :null => false
  end

  def self.down
    remove_column :sales, :hard_gold
    remove_column :sales, :pearl
  end
end
