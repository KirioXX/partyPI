class Party < Volt::Model

  has_many :users
  has_many :tracks

  field :createAt
end
