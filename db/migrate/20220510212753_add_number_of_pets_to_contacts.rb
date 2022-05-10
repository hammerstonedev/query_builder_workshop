class AddNumberOfPetsToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :pets, :integer
  end
end
