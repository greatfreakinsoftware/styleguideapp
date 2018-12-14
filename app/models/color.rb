class Color < ApplicationRecord

  belongs_to :brand

  acts_as_tenant(:brand)
end
