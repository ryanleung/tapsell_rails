module ListingsHelper

	def categories
		["Books", "Apparel", "Electronics", "Home", "Tickets", "Other"]
	end

	def all
		@listings.paginate(:page => params[:page], :per_page => 20)
	end

	def books
		paginate_category("Books", 20)
	end

	def fashions
		paginate_category("Apparel", 20)
	end

	def electronics
		paginate_category("Electronics", 20)
	end

	def beauties
		paginate_category("Home", 20)
	end

	def home
		paginate_category("Tickets", 20)
	end

	def hobbies
		paginate_category("Other", 20)
	end

	def paginate_category(name, number)
		@listings.where(category: name).paginate(:page => params[:page], :per_page => number)
	end
end
