class @VisnInfoBoxBuilder extends Gmaps.Google.Builders.Marker # inherit from base builder
  # override method
  create_infowindow: ->
    return null unless _.isString @args.infowindow

    boxText = document.createElement("div")
    boxText.setAttribute('class', 'visn-marker-container radius-md bg-white') #to customize
    boxText.innerHTML = @args.infowindow
    @visn_infowindow = new InfoBox(@infobox(boxText))

# add @bind_infowindow() for < 2.1

  infobox: (boxText)->
    content: boxText
    pixelOffset: new google.maps.Size(-310, -70)
    boxStyle:
      width: "238px"
      height: "180px"