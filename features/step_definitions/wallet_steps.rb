=begin
# This will use the User class (Admin would have been guessed)
FactoryGirl.define do
  factory :TestnetWallet, class: Hoova::LocalWallet do
    first_name "Admin"
    last_name "User"
    admin true
  end
end
=end

Given(/^A local testnet sweep wallet with a balance$/) do
  username = 'testnetu'
  password = 'testnetp'
  host = '127.0.0.1'
  port = 19001
  ssl = false

  @wallet = Hoova::BitcoinWallet.new(username, password, host, port, ssl)
end

Given(/^a destination bitcoin address of "(.*?)"$/) do |destination_address|
  @destination = Hoova::BitcoinAddress.new(destination_address)
end


Given(/^a local mock wallet with a balance of "(.*?)" and user "(.*?)" and pass "(.*?)"$/) do |balance, user, pass|
  @initial_wallet_balance = balance.to_f # TODO again better type cast than F?
  @wallet = Hoova::LocalWalletMock.new(user, pass)
  @wallet.balance = balance
end

Given(/^a destination bitcoin address of "(.*?)" with a balance of (\d+)$/) do |destination_address, balance|
  @destination = Hoova::BitcoinAddress.new(destination_address)
  @destination.balance = 0
end

When(/^I sweep the wallet to the destination address$/) do
  Hoova::Sweeper.new(@wallet, @destination).sweep_forever
end

Then(/^the wallet balance should be (\d+)$/) do |desired_wallet_balance|
  @wallet.balance.should == desired_wallet_balance.to_f
end

Then(/^the destination address balance should be "(.*?)"$/) do |desired_destination_balance|
  @destination.balance.should == desired_destination_balance.to_f
end
