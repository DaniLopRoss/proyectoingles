class Documento < ApplicationRecord

  has_one_attached :archivo_pdf
  has_many_attached :uploads 
  belongs_to :user


 
end
 