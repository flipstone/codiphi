class CreateSchematics < ActiveRecord::Migration
  def self.up
    create_table :schematics do |t|
      t.string :name
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :schematics
  end
end
