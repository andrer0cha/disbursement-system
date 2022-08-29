# frozen_string_literal: true

merchants = JSON.parse(File.open('db/dataset/merchants.json').read)['RECORDS']
shoppers = JSON.parse(File.open('db/dataset/shoppers.json').read)['RECORDS']
orders = JSON.parse(File.open('db/dataset/orders.json').read)['RECORDS']

ActiveRecord::Base.transaction do
  Rails.logger.debug "Processing file 'db/dataset/merchants.json'"
  count = 0
  merchants.each do |merchant|
    Merchant.create!(
      id: merchant['id'],
      name: merchant['name'],
      email: merchant['email'],
      cif: merchant['cif']
    )
    count += 1
  end
  Rails.logger.debug "  #{count}/#{merchants.size} merchants created."
  Rails.logger.debug ''

  Rails.logger.debug "Processing file 'db/dataset/shoppers.json'"
  count = 0
  shoppers.each do |shopper|
    Shopper.create!(
      id: shopper['id'],
      name: shopper['name'],
      email: shopper['email'],
      nif: shopper['nif']
    )
    count += 1
  end
  Rails.logger.debug "  #{count}/#{shoppers.size} shoppers created."
  Rails.logger.debug ''

  Rails.logger.debug "Processing file 'db/dataset/orders.json'"
  count = 0
  orders.each do |order|
    Order.create!(
      merchant: Merchant.find(order['merchant_id']),
      shopper: Shopper.find(order['shopper_id']),
      amount: order['amount'],
      completed_at: [nil, Date.today - rand(10).days].sample
    )
    count += 1
  end
  Rails.logger.debug "  #{count}/#{orders.size} orders created."
end
