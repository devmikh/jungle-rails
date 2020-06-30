require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    it 'is valid when given all required arguments' do
      @category = Category.new(name: "TestCategory")
      expect(Product.new(name: "TestProduct", price: 1000, quantity: 3, category: @category)).to be_valid
    end

    it 'is not valid if name is missing' do
      @category = Category.new(name: "TestCategory")
      @product = Product.new(name: nil, price: 1000, quantity: 3, category: @category)
      expect(@product).to_not be_valid
      expect(@product.errors.full_messages).to include("Name can't be blank")
    end

    it 'is not valid if price is missing' do
      @category = Category.new(name: "TestCategory")
      @product = Product.new(name: "TestProduct", price: nil, quantity: 3, category: @category)
      expect(@product).to_not be_valid
      expect(@product.errors.full_messages).to include("Price can't be blank")
    end

    it 'is not valid if quantity is missing' do
      @category = Category.new(name: "TestCategory")
      @product = Product.new(name: "TestProduct", price: 1000, quantity: nil, category: @category)
      expect(@product).to_not be_valid
      expect(@product.errors.full_messages).to include("Quantity can't be blank")
    end

    it 'is not valid if category is missing' do
      @product = Product.new(name: "TestProduct", price: 1000, quantity: 3, category: nil)
      expect(@product).to_not be_valid
      expect(@product.errors.full_messages).to include("Category can't be blank")
    end
  end
end