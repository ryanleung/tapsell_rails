
setPreviewImage = (watermarkfile, elem) ->
  reader = new FileReader()
  newImage = new Image()
  reader.onload = (evt) ->
    newImage.src = evt.target.result

  reader.readAsDataURL watermarkfile
  elem.find(".product-live-view-image").html newImage

$(document).ready ->
  # $("#product_address").geocomplete
  #   details: "form"
  #   map: ".map_canvas"
  #   location: "SF"
  #   mapOptions:
  #     zoom: 100
  #   markerOptions:
  #     draggable: true

  $("#product_images_attributes_0_file").bind "change", (evt) ->
    evt.preventDefault()
    files = evt.target.files
    setPreviewImage files[0], $(this).parent().parent()

  $("#tasks").on "cocoon:after-insert", (e, added_task) ->
    added_task.bind "change", (evt) ->
      console.log $(this)
      evt.preventDefault()
      files = evt.target.files
      if files[0].size >= 10000000
        alert("File can't be more than 10 MB")
      else
        setPreviewImage files[0], $(this)

  $("#sort").bind "change", ->
    $.ajax
      url: "#{sorting_product_url}"
      data:
        sort: $(this).val()

  $(".carousel").carousel ->
    interval: 0

  $(".product-price").numeric
    decimal: false
    negative: false
  , ->
    alert "Positive integers only"
    @value = ""
    @focus()

  $(".craigslist-link").click ->
    $(this).addClass "hide"
    $(".craigslist-active").removeClass "hide"
    $(".check-craigslist").removeClass "hide"

  $(".craigslist-active").click ->
    $(this).addClass "hide"
    $(".craigslist-link").removeClass "hide"
    $(".check-craigslist").addClass "hide"

  $(".facebook-link").click ->
    $(this).addClass "hide"
    $(".facebook-active").removeClass "hide"
    $(".check-facebook-group").removeClass "hide"

  $(".facebook-active").click ->
    $(this).addClass "hide"
    $(".facebook-link").removeClass "hide"
    $(".check-facebook-group").addClass "hide"

  $(".facebook-timeline-link").click ->
    $(this).addClass "hide"
    $(".facebook-timeline-active").removeClass "hide"
    $(".check-facebook-timeline").removeClass "hide"

  $(".facebook-timeline-active").click ->
    $(this).addClass "hide"
    $(".facebook-timeline-link").removeClass "hide"
    $(".check-facebook-timeline").addClass "hide"

