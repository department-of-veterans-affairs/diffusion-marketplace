class @VisnVaFacilityInfoBoxBuilder extends Gmaps.Google.Builders.Marker # inherit from base builder
  # override method
  create_infowindow: ->
    return null unless _.isString @args.infowindow

    boxText = document.createElement("div")
    boxText.setAttribute('class', 'visn-va-facility-marker-container radius-md bg-white') #to customize
    boxText.innerHTML = @args.infowindow
    @visn_va_facility_infowindow = new InfoBox(@infobox(boxText))

# add @bind_infowindow() for < 2.1

  infobox: (boxText)->
    content: boxText
    pixelOffset: new google.maps.Size(-265, -55)
    boxStyle:
      width: "243px"
      height: "89px"