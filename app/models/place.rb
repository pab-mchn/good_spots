class Place < ApplicationRecord
  include PgSearch::Model

  has_many :viewings
  has_many :place_tags
  has_many :tags, through: :place_tags
  # validates :name, presence: true, uniqueness: true
  # validates :address, presence: true
  validates :lat, presence: true
  validates :lng, presence: true
  validates :description, presence: true
  # validates :telephone_number, presence: true, uniqueness: true
  # validates :website_url, presence: true, uniqueness: true
  # validates :email, presence: true, uniqueness: true
  reverse_geocoded_by :lat, :lng
  after_validation :reverse_geocode

  pg_search_scope :search_by_name_and_description,
                  against: [ :name, :description ],
                  associated_against: { tags: [:name] },
                  using: {
                    tsearch: { prefix: true }
                  }

  def self.coffee_categories
    tags = %w[
      Cafe
      Coffee shop
      Kaffeehaus
      Bäckerei
      Bio bäcker
      Bio bäckerei
      Frühstück
      Kaffee
      Gebäck
      Teikei
      Konditorei
    ]
    self.joins(:tags).where(tags: { name: tags })
  end

  def self.grocerie_categories
    tags = %w[
      unverpackt
      Zerowaste
      Vegan
      Lebensmittelretten
      Lebensmittel
      Essen
      Bier
      Bio
      Regionale Lebensmittel
      Foodsaving
      Wochenmarkt
      Weltladen
      Obst
      Lokal
      Bioladen
      Foodcoop
      Regionale lebensmittel
    ]
    self.joins(:tags).where(tags: { name: tags })
  end

  def self.social_categories
    tags = %w[
      Gemeinschaft
      Vernetzung
      Activism
      Bundjugend
      Degrowth
      Gloables lernen
      Jugensarbeit
      Naturschutz
      Postwachstum
      Thempis
      Upcycling
      Verband
      Weltbewusst
      Geldfrei
      Gemeinschaft
      Karte
      Lebensgemeinschaft
      Open source
      Reisen ohne geld
      Reiseplanung
      Schenken
      Schenkökonomie
      Selbstorganisation
      Teilen
      Volunteer management
      Ökodorf
      Ökodörfer
      Quartierentwicklung nachhaltigkeit integration
      Flotte
      Freies lastenrad
      Lastenrad
      Lastenrad verleih
      Flucht
      Geflüchtete
      Life line
      Mittelmeer"Rescue"
      Sar
      Sdg10
      Sdg16
      Seenotrettung
      Friseur
      Lastenrad ausleihe
      Freunde
      Gesellschaft
      Spaß
      Gründerökosystem
      Politik
      Socent
      Wirtschaft
      Alternativ
      Hostel
      Kiez
      Schlafen
      Selbstverwaltung
      Coronahilfe
      Gabenzaun
      Cargo
      Fahrrad
      Greenfilm
      Lieferung
      Paketdienst
      Parcel
      Parcel delivery
      Transport
      Transportation
      Journalismus
      Nachrichten
      Positivenews"Wandel
      Design thinking
      Teal organization
      Flüchtlinge; integration; flüchtlingshilfe
      Communities
      Contemporary leadership transformation
      Donut
      Innovation spaces
      Integral
      Nachhaltiges wirtschaften
      Organisational transformation
      Community building
      Environmental education
      Kleidertausch
      Klimafitkarte
      Regenerative landwirtschaft
      Arbeiten
      Gemeinwohlökonomie
      Maker
      Recycling
      Urbanmining
      Fairtrade
      Globalisierung
      Lieferkette
      Trinkgeld
      Fashion
      Kleidung
      Schule
      Schuleimaufbruch
      Schulevonmorgen
      Plastik
      Wasserkiez
      Wasserquartier
      Wasserwende
      Ecovillage
      Gemeinschaftlich
      Green
      Social
      Bildungsvielfalt
      Evangelische
      Gemeinschaftsschule
      Integraleschule
      Fairtrade stadt
      Crowdfunding
      Soziokratie
      Theater
      Theaterpädagogik
      Dialog
      Konfliktberatung
      Konflikttransformation
      Mediation
      Boell stiftung
      Transition
      Fintech
      Holacracy
      Holakratie
      Sdax
      Information
      Reisen
      Tourismus
      Touristinformation
      Changing cities
      Mobilitätsgesetz
      Umweltschutz
      Umweltverband
      Wasser
      Bio
      Fair
      Flohmarkt
      Genossenschaft
      Marktplatz
      Onlineangebot
      Onlineshop
      Wech conference osteuropa
      Austausch
      Bier
      Ehrenamt
      Food
      Nachbarschaft
      Netzwerk
      Politisch
      Projektförderung
      Regional
      Social business
      Sozial
      Transparent
      Unabhängig
      Verein
      Vernetzt
      Bildung
      Bne
      C2c
      Cradletocradle
      Erneuerbare energien
      Green campus
      Green city
      Klimaschutz
      Mobilität
      Nährstoffkreisläufe
      Reallabor
      Siedlungsökologie
      Stadtentwicklung
      Umweltbildung
      Wasserkreisläufe
      Ökosiedlung
      Bildungsarbeit
      Events
      Handwerk
      Kinder
      Madeingermany
      Manufaktur
      Mitweltfestival
      Naturtextilien
      Slowfashion
      Treptow köpenicker bohne
      Ökologisch
      Demokratiebildung
      Demokratische schule
      Jugendbeteiligung
      Klimawandel
      Nachhaltige schule
      Ambulante pflege
      Pflege
      Selbstgeführt
      Selbstgesteuert
  ]
    self.joins(:tags).where(tags: { name: tags })
  end

  def self.company_categories
    tags = %w[
      Startupcycling
      Bildungsinitiative
      Biodiversität
      Wildbienen
      Ökologiegesellschaftnachhaltigkeit
      Demokratie
      Abfallvermeidung
      Kreislaufwirtschaft
      Kultur
      Ressourcenschonung
      Earthhour
      Klimabildung
      Klimafit
      Sustainablefinanceuniverse
      Umwelt
      Teikei gemeinschaft
      Gerechtigkeit
      Handel
      Kakao
      Kleinproduzenten
      Trade
      Unternehmen
      Teikei
      Circulareconomy
      Kreislauf
      Müll
      Ressourcen
      Datenschutz
      Dienstleistung
      Email
      Internet
      Ökostrom
      Dachverbandbildungvonmorgen
      Gesamtschule
      Potentialentfaltung
      Ethical banking
      Febea
      Gabv
      Geld
      Inaise
      Network
      Research
      Sustainable finance
      Scientistsforfuture
      Umweltbildung; lebensmittel; forschung; ökolgoische landwirtschaft
      Ecovillage
      Gemeinschaftlich
      Green
      Social
      Bürgerinitiative
      Galerie
      Kungerkiez
      Fairer handel
      Kiezladen
    ]
    self.joins(:tags).where(tags: { name: tags })
  end

  def self.eatery_categories
    tags = %w[
      Indisch
      Restaurant
      Vegetarisch
      Bar
      Beer
      Treffpunkt
      Direct trade
      Gastro
      Mittagessen
      Saisonal
      Take away
      Zero waste
      Essen
    ]
    self.joins(:tags).where(tags: { name: tags })
  end

  def self.shopping_categories
    tags = %w[
      Ecodesign
      Flohmarkt
      Genossenschaft
      Marktplatz
      Onlineangebot
      Onlineshop
    ]
    self.joins(:tags).where(tags: { name: tags })
  end
end
