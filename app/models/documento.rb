class Documento < ApplicationRecord
  validates :numero_de_control,  uniqueness: { message: "ya existe en la base de datos" }
  has_one_attached :archivo_pdf
  has_many_attached :uploads 
  belongs_to :user
  has_one :payment
  validates :uploads, presence: { message: "necesita adjuntar un documento" }


 
  def self.sin_pago
    where.not(id: Payment.select(:documento_id))
  end

end
 