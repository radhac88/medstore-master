class Vendor < ActiveRecord::Base
  attr_accessible :vendor_address, :vendor_name, :product_id, :vendor, :created_at, :updated_at
  has_many :products, dependent: :destroy
end
