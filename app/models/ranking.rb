class Ranking < ActiveRecord::Base
  validates_presence_of     :rank
  
  belongs_to :rankable, :polymorphic => true
  belongs_to :ranker, :polymorphic => true
  after_save :auto_create_weights
  
  scope :for_ranker,    lambda { |*args| {:conditions => ["ranker_id = ? AND ranker_type = ?", args.first.id, args.first.class.name]} }
  scope :for_ranker_type,    lambda { |*args| where("ranker_type = ?", args.first.class.name) }
  scope :for_rankable, lambda { |*args| {:conditions => ["rankable_id = ? AND rankable_type = ?", args.first.id, args.first.class.name]} }
  scope :for_rankable_type, lambda { |*args| {:conditions => ["rankable_type = ?", args.first.class.name]} }
  scope :in_favor, where("rank > ?", 0)
  scope :against, where("rank < ?", 0)
  
  def self.number_of_votes(ranker)
          result = Ranking.for_ranker(ranker).for_rankable_type(Initiative.first).count
          result += Ranking.for_ranker(ranker).for_rankable_type(Referendum.first).count
          return result
  end
  
  def self.ranked_on?(ranker,rankable)
     0 < Ranking.count(:all, :conditions => [
             "ranker_id = ? AND ranker_type = ? AND rankable_id = ? AND rankable_type = ?",
             ranker.id, ranker.class.name, rankable.id, rankable.class.name
             ])
   end
   
   def self.ranked_for?(ranker,rankable)
      0 < Ranking.count(:all, :conditions => [
              "ranker_id = ? AND ranker_type = ? AND rank > 0 AND rankable_id = ? AND rankable_type = ?",
              ranker.id, ranker.class.name, rankable.id, rankable.class.name
              ])
    end

    def self.ranked_against?(ranker,rankable)
        0 < Ranking.count(:all, :conditions => [
                "ranker_id = ? AND ranker_type = ? AND rank < 0 AND rankable_id = ? AND rankable_type = ?",
                ranker.id, ranker.class.name, rankable.id, rankable.class.name
              ])
    end
    
    def self.all_related_bills(rankable)
      if rankable.class.name == "Amendment"
        rankable = rankable.amendmentable
      end
      dataMat = [rankable] + rankable.amendments.not_blank.all_validated
      return dataMat
    end
    
    def self.all_related_bills_sorted(rankable,ranker)
      if rankable.class.name == "Amendment"
        rankable = rankable.amendmentable
      end
      dataMat = [rankable] + rankable.amendments.not_blank.all_validated
      dataMat.sort_by{|r| r.rankings.for_ranker(ranker)[0].nil? ? 10000 : r.rankings.for_ranker(ranker)[0].rank }.reverse
    end
  
    def self.percent_approval(rankable)
      100*(tally_ranks_for(rankable).to_f/(tally_all_ranks(rankable)))
    end
  
    def self.tally_all_ranks(rankable)
            ranks = 0;
            rankable.rankings.for_ranker_type(Delegate.first).each do |r|
                    unless r.ranker.nil? 
                            ranks=ranks+r.ranker.weights.for_bill(rankable).first.value
                    end
            end
            ranks = ranks+rankable.rankings.for_ranker_type(User.first).count
    end

    def self.tally_ranks_for(rankable)
            ranks = 0;
            rankable.rankings.for_ranker_type(Delegate.first).in_favor.each do |r|
                    unless r.ranker.nil? 
                            ranks=ranks+r.ranker.weights.for_bill(rankable).first.value
                    end
            end
            ranks = ranks+rankable.rankings.for_ranker_type(User.first).in_favor.count
    end

    def self.tally_ranks_against(rankable)
            ranks = 0;
            rankable.rankings.for_ranker_type(Delegate.first).against.each do |r|
                    unless r.ranker.nil? 
                            ranks=ranks+r.ranker.weights.for_bill(rankable).first.value
                    end
            end
            ranks = ranks+rankable.rankings.for_ranker_type(User.first).against.count
    end
      
      def self.average_rank(rankable)
         rank = [];
         rankable.rankings.for_ranker_type(Delegate.first).each do |r|
           unless r.ranker.nil? 
                   for i in 1..r.ranker.weights.for_bill(r.rankable).first.value
                           rank << r.rank
                   end
           end
         end
         rank += rankable.rankings.for_ranker_type(User.first).collect{|rk| rk.rank}
         rank.sum.to_f/rank.size.to_f
       end
       
       def self.rank_matrix(rankable)
               if rankable.class.name == "Amendment"
                       rankable = rankable.amendmentable
               end
               cand = Ranking.all_related_bills(rankable)
               n = cand.count
               matrix = []
               #last row and column is for the "none" alternative
               for i in 0..n
                       matrix[i] = []
                       for j in 0..n
                               matrix[i][j] = 0
                       end
               end
               for i in 0..n-1
                       matrix[i][n] = cand[i].rankings.collect{ |r| r.rank>0 ? 1:0 }.sum
                       matrix[n][i] = cand[i].rankings.collect{ |r| r.rank<0 ? 1:0 }.sum
                       for j in (i+1)..n-1
                               cand[i].rankings.each do |r|
                                       unless r.ranker.nil?
                                               if r.ranker_type == "Delegate"
                                                       num_of_votes = r.ranker.weights.for_bill(r.rankable).first.value
                                               else
                                                       num_of_votes = 1
                                               end
                                               rj = cand[j].rankings.for_ranker(r.ranker)[0]
                                               unless rj.nil? #shouldn't normally happen
                                                       if r.rank > rj.rank
                                                               matrix[i][j] += num_of_votes
                                                       end
                                                       if r.rank < rj.rank
                                                               matrix[j][i] += num_of_votes
                                                       end
                                               end
                                       end
                               end
                       end
               end
               matrix
       end
       
       def self.paths_strength(m)
         ## see wikipedia page on Shulze method
         n = m.size
         matrix = []
         for i in 0..n-1
           matrix[i] = []
           for j in 0..n-1
             matrix[i][j] = 0
           end
         end
         for i in 0..n-1
           for j in 0..n-1
             if i != j
               if m[i][j] > m[j][i]
                 matrix[i][j] = m[i][j]
               else
                 matrix[i][j] = 0
               end
             end
           end
         end
         for i in 0..n-1
           for j in 0..n-1
             if i != j
               for k in 0..n-1
                 if (k!=i) && (k!=j)
                   mmin = [matrix[j][i], matrix[i][k]].min
                   matrix[j][k] = [matrix[j][k], mmin].max
                 end
               end
             end
           end
         end
         return matrix
       end
       
       def self.schulze_score(m)
         n = m.size
         score = Array.new(n,0)
         for i in 0..n-1
           for j in 0..n-1
             if i != j
               if m[i][j] > m[j][i]
                 score[i] += 1
               end
             end
           end
         end
         return score
       end

       def self.schulze(rankable)
         m = Ranking.rank_matrix(rankable)
         m = Ranking.paths_strength(m)
         score = Ranking.schulze_score(m)
         
         max_index = score.each.with_index.find_all{ |a,i| a == score.max }.map{ |a,b| b+1 }
         winner = nil
         if max_index.count == 1
           if score[max_index[0]-1] == score.size-1
             winner = max_index[0]
           end
         end
         ## winner equals one means the original bill won
         ## winner equals N+2, N being the number of amendments => the winner is "none"
         ## winner equals nil means there is no Condorcet winner
         ## all other values correspond to indexes of amendments 
         return winner
       end
      
      private
      def auto_create_weights
          if self.ranker_type == "Delegate" 
                  weight = self.ranker.weight_on_bill(self.rankable)
                  w = self.rankable.weights.build(:value => weight, :delegate_id => self.ranker.id)
                  w.save!
          end
      end
       
end
