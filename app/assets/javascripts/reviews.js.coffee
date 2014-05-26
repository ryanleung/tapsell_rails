$(document).ready ->
	$(".thumb-up").click ->
		$(this).addClass "hide"
		$(".thumb-down").removeClass "hide"
		$(".thumb-down-active").addClass "hide"
		$(".thumb-up-active").removeClass "hide"

	$(".thumb-up-active").click ->
		$(this).addClass "hide"
		$(".thumb-down").removeClass "hide"
		$(".thumb-down-active").addClass "hide"
		$(".thumb-up").removeClass "hide"

	$(".thumb-down").click ->
		$(this).addClass "hide"
		$(".thumb-up").removeClass "hide"
		$(".thumb-up-active").addClass "hide"
		$(".thumb-down-active").removeClass "hide"

	$(".thumb-down-active").click ->
		$(this).addClass "hide"
		$(".thumb-up").removeClass "hide"
		$(".thumb-up-active").addClass "hide"
		$(".thumb-down").removeClass "hide"
