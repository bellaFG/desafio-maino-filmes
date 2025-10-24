class CreateImports < ActiveRecord::Migration[8.1]
  def change
    create_table :imports do |t|
      t.string :file
      t.string :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
