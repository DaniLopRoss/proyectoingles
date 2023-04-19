class Payment < ApplicationRecord
    belongs_to :documento, autosave: true
    has_many_attached :uploads 
    has_one :certificate
    belongs_to :user
    

    def self.sin_certificado
        where(certificate_id: nil)
      end    
end