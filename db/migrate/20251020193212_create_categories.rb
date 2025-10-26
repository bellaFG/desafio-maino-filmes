class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories, if_not_exists: true do |t|
      t.string :name, null: false
      t.index :name, unique: true
      t.timestamps
    end
  end
end
