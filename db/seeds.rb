User.create!(email: "map@laurennishizaki.com",
             password:              "foobar",
             password_confirmation: "foobar")

user = User.find_by(email: "map@laurennishizaki.com")

example_blurb = "This is an example map. Try clicking on the map to learn about
  different countries, and toggle the type of map projection. Countries that
  have been added to the map (see \"Map content\" below) appear in teal on the
  map; any clicked-on country is displayed in orange."

user.maps.create(title: "Example Map",
                 blurb: example_blurb,
                 projection: "geoPolyhedralButterfly",
                 example_map: true,
                 privacy_public: true)

map = Map.find_by(example_map: true)

map.map_contents.create(country_code: "ca",
  comment: "How about that Justin Trudeau, eh?")
map.map_contents.create(country_code: "cl",
  comment: "Chile is a long and skinny country, tucked between the Pacific Ocean
    and the towering Andes mountain range. At the north is the Atacama Desert,
    the driest desert in the world. At the southern tip is Patagonia, known for
    its glacial national parks. And in the middle is the capitol, Santiago, with
    a climate that supports myriad wineries.")
map.map_contents.create(country_code: "cn",
  comment: "Shanghai is a bustling city. As of 2017, its population of over 24
    million residents makes it the most populous city in the world (ranked by
    populations of the city proper). Its financial district is home to towering
    skyscrapers that put on light shows over the Huangpu River.")
map.map_contents.create(country_code: "de",
  comment: "After WWII, the country was eventually divided into two halves, West
    Germany (democratic and capitalistic) and East Germany (socialist). Although
    Berlin fell within the area controlled by East Germany, control of the city
    was split between the two governments. As a result, there are still remnants
    of that divide, even 29 years after the fall of the Berlin Wall.")
map.map_contents.create(country_code: "kh",
  comment: "The tourism industry here is quickly growing. Angkor Wat, near the
    town of Siem Reap, attracts millions of people each year, and that number
    seems to be increasing exponentially. However, it doesn't take much to
    escape the crowds. Battambang is only a couple hours away by bus, and is
    home to a burgeoning art community and charming cafes and restaurants.")
map.map_contents.create(country_code: "vn",
  comment: "3 months in Vietnam is not nearly enough time to see everything
    there is to see. This is especially true if you have a motorcycle that
    allows you to get off the beaten path, visit remote locations, and travel at
    your own pace.")
