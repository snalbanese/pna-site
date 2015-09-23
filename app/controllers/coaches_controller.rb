class CoachesController < ApplicationController
  def index
    @coaches = Member.includes( :awards ).where( 'awards.award_type' => 'coaching' ).group_by { |coach|
      unless coach.addresses.empty?
        unless coach.addresses.first.state.nil?
          coach.addresses.first.state
        else
          coach.addresses.first.country
        end
      end
    }.sort_by { |k,v| k.name }
    
    @regions = Region.all #.order( :name )
  end
end