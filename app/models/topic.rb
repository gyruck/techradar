class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name,
            presence: true,
            uniqueness: {
              case_sensitive: false
            }
  validates :slug, presence: true, uniqueness: true
  validates :creator, presence: true

  has_many :blips
  has_many :radars, through: :blips

  belongs_to :creator, class_name: "User"

  # before_create :set_twitter_profile_image

  def self.techradar
    find_or_create_by!(name: "techradar.io", creator: User.admin)
  end

  def self.by_name
    order("lower(name)")
  end

  def self.lookup(name)
    Topic.where(["lower(name) = ?", name.downcase]).first
  end

  private

  def set_twitter_profile_image
    return unless twitter_username.present?
    self.twitter_profile_image = TwitterProfileImage.call(twitter_username)
  end
end
