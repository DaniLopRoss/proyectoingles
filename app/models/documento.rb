class Documento < ApplicationRecord
  validates :numero_de_control,  uniqueness: { message: "ya existe en la base de datos" }
  has_one_attached :archivo_pdf
  has_many_attached :uploads 
  belongs_to :user
  has_one :payment

  private 
  def file_name_start_with_prefix
           uploads.each do |upload|
                    if !upload.blob.filename.to_s.start_with?('CLE_')
                             errors.add(:uploads, "El nombre del archivo #{upload.blob.filename.to_s} no es válido")
                    end 
                    
           
           end 
  end 

  def unique_file_names
           uploads.each do |upload|
             if self.class.joins("INNER JOIN active_storage_attachments AS att ON att.record_type = '#{self.class}' AND att.record_id = #{self.class.table_name}.id")
                          .joins("INNER JOIN active_storage_blobs AS blobs ON blobs.id = att.blob_id")
                          .where.not("att.name = ?", upload.name)
                          .where(blobs: { filename: upload.filename.to_s })
                          .count > 0
               errors.add(:uploads, "El archivo #{upload.blob.filename.to_s} ya ha sido subido.")
             end 
           end 
  end
 
  def self.sin_pago
    where.not(id: Payment.select(:documento_id))
  end

end
 