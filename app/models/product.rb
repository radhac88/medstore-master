class Product < ActiveRecord::Base
  default_scope :order => 'product_name'
  before_destroy :ensure_not_referenced_by_any_line_item
  attr_accessible :btch_no, :cost_price, :expired_on, :mfd_on, :product_name, :vendor_id, :product, :remain_days, :created_at, :updated_at
  belongs_to :vendor
  has_many :line_items

  private
  def ensure_not_referenced_by_any_line_item
  	if line_items.empty?
  		return true
  	else
  		errors.add(:base, 'Line items present')
  		return false
  	end
  end
end
