class @PageInfoBoxBuilder extends Gmaps.Google.Builders.Marker # inherit from base builder
  # override method
  create_infowindow: ->
    return null unless _.isString @args.infowindow
    boxText = document.createElement("div")
    boxText.setAttribute('class', 'page-marker-container') #to customize
    boxText.innerHTML = @args.infowindow
    @infowindow = new InfoBox(@infobox(boxText))

# add @bind_infowindow() for < 2.1

  infobox: (boxText)->
    content: boxText
    pixelOffset: new google.maps.Size(-225, 150)
    boxStyle: {
      maxWidth: "400px",
      maxHeight: "275px",
      overflow: "auto",
      backgroundColor: "white",
      paddingBottom: "52px"
    }
    alignBottom: true
