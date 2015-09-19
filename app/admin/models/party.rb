class Party < Volt::Model
  has_many :guests
  has_one :admin
end
