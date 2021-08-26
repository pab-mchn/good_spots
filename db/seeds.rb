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
"Fairmondo eG": "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=874&q=80",
"Quartiermeister – Bier für den Kiez": "https://www.google.de/imgres?imgurl=https%3A%2F%2Fgruene-startups.de%2Fwp-content%2Fuploads%2F2018%2F08%2Fqm_crowdfunding_flaschen.jpg&imgrefurl=https%3A%2F%2Fgruene-startups.de%2Fquartiermeister-bier-trinken-und-gutes-tun%2F&tbnid=EW55IcnnYSbBjM&vet=12ahUKEwicj6a6is_yAhUGGewKHT6bB0UQMygGegUIARCnAQ..i&docid=P5WXC5jJeX9IKM&w=1200&h=800&q=Quartiermeister%20%E2%80%93%20Bier%20f%C3%BCr%20den%20Kiez&ved=2ahUKEwicj6a6is_yAhUGGewKHT6bB0UQMygGegUIARCnAQ",
"Eco City – International Campus Wünsdorf": "https://images.unsplash.com/photo-1573487750369-2fcb245a373f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=328&q=80",
"RESTLOS GLÜCKLICH e.V.": "https://www.google.de/imgres?imgurl=https%3A%2F%2Fwww.restlos-gluecklich.berlin%2Fwp-content%2Fuploads%2F2019%2F06%2Fcropped-logo_website-1.png&imgrefurl=https%3A%2F%2Fwww.restlos-gluecklich.berlin%2F&tbnid=jBlSlbcfZrEOIM&vet=12ahUKEwjlgqWZi8_yAhWcgaQKHYZnDFsQMygAegUIARCXAQ..i&docid=5XMy5OyjW-lh3M&w=400&h=400&q=RESTLOS%20GL%C3%9CCKLICH%20e.V&ved=2ahUKEwjlgqWZi8_yAhWcgaQKHYZnDFsQMygAegUIARCXAQ",
"Adolf-Hoops-Gesellschaft mbH": "https://unsplash.com/photos/47gcGwUUHb0",
"Märkisches Landbrot": "https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80",
"Förderkreis Biozyklisch-Veganer Anbau e.V.": "https://images.unsplash.com/photo-1603297427541-ed9aed6f0dbd?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8dmVnYW5pc218ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
"Ormado Kaffeehaus": "https://images.unsplash.com/photo-1522551458619-a2427b661528?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
"CHARLE - sustainable kids fashion": "https://images.unsplash.com/photo-1560859259-fcf2b952aed8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
"SV-Bildungswerk e.V.": "https://images.unsplash.com/photo-1596496050755-c923e73e42e1?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=736&q=80",
" VIER-bei-mir - Ambulante Pflege": "https://images.unsplash.com/photo-1547082688-9077fe60b8f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=889&q=80",
"Original Unverpackt": "https://images.unsplash.com/photo-1580368185100-5347908688ab?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
"Rabenhaus e.V.": "https://www.rabenhaus.de/wp-content/uploads/2019/01/RH-Logo_Name-innen-434x600.jpg",
"Kietz Klub Köpenick": "https://lh3.googleusercontent.com/proxy/HtR9F-3UP3PYss2f9kcnyzbZ-eZXH9BmH3GRACf3tauthQ7at8Z_c2_f1QYf-9TJcXLzgzUWT5FF-ND0ZDlJw1_pi9bebhAZRllRIg",
"Offenes Wohnzimmer": "https://images.unsplash.com/photo-1484101403633-562f891dc89a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=753&q=80",
"BUNDJugend Bund für Umwelt und Naturschutz e.V.": "https://tse4.mm.bing.net/th?id=OIP.5T_0Fnryc3QJp5eE-qGTGwHaEK&pid=Api",
"Café der Fragen": "data:image/png;base64,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",
"ecobasa.org": "https://images.unsplash.com/photo-1615811361523-6bd03d7748e7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=668&q=80",
"Kiez.Rebellen": "https://images.unsplash.com/photo-1568994105244-51e2467a98fd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=678&q=80",
"fLotte Dörte": "https://images.unsplash.com/photo-1601067095185-b8b73ad7db10?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1481&q=80",
"denn's Biomarkt": "https://www.google.de/imgres?imgurl=https%3A%2F%2Fwww.eastsidemall.de%2Fuploads%2Fcmgshops%2Fshops%2Fstore%2F23.jpg&imgrefurl=https%3A%2F%2Fwww.eastsidemall.de%2Fde%2Fshops%2F23%2F9%2FDenns-Biomarkt&tbnid=Lzl0q7x7Fp7wdM&vet=10CAsQxiAoAWoXChMIiOX2xbTP8gIVAAAAAB0AAAAAEAY..i&docid=mhiKA8QUq1N-XM&w=1920&h=1200&itg=1&q=denns%20berlin&hl=de&ved=0CAsQxiAoAWoXChMIiOX2xbTP8gIVAAAAAB0AAAAAEAY",
#  "Seebrücke": "https://cloud.seebruecke.org/index.php/s/mT3n8wLrmXFf7BL?path=%2FneuesLogo_orange",
"fLotter Erwin": "https://images.unsplash.com/photo-1601067095185-b8b73ad7db10?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1481&q=80",
"Jugendhaus Mstreet": "https://images.unsplash.com/photo-1600821986515-3ef5b0f29f39?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=664&q=80",
#  "UnternehmensGrün e.V.": "https://unsplash.com/photos/8aPNK1w37E8",
#  "Regenbogenfabrik Block 109 e.V.": "https://unsplash.com/photos/8aPNK1w37E8",
#  "Gabenzaun Weissensee": "https://unsplash.com/photos/KOMIfrKumpo",
"ImagineCargo UG": "https://images.unsplash.com/photo-1476631840528-13bdc7f18072?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=752&q=80",
#  "Good Impact  c/o Impact Partner GmbH": "https://unsplash.com/photos/dZxQn4VEv2M",
#  "Dark Horse GmbH": "https://unsplash.com/photos/NDLLFxTELrU",
#  "Flüchtlingshilfe Babelsberg e.V.": "https://unsplash.com/photos/kY8m5uDIW7Y",
#  "TheDive": "https://unsplash.com/photos/U8xSH9q_wUM",
"Gemeinwohl-Bioladen": "https://images.unsplash.com/photo-1576181456177-2b99ac0aa1ef?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=375&q=80",
"Kulturlabor Trial&Error e.V.  - open soil Atlas": "data:image/jpeg;base64,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",
"Your Little Planet - Die Initiative": "https://images.unsplash.com/photo-1598115746104-1a00ed9ca937?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1502&q=80",
#  "BIO COMPANY GmbH Filiale Kladower Damm": "https://unsplash.com/photos/D6Tu_L3chLE",
#  "IGG MALZFABRIK mbH": "https://unsplash.com/photos/EHbtjmz7hvw",
#  "Trinkbrunnen": "https://unsplash.com/photos/xaOQSqfIR08",
#  "Teikei Coffee Gemeinschaft Wedding": "https://unsplash.com/photos/nzyzAUsbV0M",
#  "Mehr Demokratie e.V.": "https://unsplash.com/photos/4ofKCA9XAiY",
"-Stoffe Neukölln - MateriKunstalannahme & -verkauf": "https://images.unsplash.com/photo-1602706294170-1fed8eecd9f9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
"World Wide Fund": "https://images.unsplash.com/flagged/photo-1576045771676-7ac070c1ce72?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
"fLotte Otti": "https://images.unsplash.com/photo-1601067095185-b8b73ad7db10?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1481&q=80",
"fLotter Johannes": "https://images.unsplash.com/photo-1601067095185-b8b73ad7db10?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1481&q=80",
"fLottes Paulchen": "https://images.unsplash.com/photo-1601067095185-b8b73ad7db10?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1481&q=80",
#  "Samadhi indisches Restaurant": "https://unsplash.com/photos/eEWlcfydzQ4",
 "FUTURZWEI. Stiftung Zukunftsfähigkeit\u2028": "https://images.unsplash.com/photo-1603573355706-3f15d98cf100?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1488&q=80", #not working 
 

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

 "Albatross Bakery": "https://lh3.googleusercontent.com/proxy/SC74HWUZ6wVUaSLK9j_QiLqklBAj2pJ72yJbNsumhxsnmXpkE17cqGu0FIwN_ndV9cNLk-Hh7KWQA8D5wsEmrHoO0bNf8n-u7ePZjMiCU5vF08JN-rXXJ8ZxsYPdvWsqK90",

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