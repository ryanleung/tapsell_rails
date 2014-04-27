namespace :load_db do

	desc "load users and listings into database"
	task :load_fake_data => :environment do
		u1 = User.create(first_name: "ryan", last_name: "wtf", password: "supdawggggg", email: "wtfff@wtf.com", location: "san diego, ca")
		u2 = User.create(first_name: "giovanni", last_name: "wong", password: "mangwtf", email: "hellobaby@hello.com", location: "compton")
		u3 = User.create(first_name: "dru", last_name: "nelson", password: "popcorn", email: "druis@lwaysright.com", location: "queens")
		u4 = User.create(first_name: "vvo", last_name: "vvizzle", password: "BAGS123123", email: "vvoizcute@vvo.com", location: "bronx")
		u5 = User.create(first_name: "jacq", last_name: "yacq", password: "yackingjacq", email: "iluvsd@sandiego.com", location: "oakland")

		Listing.create(title: "macbook", seller: u1, price: 30)
		Listing.create(title: "golden state warriors poster", seller: u2, price: 40)
		Listing.create(title: "popcorn", seller: u3, price: 10)
		Listing.create(title: "batman mask", seller: u4, price: 20)
		Listing.create(title: "paintbrush", seller: u5, price: 30)

		Address.create(street_address: "14 BLajblaj Dr.", locality: "Fremont", region: "CA", postal_code: "94111")
		Address.create(street_address: "15 qwerty Dr.", locality: "Newark", region: "CA", postal_code: "94111")

		CreditCard.create_cc(User.find(1), "4242424242424242", 05, 2018, 678)
		CreditCard.create_cc(User.find(2), "4012888888881881", 8, 2018, 678)

		MessageChain.send_message(User.find_by_email("wtfff@wtf.com").id, Listing.last.id, "hello there", nil, nil, nil)
		MessageChain.send_message(User.last.id, Listing.find(1).id, "whatsup", nil, nil, nil)

	end
end