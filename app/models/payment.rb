class Payment < ApplicationRecord
    belongs_to :documento, autosave: true
    has_many_attached :uploads 
    has_one :certificate
    # validate :unique_uploads

    # private
  
    # def unique_uploads
    #   uploads.each do |upload|
    #     if self.class.joins("INNER JOIN active_storage_attachments AS att ON att.record_type = '#{self.class}' AND att.record_id = #{self.class.table_name}.id")
    #                  .joins("INNER JOIN active_storage_blobs AS blobs ON blobs.id = att.blob_id")
    #                  .where(blobs: { checksum: upload.blob.checksum, content_type: upload.blob.content_type })
    #                  .where.not(att: { name: upload.name })
    #                  .count > 0
    #       errors.add(:uploads, "El archivo '#{upload.blob.filename.to_s}' ya ha sido subido.")
    #     end 
    #   end 
    # end
      
    

    def self.sin_certificado
        where(certificate_id: nil)
      end    
end