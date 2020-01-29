require 'pry'
def find_item_by_name_in_collection(name, collection)
  collection.each do |item|
    if item[:item] == name
      return item
    end
  end
  return nil
end

def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item|
  new_item = find_item_by_name_in_collection(item[:item], cart)
    # If position exist find_item_by_name_in_collection add 1 to counter and skip
    next new_cart[new_item[:item]][:count] += 1 if new_cart[item[:item]]
    
    # If position doesn't exist create a new one
    new_cart[item[:item]] = {
      item: item[:item],
      price: item[:price],
      clearance: item[:clearance],
      count: 1
    }
  end
  return new_cart.values
end

def apply_coupons(cart, coupons)
  # return nil if coupons.length < 0
  new_item = {}
  counter = 0
  cart.each do |item|
    return nil if !cart.include?(item)
    coupons.each do |coupon|
      if item[:item] == coupon[:item]
      price = coupon[:cost] / coupon[:num]
        while coupon[:num] > 0
          coupon[:num] -=1
          item[:count] -= 1
          counter += 1
        end
        new_item = {
          item: "#{item[:item]} W/COUPON",
          price: price,
          clearance: item[:clearance],
          count: counter
        }
        cart << new_item
      end  
    end 
  end
   cart
end

def apply_clearance(cart)
  cart.each do |item|
    discount = item[:price] - (item[:price] * 0.20)
    item[:price] = discount.round(2) if item[:clearance]
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  consolidated = consolidate_cart(cart)
  couponed = apply_coupons(consolidated, coupons)
  total_cart = apply_clearance(couponed)
  binding.pry
  total_cart.each do |item|
    total += item[:price] * item[:count]
  end
   if total > 100
    total -= (total * 0.10)
   end
   total
end
