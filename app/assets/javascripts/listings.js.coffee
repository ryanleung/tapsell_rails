$(document).ready ->
	$("#container-listing").mixitup
		effects: [null],
		animateGridList: true

	$(".pagination ul").addClass "pagination"

	$(".all-link").click ->
		$("#all-paginate").removeClass "hide"
		$("#book-paginate, #fashion-paginate, #electronic-paginate, #beauty-paginate, #home-paginate, #hobbies-paginate ").addClass "hide"

	$(".book-link").click ->
		$("#book-paginate").removeClass "hide"
		$("#all-paginate, #fashion-paginate, #electronic-paginate, #beauty-paginate, #home-paginate, #hobbies-paginate ").addClass "hide"

	$(".fashion-link").click ->
		$("#fashion-paginate").removeClass "hide"
		$("#all-paginate, #book-paginate, #electronic-paginate, #beauty-paginate, #home-paginate, #hobbies-paginate ").addClass "hide"

	$(".electronic-link").click ->
		$("#electronic-paginate").removeClass "hide"
		$("#all-paginate, #book-paginate, #fashion-paginate, #beauty-paginate, #home-paginate, #hobbies-paginate ").addClass "hide"

	$(".beauty-link").click ->
		$("#beauty-paginate").removeClass "hide"
		$("#all-paginate, #book-paginate, #electronic-paginate, #fashion-paginate, #home-paginate, #hobbies-paginate ").addClass "hide"

	$(".home-link").click ->
		$("#home-paginate").removeClass "hide"
		$("#all-paginate, #book-paginate, #electronic-paginate, #fashion-paginate, #beauty-paginate, #hobbies-paginate ").addClass "hide"

	$(".hobby-link").click ->
		$("#hobbies-paginate").removeClass "hide"
		$("#all-paginate, #book-paginate, #electronic-paginate, #fashion-paginate, #beauty-paginate, #home-paginate ").addClass "hide"
