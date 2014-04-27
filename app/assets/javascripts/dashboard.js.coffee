setPreviewImage = (watermarkfile, elem) ->
  reader = new FileReader()
  newImage = new Image()
  reader.onload = (evt) ->
    newImage.src = evt.target.result

  reader.readAsDataURL watermarkfile
  elem.parent().html newImage

$(document).ready ->
	$("#image").bind "change", (evt) ->
    evt.preventDefault()
    files = evt.target.files
    setPreviewImage files[0], $(this).addClass("img-circle").appendTo(".profile-live-view-image")
    $(".submit-photo-container").removeClass("hide").fadeIn "normal"

  $(".link-upload-image").click ->
  	$(".input-photo").click()

