class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.references :team, null: false, foreign_key: true
      t.string :email
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
