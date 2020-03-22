class User < ApplicationRecord
  validates :name, :email, presence: true

  def self.add_user(options)
    user = User.find_by(email: options[:email])
    user || User.create({uid: options.delete(:id)}.merge(options))
  end
end
