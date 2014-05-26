$(document).ready ->
	dimHeight = $(".user-setting-content-container").height()
	$(".coming-soon-dim").height(dimHeight - 39)


	$(".routing-number, .account-number").numeric
	  decimal: false
	  negative: false
	, ->
	  alert "Positive integers only"
	  @value = ""
	  @focus()

	$(".submit-credit-card-link").click ->
		$(".submit-credit-card").click()

	$(".cancel-credit-card").click ->
		$("#reset-credit-card-form").click()

	$(".making-payment").click ->
		$(this).addClass "orange"
		$(".receiving-payment").removeClass "orange"
		$(".making-payment-container").fadeIn("slow").removeClass "hide"
		$(".receiving-payment-container").fadeOut("slow").addClass "hide"

	$(".receiving-payment").click ->
		$(this).addClass "orange"
		$(".making-payment").removeClass "orange"
		$(".receiving-payment-container").fadeIn("slow").removeClass "hide"
		$(".making-payment-container").fadeOut("slow").addClass "hide"

	$(".choose-method").change ->
		if $(this).val() == "Check"
			$(".check-container").fadeIn("slow").removeClass "hide"
			$(".bank-account-container").fadeOut("slow").addClass "hide"
		else
			$(".bank-account-container").fadeIn("slow").removeClass "hide"
			$(".check-container").fadeOut("slow").addClass "hide"