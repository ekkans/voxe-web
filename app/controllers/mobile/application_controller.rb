class Mobile::ApplicationController < ApplicationController
  
  private
    def set_election
      @election = Election.first conditions: {namespace: params[:namespace]}
      # returns 404 if election does not exist
      return not_found unless @election
    end
    
end
