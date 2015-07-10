lunch_category = Category.where(name: 'lunch').first_or_create

product = Product.create(name: 'Grilled Fish with Fennel Cream Sauce',price: 150,category_id: lunch_category.id,
                   state:'inactive')
product = Product.create(name: 'Pesto Chicken',price:120,category_id: lunch_category.id,state:'inactive')
product = Product.create(name: 'Kadai Chicken Meal',price:120,category_id: lunch_category.id,state:'inactive')
product = Product.create(name: 'Wheat Berries with pesto chicken',price:130,category_id: lunch_category.id,state:'inactive')
product = Product.create(name: 'Veg Schezwan Noodle Combo',price:100,category_id: lunch_category.id,state:'inactive')


company_user = CompanyUser.create(email: 'simhaece@gmail.com',password: 'password',password_confirmation:'password')
