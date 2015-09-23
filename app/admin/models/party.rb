class Party < Volt::Model

  has_many :guests
  has_many :tracks

  field :createAt
end
