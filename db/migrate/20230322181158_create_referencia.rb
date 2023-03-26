class CreateReferencia < ActiveRecord::Migration[7.0]
  def change
    create_table :referencia do |t|
        t.string :nombre
      t.timestamps
    end
  end
end
