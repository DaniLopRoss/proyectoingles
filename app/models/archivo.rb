require 'digest/md5'
class Archivo < ApplicationRecord
    before_create :generar_md5
    before_update :generar_md5

  private

  def generar_md5
    self.md5_hash = Digest::MD5.hexdigest(archivo.download)
  end
end