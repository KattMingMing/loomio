$ ->
  $.ajax
    url: detect_video_locale_url
    success: (data) ->
      alert("hi from data: #{data}")
    dataType: 'html'
