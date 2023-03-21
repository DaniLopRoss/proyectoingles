class AddArchivoToArchivo < ActiveRecord::Migration[7.0]
  def change
   add_column :archivos, :archivo, :blob
  end
end
