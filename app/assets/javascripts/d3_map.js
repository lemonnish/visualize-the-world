// define all the functions used to load a D3 map

// this value needs to be defined within the page body
var mapContents = [];

function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min)) + min;
}

function randomColor(numColors) {
  var colorFunction = d3.scaleSequential(
      d3.interpolateHcl(d3.hcl(150,90,50), d3.hcl(120,80,90)))
    .domain([0, numColors]);
  return colorFunction(getRandomInt(0, numColors));
}

function toggleDisplayedCountry(id) {
  var old_selected = d3.selectAll('.countrySelected');
  var new_selected = d3.selectAll('#label-country-' + id +
                                  ', #country-' + id +
                                  ', #content-country-' + id );
  new_selected.classed('countrySelected', function(d) {
    return !d3.select(this).classed('countrySelected')
  });
  old_selected.classed('countrySelected', false);
  if(d3.select('.countrySelected').empty()) {
    d3.select('#labelDefault').classed('countrySelected', true);
  }
}

function isInContent(id) {
  return (mapContents.indexOf(id) != -1);
}

function updateProjection(inputSVG, projection) {
    viewBox = inputSVG.attr('viewBox').toString().split(' ');
    width = +viewBox[2] - 4;
    height = +viewBox[3] - 4;

    projection.fitSize([width, height], { type: "Sphere" });

    var geoPath = d3.geoPath()
      .projection(projection);

    inputSVG.selectAll('path')
        .attr('d', geoPath);
}

function drawMap(inputSVG, world,
                 borders,
                 drawCountries) {
    // draw the world map SVG
    //    - the SVG must have an ID
    // borders = "country" / "land" / false
    // drawCountries = true (draw indiv countries) / false (draw land masses)
    //    - value is ignored if inputSVG doesn't have class ".simple"
    var countries = topojson.feature(world, world.objects.countries);
    var countryBorders = topojson.mesh(world, world.objects.countries);
    var land = topojson.feature(world, world.objects.land);
    var landBorders = topojson.mesh(world, world.objects.land);

    var clipName = inputSVG.attr('id') + "_clip";
    var sphereName = inputSVG.attr('id') + "_sphere";
    var sphereID = "#" + sphereName
    var clipID = "#" + clipName
    var clipUrl = "url(#" + clipName + ")";

    var landGroup = inputSVG.select('g');

    if (landGroup.empty()) {
      landGroup = inputSVG.append('g')
          .attr("class", "land");
    }

    if (inputSVG.select('defs').empty()) {
      var defs = inputSVG.insert("defs", 'g');

      defs.append("path")
          .datum({ type: "Sphere" })
          .attr("id", sphereName);

      defs.append("clipPath")
          .attr("id", clipName)
        .append("use")
          .attr("xlink:href", sphereID);
    }

    if (inputSVG.select('use.map-background').empty()) {
      inputSVG.insert("use", 'g')
          .attr("xlink:href", sphereID)
          .attr("class", "map-background");
    }

    if (inputSVG.select('path.map-graticule').empty()) {
      inputSVG.insert('path', 'g')
          .datum(d3.geoGraticule())
          .attr("class", "map-graticule")
          .attr("clip-path", clipUrl);
    }

    if (inputSVG.classed("simple")) { // draw non-interactive map
      if (drawCountries) { // draw countries, fill with a random color
        landGroup.selectAll('path.map-country')
            .data(countries.features)
          .enter().append("path")
            .classed("map-country", true)
            .attr("clip-path", clipUrl)
            .attr("fill", function(d) { return randomColor(10); } );
      } else {  // draw land
        landGroup.selectAll('path.map-land')
            .data(land.features)
          .enter().append("path")
            .attr("class", "map-land")
            .attr("clip-path", clipUrl)
            .attr("fill", d3.hcl(150,90,50));
      }
    } else {  // draw interactive countries
      landGroup.selectAll('path.map-country')
          .data(countries.features)
        .enter().append("path")
          .attr("clip-path", clipUrl)
          .classed("map-country", true)
          .classed("map-content", function(d) { return isInContent(d.id) } )
          .attr("id", function(d) { return "country-" + d.id; })
          .on("click", function(d) { toggleDisplayedCountry(d.id) });
    }

    if ((borders == "country") &
        inputSVG.selectAll('path.border-country').empty()) {
      inputSVG.append('path')
          .datum(countryBorders)
          .classed("map-borders", true)
          .classed("border-country", true)
          .attr("clip-path", clipUrl);
    }

    if ((borders == "land") &
        inputSVG.selectAll('path.border-land').empty()) {
      inputSVG.append('path')
          .datum(landBorders)
          .attr("class", "map-borders border-land")
          .attr("clip-path", clipUrl);
    }

    if (inputSVG.select('use.map-borders').empty()) {
      inputSVG.append("use")
          .attr("xlink:href", sphereID)
          .attr("class", "map-borders");
    }
}
