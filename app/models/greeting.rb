class Greeting < ActiveRecord::Base

  def self.random_greeting
    if Greeting.count != 0
      Greeting.all.sample.greeting_body
    else
      return "Hello there, happy #{Date.today.strftime("%A")}"
    end
  end

end
