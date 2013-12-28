setPreviewImage = (watermarkfile) ->
  reader = new FileReader()
  newImage = new Image()
  reader.onload = (evt) ->
    newImage.src = evt.target.result
    $(".avatar-profile").attr("style", "background-image: url('" + evt.target.result + "'); background-postion: inherit;").fadeIn()
    $("#change-avatar-form").submit()
  reader.readAsDataURL watermarkfile

$(document).ready ->

  $(".content-container").removeClass "hide"
  $(".edit-password-container, .edit-profile-container").addClass "hide"

  $(".edit-form-link").bind "click", ->
    $(this).addClass "orange"
    $(".change-pass-form-link").removeClass "orange"
    $(".edit-profile-container").removeClass("hide").fadeIn "slow"
    $(".content-container, .edit-password-container").addClass "hide"

  $(".change-pass-form-link").bind "click", ->
    $(this).addClass "orange"
    $(".edit-form-link").removeClass "orange"
    $(".edit-profile-container, .content-container").addClass "hide"
    $(".edit-password-container").removeClass("hide").fadeIn "slow"

  $(".cancel-edit-profile").bind "click", ->
    $("#edit-profile-form").resetlocal
    $(".edit-form-link, .change-pass-form-link").removeClass "orange"
    $(".edit-profile-container, .edit-password-container").addClass "hide"
    $(".content-container").removeClass("hide").fadeIn "slow"

  $(".submit-edit-profile-link").click ->
    $(".submit-edit-profile").click()

  $(".submit-change-password-link").click ->
    $(".submit-change-password").click()

  $("#email-change-password").click ->
    $(".form-email-change-password").submit()

  $(".disconnect-facebook").click ->
    $(".image-disconnect-facebook").show().fadeIn "slow"

  $(".disconnect-google").click ->
    $(".image-disconnect-google").show().fadeIn "slow"

  $("#upload-avatar-profile").bind "change", (evt) ->
    evt.preventDefault()
    files = evt.target.files
    if files[0].size >= 10000000
      alert("File can't be more than 10 MB")
    else
      setPreviewImage files[0]

  $(".input-about").keyup ->
    max = 200
    len = $(this).val().length
    if len > max
      $(".text-max").text " you have reached the limit"
      $(".text-max").css("color", "red")
    else
      $(".text-max").text "Maximum Character: 200"
      char = max - len
      $(".text-remaining").text char
      $(".text-max").addClass("dark-grey")

  $(".input-about").blur ->
    $(".text-remaining").empty

  $(".input-new-password").keyup ->
    min = 8
    val = $(this).val()
    len = $(this).val().length
    if len < min
      $(".reject-character").removeClass("hide").fadeIn()
      $(".accept-character").addClass("hide").fadeIn()
    else
      $(".reject-character").addClass("hide").fadeIn()
      $(".accept-character").removeClass("hide").fadeIn()

    if val.match(/^(?=.*[a-zA-Z])(?=.*\d)/)
      $(".reject-number").addClass("hide").fadeIn()
      $(".accept-number").removeClass("hide").fadeIn()
    else
      $(".reject-number").removeClass("hide").fadeIn()
      $(".accept-number").addClass("hide").fadeIn()

    if val.match(/(?=.*[!@#$%^&*_+-><,.~`])/)
      $(".reject-symbol").addClass("hide").fadeIn()
      $(".accept-symbol").removeClass("hide").fadeIn()
    else
      $(".reject-symbol").removeClass("hide").fadeIn()
      $(".accept-symbol").addClass("hide").fadeIn()

    if val.length == 0
      $(".reject-number, .accept-number, .reject-character, .accept-character, .reject-symbol, .accept-symbol").addClass("hide").fadeIn()