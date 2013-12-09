ActiveAdmin.register Product do

index do
	column :product_name
	column :vendor
	column "Price", :cost_price
	column "manufature date", :mfd_on
	column "Expiry date", :expired_on
end

end
