$(document).ready ->
  $(".message-item-container").scrollTop($(".message-item-container")[0].scrollHeight)

  $(".message-user-list").click ->
    $(".message-item-container").scrollTop($(".message-item-container")[0].scrollHeight)