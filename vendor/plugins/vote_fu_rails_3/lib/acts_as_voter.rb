# ActsAsVoter
module PeteOnRails
  module Acts #:nodoc:
    module Voter #:nodoc:

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_voter
          has_many :votes, :as => :voter, :dependent => :nullify  # If a voting entity is deleted, keep the votes. 
          include PeteOnRails::Acts::Voter::InstanceMethods
          extend  PeteOnRails::Acts::Voter::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
      end
      
      # This module contains instance methods
      module InstanceMethods
        
        # Usage user.vote_count(true)  # All +1 votes
        #       user.vote_count(false) # All -1 votes
        #       user.vote_count()      # All votes
        
        def vote_count(for_or_against = "all")
          where = (for_or_against == "all") ? 
            ["voter_id = ? AND voter_type = ?", id, self.class.name ] : 
            ["voter_id = ? AND voter_type = ? AND vote = ?", id, self.class.name, for_or_against ]
                        
          Vote.count(:all, :conditions => where)

        end
                
        def voted_for?(voteable)
           0 < Vote.count(:all, :conditions => [
                   "voter_id = ? AND voter_type = ? AND vote = ? AND voteable_id = ? AND voteable_type = ?",
                   self.id, self.class.name, true, voteable.id, voteable.class.name
                   ])
         end

         def voted_against?(voteable)
           0 < Vote.count(:all, :conditions => [
                   "voter_id = ? AND voter_type = ? AND vote = ? AND voteable_id = ? AND voteable_type = ?",
                   self.id, self.class.name, false, voteable.id, voteable.class.name
                   ])
         end

         def voted_on?(voteable)
           0 < Vote.count(:all, :conditions => [
                   "voter_id = ? AND voter_type = ? AND voteable_id = ? AND voteable_type = ?",
                   self.id, self.class.name, voteable.id, voteable.class.name
                   ])
         end
                
        def vote_for(voteable)
          if self.voted_on?(voteable)
            vo = Vote.first(:conditions => {:voter_id => self.id, :voter_type => self.class.name, :voteable_id => voteable.id, :voteable_type => voteable.class.name})
            vo.update_attributes(:vote => true)
          else
            self.vote(voteable, true)
          end
        end
        
        def vote_against(voteable)
          if self.voted_on?(voteable)
            vo = Vote.first(:conditions => {:voter_id => self.id, :voter_type => self.class.name, :voteable_id => voteable.id, :voteable_type => voteable.class.name})
            vo.update_attributes(:vote => false)
          else
            self.vote(voteable, false)
          end
        end

        def vote(voteable, vote)
          vote = Vote.new(:vote => vote, :voteable => voteable, :voter => self)
          vote.save
        end

      end
    end
  end
end
