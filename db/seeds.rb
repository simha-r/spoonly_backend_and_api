product = Product.find_or_create_by(name: 'Grilled Fish with Fennel Cream Sauce')
product.update_attributes(price: 150)

product = Product.find_or_create_by(name: 'Pesto Chicken')
product.update_attributes(price: 150)

product = Product.find_or_create_by(name: 'Kadai Chicken Meal')
product.update_attributes(price: 150)

product = Product.find_or_create_by(name: 'Wheat Berries with pesto chicken')
product.update_attributes(price: 150)

product = Product.find_or_create_by(name: 'Veg Schezwan Noodle Combo')
product.update_attributes(price: 150)

company_user = CompanyUser.create(email: 'simhaece@gmail.com',password: 'password',password_confirmation:'password')

DeliveryExecutive.find_or_create_by(name: 'Badrappa',phone_number: '8008630380')
DeliveryExecutive.find_or_create_by(name: 'Mohan',phone_number: '9848192756')
