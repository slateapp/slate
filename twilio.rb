require 'rubygems'
require 'twilio-ruby'
 
account_sid = "AC441c582d96e200544d66d83954953feb"
auth_token = "523ca7f1e7222606b0ef63405561a8ee"
client = Twilio::REST::Client.new account_sid, auth_token
 
from = "+441784603115" # Your Twilio number
 
teachers = {
"+4407580314070" => "Sarah",
}


teachers.each do |key, value|
  client.account.messages.create(
    :from => from,
    :to => key,
    :body => "Hey #{value}, there's a new request!"
  ) 
  puts "Sent message to #{value}"
end
