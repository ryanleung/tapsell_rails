$(document).ready ->
  $(".purchase-signin").click ->
    $(".purchase-signin-container").addClass "purchase-signin-container-show"
    $(".purchase-signup-container").addClass "purchase-signup-container-hide"
    $(".sign-up-footer").addClass "sign-up-footer-hide"
    $(".sign-in-footer").addClass "sign-in-footer-show"

  $(".purchase-signup").click ->
    $(".purchase-signin-container").removeClass "purchase-signin-container-show"
    $(".purchase-signup-container").removeClass "purchase-signup-container-hide"
    $(".sign-up-footer").removeClass "sign-up-footer-hide"
    $(".sign-in-footer").removeClass "sign-in-footer-show"


  $(".security-number, .card-number, .house-number, .billing-zipcode").numeric
    decimal: false
    negative: false

  $(".add-new-credit-card").click ->
    $(this).fadeOut("slow").addClass "hide"
    $(".insert-credit-card-container").fadeIn("slow").removeClass "hide"
    $(".cancel-add-credit-card").fadeIn("slow").removeClass "hide"

  $(".cancel-add-credit-card").on "click", ->
    $(this).fadeOut("slow").addClass "hide"
    $(".insert-credit-card-container").fadeOut("slow").addClass "hide"
    $(".add-new-credit-card").fadeIn("slow").removeClass "hide"



