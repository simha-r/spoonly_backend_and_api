product = Product.create(name: 'Grilled Fish with Fennel Cream Sauce',price: 150)
product = Product.create(name: 'Pesto Chicken',price:120)
product = Product.create(name: 'Kadai Chicken Meal',price:120)
product = Product.create(name: 'Wheat Berries with pesto chicken',price:130)
product = Product.create(name: 'Veg Schezwan Noodle Combo',price:100)

company_user = CompanyUser.create(email: 'simhaece@gmail.com',password: 'password',password_confirmation:'password')

DeliveryExecutive.find_or_create_by(name: 'Balraj',phone_number: '9704166204')