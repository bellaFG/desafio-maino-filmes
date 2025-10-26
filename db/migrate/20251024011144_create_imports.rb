class CreateImports < ActiveRecord::Migration[8.1]
  def change
    create_table :imports do |t|
      t.integer :status, default: 0, null: false 
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
