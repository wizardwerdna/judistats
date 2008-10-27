class Hand < ActiveRecord::Base
  has_many :stats
  has_one :session, :through => :stats
  has_many :sessions, :through => :stats
  has_many :players, :through => :stats
  
  named_scope :recent, lambda{ |x| {:order => 'played_at DESC', :conditions => ['played_at > ?', 15.minutes.ago], :group => 'description', :limit => x || 5}}
end
