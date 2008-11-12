class Hand < ActiveRecord::Base
  belongs_to :session
  has_many :stats
  has_many :players, :through => :stats
  
  named_scope :recent, lambda{ |x| {:order => 'played_at DESC', :conditions => ['played_at > ?', 15.minutes.ago], :group => 'description', :limit => x || 5}}
  
  def content
    session.content_at(starting_at)
  end
end
