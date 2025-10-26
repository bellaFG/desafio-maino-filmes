class AddAnonSessionIdToComments < ActiveRecord::Migration[8.1]
  def change
    add_column :comments, :anon_session_id, :string
    add_index :comments, :anon_session_id
  end
end
