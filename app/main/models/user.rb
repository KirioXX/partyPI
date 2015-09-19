# By default Volt generates this User model which inherits from Volt::User,
# you can rename this if you want.
class User < Volt::User
  before_validate :addDefault
  has_many :tracks

  # login_field is set to :email by default and can be changed to :username
  # in config/app.rb
  field login_field
  field :name
  field :admin
  field :image

  validate login_field, unique: true, length: 8
  validate :email, email: true

  def addDefault
    #self.image ||= Faker::Avatar.image
  end
end
