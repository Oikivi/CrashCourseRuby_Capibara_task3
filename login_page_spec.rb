# frozen_string_literal: true

require 'selenium-webdriver'
require 'capybara/rspec'
require_relative 'spec_helper'

RSpec.describe 'Login Tests' do
 
  before(:each) do
    @driver = Capybara::Session.new(:selenium)
    @driver.visit @url
  end

  context "Login with username and password" do
    usernames = [ 'error_user', 'locked_out_user', 'standard_user']
    password = 'secret_sauce'
    incorrect_password = "234567jik 9m7hunb jyubinighugnlsmo;dx,d;hodfomig p"

    usernames.each do |username|
      it "attempt by user with nickname #{username} to log in" do
        if username == 'error_user'
          @driver.fill_in 'user-name', with: username
          @driver.fill_in 'password', with: incorrect_password       
          @driver.click_button('Login') 
          expect(@driver).to have_selector('[data-test="error"]', text: "Epic sadface: Username and password do not match any user in this service")             
        elsif username == 'locked_out_user'
          @driver.fill_in 'user-name', with: username
          @driver.fill_in 'password', with: password     
          @driver.click_button('Login')   
          expect(@driver).to have_selector('[data-test="error"]', text: "Epic sadface: Sorry, this user has been locked out.")             
        else
          @driver.fill_in 'user-name', with: username
          @driver.fill_in 'password', with: password
          @driver.click_button('Login')

          data_test_item_1 = '[data-test="add-to-cart-sauce-labs-backpack"]'  
          data_test_item_1_in_cart = '[data-test="remove-sauce-labs-backpack"]'          
          add_item_in_cart(data_test_item_1, data_test_item_1_in_cart) 
           
          data_test_item_2 = '[data-test="add-to-cart-sauce-labs-onesie"]'     
          data_test_item_2_in_cart = '[data-test="remove-sauce-labs-onesie"]' 
          add_item_in_cart(data_test_item_2, data_test_item_2_in_cart)
        end
      end
    end
  end

  def add_item_in_cart(data_test, in_cart_item)
    if add_item_to_cart(data_test)  
      item = @driver.find(in_cart_item)
      expect(item.text).to eql("Remove")  
    end
  end

  def add_item_to_cart(data_test)
    add_button = @driver.find(data_test)
    if add_button
      click_on_button(add_button)
      true
    else
      false
    end
  end

  def click_on_button(button)
    button.click
  end   
end
