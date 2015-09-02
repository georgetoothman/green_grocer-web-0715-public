def consolidate_cart(cart:[])
  consolidated_hash = {}
  cart.each do |item_hash|
    food_name = item_hash.keys.first
    # food_details_hash = item_hash.values.first
    # food_details_hash[:count] = 1
    # consolidated_hash[food_name] = food_details_hash
    if consolidated_hash[food_name]
      consolidated_hash[food_name][:count] += 1
    else
      food_details_hash = item_hash.values.first
      food_details_hash[:count] = 1
      consolidated_hash[food_name] = food_details_hash
    end
  end

  consolidated_hash
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    food_name = coupon[:item]
    coupon_num = coupon[:num]
   
    food_count = 0
    if cart[food_name]
      food_count = cart[food_name][:count]
    end

    if food_count >= coupon_num
      food_name_with_coupon = "#{food_name} W/COUPON"
   
      if cart[food_name_with_coupon]
        cart[food_name_with_coupon][:count] += 1
      else
        food_price = coupon[:cost]
        food_clearance = cart[food_name][:clearance]

        food_with_coupon_hash = {price: food_price, clearance: food_clearance, count: 1}
        cart[food_name_with_coupon] = food_with_coupon_hash
      end

      cart[food_name][:count] -= coupon_num
      food_count = cart[food_name][:count]
    end
  end
  cart
end

def apply_clearance(cart:[])
  cart.each do |food_name, food_info_hash|
    if food_info_hash[:clearance]
      food_info_hash[:price] = (food_info_hash[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart: [], coupons: [])
  consolidated = consolidate_cart(cart: cart) # this adds the car to the cart arg
  couponed = apply_coupons(cart: consolidated, coupons: coupons)
  discounted = apply_clearance(cart: couponed)

  total_price = 0
  discounted.each do |food_name, food_info_hash|
    total_price += (food_info_hash[:price] * food_info_hash[:count])
  end
  total_price > 100 ? (total_price * 0.9).round(2) : total_price
end