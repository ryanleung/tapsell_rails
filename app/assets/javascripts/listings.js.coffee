$(document).ready ->
	# $("#container-listing").mixitup
	# 	effects: [null],
	# 	animateGridList: true,
	# 	sortSelector: '.sort'

	$(".pagination ul").addClass "pagination"

	$(".filter-category").click ->
		$("#loader-container").removeClass "hide"

	$(".all-link").click ->
		$(".all-items").addClass "active"
		$(".book-items, .apparel-items, .electronic-items, .home-items, .ticket-items, .other-items").removeClass "active"
		$("#all-paginate").removeClass "hide"
		$("#book-paginate, #fashion-paginate, #electronic-paginate, #beauty-paginate, #home-paginate, #hobbies-paginate ").addClass "hide"
		$(".newest").addClass "active"
		$(".oldest, .low-price, .high-price").removeClass "active"

	$(".book-link").click ->
		$(".book-items").addClass "active"
		$(".all-items, .apparel-items, .electronic-items, .home-items, .ticket-items, .other-items").removeClass "active"
		$("#book-paginate").removeClass "hide"
		$("#all-paginate, #fashion-paginate, #electronic-paginate, #beauty-paginate, #home-paginate, #hobbies-paginate ").addClass "hide"
		$(".newest").addClass "active"
		$(".oldest, .low-price, .high-price").removeClass "active"

	$(".apparel-link").click ->
		$(".apparel-items").addClass "active"
		$(".book-items, .all-items, .electronic-items, .home-items, .ticket-items, .other-items").removeClass "active"
		$("#fashion-paginate").removeClass "hide"
		$("#all-paginate, #book-paginate, #electronic-paginate, #beauty-paginate, #home-paginate, #hobbies-paginate ").addClass "hide"
		$(".newest").addClass "active"
		$(".oldest, .low-price, .high-price").removeClass "active"

	$(".electronic-link").click ->
		$(".electronic-items").addClass "active"
		$(".book-items, .apparel-items, .all-items, .home-items, .ticket-items, .other-items").removeClass "active"
		$("#electronic-paginate").removeClass "hide"
		$("#all-paginate, #book-paginate, #fashion-paginate, #beauty-paginate, #home-paginate, #hobbies-paginate ").addClass "hide"
		$(".newest").addClass "active"
		$(".oldest, .low-price, .high-price").removeClass "active"

	$(".home-link").click ->
		$(".home-items").addClass "active"
		$(".book-items, .apparel-items, .electronic-items, .all-items, .ticket-items, .other-items").removeClass "active"
		$("#beauty-paginate").removeClass "hide"
		$("#all-paginate, #book-paginate, #electronic-paginate, #fashion-paginate, #home-paginate, #hobbies-paginate ").addClass "hide"
		$(".newest").addClass "active"
		$(".oldest, .low-price, .high-price").removeClass "active"

	$(".ticket-link").click ->
		$(".ticket-items").addClass "active"
		$(".book-items, .apparel-items, .electronic-items, .home-items, .all-items, .other-items").removeClass "active"
		$("#home-paginate").removeClass "hide"
		$("#all-paginate, #book-paginate, #electronic-paginate, #fashion-paginate, #beauty-paginate, #hobbies-paginate ").addClass "hide"
		$(".newest").addClass "active"
		$(".oldest, .low-price, .high-price").removeClass "active"

	$(".other-link").click ->
		$(".other-items").addClass "active"
		$(".book-items, .apparel-items, .electronic-items, .home-items, .ticket-items, .all-items").removeClass "active"
		$("#hobbies-paginate").removeClass "hide"
		$("#all-paginate, #book-paginate, #electronic-paginate, #fashion-paginate, #beauty-paginate, #home-paginate ").addClass "hide"
		$(".newest").addClass "active"
		$(".oldest, .low-price, .high-price").removeClass "active"

	$(".newest-link").click ->
		$(".newest").addClass "active"
		$(".oldest, .low-price, .high-price").removeClass "active"
		$(".all-items").addClass "active"
		$(".book-items, .apparel-items, .electronic-items, .home-items, .ticket-items, .other-items").removeClass "active"
		$("#all-paginate").removeClass "hide"
		$("#book-paginate, #fashion-paginate, #electronic-paginate, #beauty-paginate, #home-paginate, #hobbies-paginate ").addClass "hide"

	$(".oldest-link").click ->
		$(".oldest").addClass "active"
		$(".newest, .low-price, .high-price").removeClass "active"
		$(".all-items").addClass "active"
		$(".book-items, .apparel-items, .electronic-items, .home-items, .ticket-items, .other-items").removeClass "active"
		$("#all-paginate").removeClass "hide"
		$("#book-paginate, #fashion-paginate, #electronic-paginate, #beauty-paginate, #home-paginate, #hobbies-paginate ").addClass "hide"

	$(".low-price-link").click ->
		$(".low-price").addClass "active"
		$(".oldest, .newest, .high-price").removeClass "active"
		$("#loader-container").addClass "hide"
		$(".listing-item").tsort
		  attr: "data-price"
		  order: "asc"

	$(".high-price-link").click ->
		$(".high-price").addClass "active"
		$(".oldest, .newest, .low-price").removeClass "active"
		$("#loader-container").addClass "hide"
		$(".listing-item").tsort
		  attr: "data-price"
		  order: "desc"
