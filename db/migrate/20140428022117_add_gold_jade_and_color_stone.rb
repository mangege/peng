class AddGoldJadeAndColorStone < ActiveRecord::Migration
  def self.up
    add_column :sales, :gold_jade, :float
    add_column :sales, :color_stone, :float
  end

  def self.down
    remove_column :sales, :gold_jade
    remove_column :sales, :color_stone
  end
end
