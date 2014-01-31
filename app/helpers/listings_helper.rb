module ListingsHelper

	def all
		@listings.paginate(:page => params[:page], :per_page => 20)
	end

	def books
		paginate_category("book", 20)
	end

	def fashions
		paginate_category("apparel_fashion", 20)
	end

	def electronics
		paginate_category("electronic", 20)
	end

	def beauties
		paginate_category("healthy_beauty", 20)
	end

	def home
		paginate_category("home", 20)
	end

	def hobbies
		paginate_category("interest_hobby", 20)
	end

	def paginate_category(name, number)
		@listings.where(category: name).paginate(:page => params[:page], :per_page => number)
	end
end
