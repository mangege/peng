class AddOtherColumn < ActiveRecord::Migration
  def self.up
    add_column :sales, :other, :float
  end

  def self.down
    remove_column :sales, :other
  end
end
