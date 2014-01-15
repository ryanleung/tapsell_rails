$(document).ready ->
  $(".purchase-singin").click ->
    $(".purchase-signin-form").removeClass("hide").fadeIn()
    $(".purchase-signup-form").addClass("hide").fadeOut()

  $(".purchase-singup").click ->
    $(".purchase-signup-form").removeClass("hide").fadeIn()
    $(".purchase-signin-form").addClass("hide").fadeOut()

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

  $(".purchase-singin").on "click", ->
    $(".purchase-signin-container").fadeIn("slow").removeClass "hide"
    $(".sign-in-footer").fadeIn("slow").removeClass "hide"
    $(".purchase-signup-container").fadeOut("slow").addClass "hide"
    $(".sign-up-footer").fadeOut("slow").addClass "hide"

  $(".purchase-singup").on "click", ->
    $(".purchase-signup-container").fadeIn("slow").removeClass "hide"
    $(".sign-up-footer").fadeIn("slow").removeClass "hide"
    $(".purchase-signin-container").fadeOut("slow").addClass "hide"
    $(".sign-in-footer").fadeOut("slow").addClass "hide"

