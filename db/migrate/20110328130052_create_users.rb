class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :role
      t.string :other
      t.references :store

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
