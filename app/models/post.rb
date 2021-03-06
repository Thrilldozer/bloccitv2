class Post < ApplicationRecord
  belongs_to :topic
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  after_create :create_favorite

  after_create :create_vote
  default_scope { order('rank DESC') }
  scope :ordered_by_title, -> { order('title DESC') }
  #
  scope :visible_to, -> (user) { user ? all : joins(:topic).where('topics.public' => true) }
  scope :ordered_by_reversed_created_at, -> { order('created_at ASC') }

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :topic, presence: true
  validates :user, presence: true

  def up_votes
  #find votes for post by passing value :1 to where.  fetches a collection of votes w/ value 1
    votes.where(value: 1).count
  end

  def down_votes
  #fetches collectoin of votes w/ value: -1
    votes.where(value: -1).count
  end

  def points
  #use ActiveRecords sum method to add value of all given posts
    votes.sum(:value)
  end

  def update_rank
    age_in_days = (created_at - Time.new(1970,1,1)) / 1.day.seconds
    new_rank = points + age_in_days
    update_attribute(:rank, new_rank)
  end

  def create_favorite
    Favorite.create(post: self, user: self.user)
  end

    private

    def create_vote
      user.votes.create(value: 1, post: self)
    end
end
