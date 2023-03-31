class Certificate < ApplicationRecord
    has_many_attached :uploads 
    belongs_to :payment, autosave:  true
    has_one :documento, through: :payment
   # validates :nombre, uniqueness: true

    
end
