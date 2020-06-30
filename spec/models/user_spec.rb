require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do

    it 'is valid when created with all required arguments' do
      @user = User.new(email: "jdoe@test.com", first_name: "John", last_name: "Doe", password: '123', password_confirmation: '123')
      expect(@user).to be_valid
    end

    it 'is not valid when created without an email' do
      @user = User.new(email: nil, first_name: "John", last_name: "Doe", password: '123', password_confirmation: '123')
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end

    it 'is not valid when created without a first name' do
      @user = User.new(email: "jdoe@test.com", first_name: nil, last_name: "Doe", password: '123', password_confirmation: '123')
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include("First name can't be blank")
    end

    it 'is not valid when created without a last name' do
      @user = User.new(email: "jdoe@test.com", first_name: "John", last_name: nil, password: '123', password_confirmation: '123')
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include("Last name can't be blank")
    end

    it 'is not valid when created without a password' do
      @user = User.new(email: "jdoe@test.com", first_name: "John", last_name: "Doe", password: nil, password_confirmation: '123')
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end

    it 'is not valid when created without a password confirmation' do
      @user = User.new(email: "jdoe@test.com", first_name: "John", last_name: "Doe", password: '123', password_confirmation: nil)
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include("Password confirmation can't be blank")
    end

    it 'is not valid when created with a password and password_confirmation not matching' do
      @user = User.new(email: "jdoe@test.com", first_name: "John", last_name: "Doe", password: '123', password_confirmation: '124')
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'is not valid if provided email already exists in the database' do
      @user1 = User.new(email: "jdoe@test.com", first_name: "John", last_name: "Doe", password: '123', password_confirmation: '123')
      @user2 = User.new(email: "JDOE@test.com", first_name: "John", last_name: "Doe", password: '123', password_confirmation: '123')
      @user1.save
      expect(@user1).to be_valid
      expect(@user2).to_not be_valid
      expect(@user2.errors.full_messages).to include("Email has already been taken")
    end

    it 'is not valid if password length is less than 3' do
      @user = User.new(email: "jdoe@test.com", first_name: "John", last_name: "Doe", password: '12', password_confirmation: '12')
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include("Password confirmation is too short (minimum is 3 characters)")
    end
  end

  describe '.authenticate_with_credentials' do
    it 'logs the user in successfully when given the correct credentials' do
      @user = User.new(email: "jdoe@test.com", first_name: "John", last_name: "Doe", password: '123', password_confirmation: '123')
      @user.save
      expect(User.authenticate_with_credentials("jdoe@test.com", '123')).to eq(@user)
    end

    it "doesn't log the user in when given incorrect credentials and returns nil instead" do
      @user = User.new(email: "jdoe@test.com", first_name: "John", last_name: "Doe", password: '123', password_confirmation: '123')
      @user.save
      expect(User.authenticate_with_credentials("jdou@test.com", '123')).to eq(nil)
    end

    it "logs the user in successfully when there are leading or trailing spaces in the input" do
      @user = User.new(email: "jdoe@test.com", first_name: "John", last_name: "Doe", password: '123', password_confirmation: '123')
      @user.save
      expect(User.authenticate_with_credentials("   jdoe@test.com    ", '123')).to eq(@user)
    end

    it "logs the user in successfully regardless of the case" do
      @user = User.new(email: "jdoe@test.COM", first_name: "John", last_name: "Doe", password: '123', password_confirmation: '123')
      @user.save
      expect(User.authenticate_with_credentials("JDoE@test.com", '123')).to eq(@user)
    end
  end
end