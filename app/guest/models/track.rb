class Track < Volt::Model
  own_by_user

  field :spotifyID, String
  field :name, String
  field :length, Float
  field :artist, String
  field :album, String
  field :imgUrl, String
  field :url, String
end
