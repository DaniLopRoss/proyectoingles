class Certificate < ApplicationRecord
    has_many_attached :uploads 
    belongs_to :payment, autosave:  true
end
