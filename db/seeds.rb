# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "json"
require "httparty"

Viewing.delete_all
PlaceTag.delete_all
Tag.delete_all
Place.delete_all


response = HTTParty.get('https://dev.ofdb.io/v0/search?bbox=42.27,-7.97,52.58,38.25&limit=2000')
response = JSON.parse(response.body)
places = response["visible"]
berlin_places = places.select do |place|
  lat_condition = place["lat"] > 52.00 && place["lat"] < 52.99
  lng_condition = place["lng"] > 13.00 && place["lng"] < 13.99
  lat_condition && lng_condition
end

berlin_places.each do |place|
  response = HTTParty.get("https://api.ofdb.io/v0/entries/#{place['id']}")
  place = JSON.parse(response.body).first
  place_tags = place["tags"]
  new_place = Place.create!(
    name: place["title"],
    lat: place["lat"],
    lng: place["lng"],
    description: place["description"],
    email: place["email"],
    telephone_number: place["telephone"],
    website_url: place["homepage"],
    image_url: place["image_url"],
    recommended: [true, false].sample
  )
  puts "Place: '#{new_place.name}' has been created"
  puts "Assigning tags"
  place_tags.each do |tag|
    tag = tag.gsub("-", " ")
    tag = tag.capitalize
    tag = Tag.find_or_create_by(name: tag)
    PlaceTag.create!(place: new_place, tag: tag)
    puts "Tag: '#{tag.name}' has been created and assigned to '#{new_place.name}'"
  end
end

# puts ""
# puts ""
# puts ""
# puts ""
# puts ""

# puts "Congrats, you now have #{Place.count} places and #{Tag.count} tags"
# validates :name, presence: true, uniqueness: true
# # Acordate de poner un random value en recommended
# validates :lat, presence: true, uniqueness: true
# validates :lng, presence: true, uniqueness: true
# validates :description, presence: true



images = {
"StadtFarm": "https://www.berlin.de/binaries/asset/image_assets/5731349/ratio_4_3/1604306948/800x600/",
"Open Source Ecology Germany": "https://blog.opensourceecology.de/wp-content/uploads/2021/03/OSEG_logo.png",
"NaturFreunde Berlin e. V.": "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=874&q=80",
"Fairmondo eG": "https://images.unsplash.com/photo-1522204523234-8729aa6e3d5f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
"Quartiermeister – Bier für den Kiez": "https://www.google.de/imgres?imgurl=https%3A%2F%2Fgruene-startups.de%2Fwp-content%2Fuploads%2F2018%2F08%2Fqm_crowdfunding_flaschen.jpg&imgrefurl=https%3A%2F%2Fgruene-startups.de%2Fquartiermeister-bier-trinken-und-gutes-tun%2F&tbnid=EW55IcnnYSbBjM&vet=12ahUKEwicj6a6is_yAhUGGewKHT6bB0UQMygGegUIARCnAQ..i&docid=P5WXC5jJeX9IKM&w=1200&h=800&q=Quartiermeister%20%E2%80%93%20Bier%20f%C3%BCr%20den%20Kiez&ved=2ahUKEwicj6a6is_yAhUGGewKHT6bB0UQMygGegUIARCnAQ",
"Eco City – International Campus Wünsdorf": "https://images.unsplash.com/photo-1573487750369-2fcb245a373f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=328&q=80",
"RESTLOS GLÜCKLICH e.V.": "https://www.restlos-gluecklich.berlin/wp-content/uploads/2019/12/2019-12-10-Restlos-Gl%C3%BCcklich-zusammen-isst-man-besser_073.jpg",
"Adolf-Hoops-Gesellschaft mbH": "https://images.unsplash.com/photo-1543505298-b8be9b52a21a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=750&q=80",
"Märkisches Landbrot": "https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80",
"Förderkreis Biozyklisch-Veganer Anbau e.V.": "https://images.unsplash.com/photo-1603297427541-ed9aed6f0dbd?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8dmVnYW5pc218ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
"Ormado Kaffeehaus": "https://images.unsplash.com/photo-1522551458619-a2427b661528?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
"CHARLE - sustainable kids fashion": "https://images.unsplash.com/photo-1560859259-fcf2b952aed8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
"SV-Bildungswerk e.V.": "https://images.unsplash.com/photo-1596496050755-c923e73e42e1?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=736&q=80",
" VIER-bei-mir - Ambulante Pflege": "https://images.unsplash.com/photo-1547082688-9077fe60b8f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=889&q=80",
"Original Unverpackt": "https://images.unsplash.com/photo-1580368185100-5347908688ab?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
"Rabenhaus e.V.": "https://www.rabenhaus.de/wp-content/uploads/2019/01/RH-Logo_Name-innen-434x600.jpg",
"Kietz Klub Köpenick": "https://images.unsplash.com/photo-1540479859555-17af45c78602?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
"Offenes Wohnzimmer": "https://images.unsplash.com/photo-1484101403633-562f891dc89a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=753&q=80",
"BUNDJugend Bund für Umwelt und Naturschutz e.V.": "https://tse4.mm.bing.net/th?id=OIP.5T_0Fnryc3QJp5eE-qGTGwHaEK&pid=Api",
"Café der Fragen": "data:image/png;base64,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",
"ecobasa.org": "https://images.unsplash.com/photo-1615811361523-6bd03d7748e7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=668&q=80",
"Kiez.Rebellen": "https://images.unsplash.com/photo-1568994105244-51e2467a98fd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=678&q=80",
"fLotte Dörte": "https://images.unsplash.com/photo-1601067095185-b8b73ad7db10?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1481&q=80",
"denn's Biomarkt": "https://www.google.de/imgres?imgurl=https%3A%2F%2Fwww.eastsidemall.de%2Fuploads%2Fcmgshops%2Fshops%2Fstore%2F23.jpg&imgrefurl=https%3A%2F%2Fwww.eastsidemall.de%2Fde%2Fshops%2F23%2F9%2FDenns-Biomarkt&tbnid=Lzl0q7x7Fp7wdM&vet=10CAsQxiAoAWoXChMIiOX2xbTP8gIVAAAAAB0AAAAAEAY..i&docid=mhiKA8QUq1N-XM&w=1920&h=1200&itg=1&q=denns%20berlin&hl=de&ved=0CAsQxiAoAWoXChMIiOX2xbTP8gIVAAAAAB0AAAAAEAY",
"Seebrücke": "https://cloud.seebruecke.org/apps/files_sharing/publicpreview/mT3n8wLrmXFf7BL?fileId=270827&file=/neuesLogo_orange/SBLogo_500x250_orange_Zeichenfl%C3%A4che%201%20Kopie.png&x=1366&y=768&a=true",
"fLotter Erwin": "https://images.unsplash.com/photo-1601067095185-b8b73ad7db10?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1481&q=80",
"Jugendhaus Mstreet": "https://images.unsplash.com/photo-1600821986515-3ef5b0f29f39?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=664&q=80",
"UnternehmensGrün e.V.": "https://images.unsplash.com/photo-1543438853-44384304da21?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=889&q=80",
"Regenbogenfabrik Block 109 e.V.": "https://images.unsplash.com/photo-1543438853-44384304da21?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=889&q=80",
"Gabenzaun Weissensee": "https://ze.tt/wp-content/uploads/2017/02/gabenzaun1.jpg",
"ImagineCargo UG": "https://images.unsplash.com/photo-1476631840528-13bdc7f18072?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=752&q=80",
"Good Impact  c/o Impact Partner GmbH": "https://images.unsplash.com/photo-1519389950473-47ba0277781c?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",
"Dark Horse GmbH": "data:image/png;base64,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",
"Flüchtlingshilfe Babelsberg e.V.": "https://images.unsplash.com/photo-1594841355095-17ebe26d5f6b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
"TheDive": "https://images.unsplash.com/photo-1578103546508-3880c89f0511?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=751&q=80",
"Gemeinwohl-Bioladen": ""
"Your Little Planet - Die Initiative": "https://images.unsplash.com/photo-1598115746104-1a00ed9ca937?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1502&q=80",
"BIO COMPANY GmbH Filiale Kladower Damm": "data:image/png;base64,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",
"IGG MALZFABRIK mbH": "https://images.unsplash.com/photo-1542835497-a6813df96ed9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=751&q=80",
"Trinkbrunnen": "https://images.unsplash.com/photo-1560411283-c9b2dfc0d6d1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80",
"Teikei Coffee Gemeinschaft Wedding": "data:image/png;base64,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",
"Mehr Demokratie e.V.": "https://images.unsplash.com/photo-1616992249349-0758569bb13c?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzF8fGRlbW9jcmFjeXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
"Kunst-stoffe neukölln-materialannahme& -verkauf": "https://images.unsplash.com/photo-1602706294170-1fed8eecd9f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
"World Wide Fund": "https://images.unsplash.com/flagged/photo-1576045771676-7ac070c1ce72?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
"fLotte Otti": "https://images.unsplash.com/photo-1601067095185-b8b73ad7db10?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1481&q=80",
"fLotter Johannes": "https://images.unsplash.com/photo-1601067095185-b8b73ad7db10?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1481&q=80",
"fLottes Paulchen": "https://images.unsplash.com/photo-1601067095185-b8b73ad7db10?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1481&q=80",
"Samadhi indisches Restaurant": "https://images.unsplash.com/photo-1596797038530-2c107229654b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=375&q=80",
 "FUTURZWEI. Stiftung Zukunftsfähigkeit\u2028": "https://images.unsplash.com/photo-1603573355706-3f15d98cf100?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1488&q=80",
 
 "Bio Konditorei Tillmann GmbH": "https://images.unsplash.com/photo-1477763858572-cda7deaa9bc5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=676&q=80",

 "Syndikat - Kneipe, Bar": "https://images.unsplash.com/photo-1514933651103-005eec06c04b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1267&q=80",

 "Isla Coffee": "https://images.unsplash.com/photo-1507133750040-4a8f57021571?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=668&q=80",

 "Bioase44": "https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",

 "Agroforstsystem Märkisch Wilmersdorf": "https://images.unsplash.com/photo-1603657289433-e4983d2114b9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",

 "CRCLR House Neukölln": "https://images.unsplash.com/photo-1535828363065-62fc1406ad63?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1778&q=80",

 "denn's Biomarkt": "https://images.unsplash.com/photo-1522865389096-9e6e525333d4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",

 "tip me - das globale Trinkgeld": "https://images.unsplash.com/photo-1468254095679-bbcba94a7066?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1498&q=80",

 "Kollateralschaden": "https://images.unsplash.com/photo-1441986300917-64674bd600d8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",

 "NIRGENDWO": "https://images.unsplash.com/photo-1533743538361-5d453b873810?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",

 "ERDFEST-Initiative (und.Institut)": "https://images.unsplash.com/photo-1596496050755-c923e73e42e1?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1472&q=80",

 "Wechange eG - der Wandel Sind wir.": "https://images.unsplash.com/photo-1601985705806-5b9a71f6004f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=668&q=80",

 "ETHIQUABLE Deutschland eG": "https://images.unsplash.com/photo-1527148109426-d68d9fdff2b6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",

 "Teikei-Schöneberg": "https://images.unsplash.com/photo-1587402468263-609345399033?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",

 "TEIKEI Kaffeegemeinschaft Kladow": "https://images.unsplash.com/photo-1512568400610-62da28bc8a13?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=668&q=80",

 "Cradle to Cradle NGO | Head Office": "https://images.unsplash.com/photo-1592468482230-5be1663d6702?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1267&q=80",

 "Posteo": "https://images.unsplash.com/photo-1581333100576-b73befd79a9b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=668&q=80",

 "Der Sache wegen": "https://www.veggiesearch.de/wp-content/uploads/2018/10/der-sache-wegen-geschaeft-800x600.jpg",

 "Sustainable Design Center e.V.": "https://images.unsplash.com/photo-1587502536575-6dfba0a6e017?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",

 "Initiative Schule im Aufbruch gGmbH": "https://atlas.schule/wp-content/uploads/2020/03/SiA_Logo@2x-1.jpg",

 "a tip:tap e.V.": "https://images.unsplash.com/photo-1624543091423-d8055130b20f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=716&q=80",

 "Institute for Social Banking": "https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",

 "Teikei Gemeinschaft SGO Berlin": "https://images.unsplash.com/photo-1554118811-1e0d58224f24?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1460&q=80",
 "Gemeinwohl-Ökonomie  Deutschland e.V.": "https://images.unsplash.com/photo-1597305877032-0668b3c6413a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",

 "Scientists for Future": "https://images.unsplash.com/photo-1485740112426-0c2549fa8c86?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",

 "Ackerdemia e.V.": "https://images.unsplash.com/photo-1491841550275-ad7854e35ca6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1267&q=80",

 "ArchitekturGalerie Phönix": "https://images.unsplash.com/photo-1557688336-05815a47bd75?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1267&q=80",

 "Bio-Café Kieselstein": "https://images.unsplash.com/photo-1573493518085-3528cc6f5c0b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=666&q=80",

 "Water to Wine": "https://images.unsplash.com/photo-1506377247377-2a5b3b417ebb?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",

 "Reformhaus Mörike": "https://images.unsplash.com/photo-1568626913161-c4ac1e5ae186?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",

 "Evangelische Schule Köpenick": "https://images.unsplash.com/photo-1527187162622-535b785f65f5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1394&q=80",

 "Evangelische Schule Berlin Zentrum ESBZ": "https://images.unsplash.com/photo-1527187162622-535b785f65f5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1394&q=80",

 "Fair Trade Town Treptow-Köpenick": "https://images.unsplash.com/photo-1530735606451-8f5f13955328?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",

 "Traumschüff - Theater im Fluss": "https://images.unsplash.com/photo-1514306191717-452ec28c7814?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2850&q=80",

 "MediationsZentrum Berlin e.V.": "https://images.unsplash.com/photo-1528715471579-d1bcf0ba5e83?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1540&q=80",

 "Bildungswerk der Heinrich-Böll-Stiftung": "https://images.unsplash.com/photo-1497465689543-5940d3cede89?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",

 "Das Baumhaus Berlin": "https://www.baumhaushotels.eu/wp-content/uploads/2017/10/The-Urban-Treehouse-2.jpg",

 "Hypoport AG": "https://images.finanzen.net/mediacenter/aaa/firmen/h/hypoport001-gr.jpg",

 "Touristinformation Neukölln": "https://media04.berliner-woche.de/article/2020/03/25/5/310825_XXL.jpg?1585092854",

 "Netzwerk Fahrradfreundliches Treptow-Köpenick": "https://images.unsplash.com/photo-1485965120184-e220f721d03e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80",

 "Sirplus Rettermarkt": "https://regionalwert-ag-bo.de/wp-content/uploads/2018/07/sirplus_laden_19.jpg",

 "Albatross Bakery": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37RkRQ6cOMmkxivIz7GayzsowPQ1kaLt30Q&usqp=CAU",

 "SIRPLUS Rettermarkt Neukölln": "https://regionalwert-ag-bo.de/wp-content/uploads/2018/07/sirplus_laden_19.jpg",

 "SIRPLUS Rettermarkt Friedrichshain": "https://regionalwert-ag-bo.de/wp-content/uploads/2018/07/sirplus_laden_19.jpg",

 "1. FC Union Berlin e.V.": "https://www.dfb.de/fileadmin/_processed_/201909/csm_stuttgart_union-berlin_f1ab7decce.jpg",

 "Sustainable Design Center e.V.": "https://idz.de/img/ct_62.jpg",

 "FILMING FOR CHANGE": "https://i.vimeocdn.com/video/453273213_640x360.jpg?r=pad",

 "Organisation für nachhaltigen Konsum": "https://www.startnext.com/media/thumbnails/fbf/54f2d30eeabfa12e4a94275188066fbf/5bcb74c3/vorschaubild.jpg",

 "Ernährungsrat Berlin": "https://www.imwandel.net/uploads/artikel/ernaehrungsrat-ernaehrungsstrategie-berlin.jpg"

}

puts "Assigning Images" 
Place.all.each do |place|
  next unless images[place.name.to_sym]
  place.image_url = images[place.name.to_sym]
  place.save! 
  puts "place #{place.name} has been assigend the image #{images[place.name.to_sym]}"
end
# puts "finished"

puts ""
puts ""
puts ""
puts ""
puts ""

puts "Congrats, you now have #{Place.count} places and #{Tag.count} tags"