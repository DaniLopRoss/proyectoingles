class AddStatusToReferencia < ActiveRecord::Migration[7.0]
  def change
    add_column :referencia, :status, :string
  end
end
