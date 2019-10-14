class Movie < ActiveRecord::Base
    def self.with_ratings(ratings)
        if ratings.length() > 0
            Movie.all.where(rating: ratings)
        else
            Movie.all
        end
    end
end
