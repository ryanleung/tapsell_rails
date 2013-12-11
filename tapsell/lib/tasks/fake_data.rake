namespace :load_db do

	desc "load users and listings into database"
	task :load_users_listings => :environment do
		u1 = User.create(first_name: "ryan", last_name: "wtf", password: "supdawggggg", email: "wtfff@wtf.com")
		u2 = User.create(first_name: "giovanni", last_name: "wong", password: "mangwtf", email: "hellobaby@hello.com")
		u3 = User.create(first_name: "dru", last_name: "nelson", password: "popcorn", email: "druis@lwaysright.com")
		u4 = User.create(first_name: "vvo", last_name: "vvizzle", password: "BAGS123123", email: "vvoizcute@vvo.com")
		u5 = User.create(first_name: "jacq", last_name: "yacq", password: "yackingjacq", email: "iluvsd@sandiego.com")

		Listing.create(title: "macbook", seller: u1)
		Listing.create(title: "golden state warriors poster", seller: u2)
		Listing.create(title: "popcorn", seller: u3)
		Listing.create(title: "batman mask", seller: u4)
		Listing.create(title: "paintbrush", seller: u5)
	end
end