class Api::V1::ElectionsController < Api::V1::ApplicationController

  # GET /api/v1/elections/1
  def show
  end

  # GET /api/v1/elections/search
  def search
    @elections = Election.where(name: /#{params[:name]}/i)
  end

  # POST /api/v1/elections
  def create
    if @election.save
      render 'api/v1/elections/show.rabl', status: :created
    else
      render text: {errors: @election.errors}.to_json, status: :unprocessable_entity, layout: 'api_v1'
    end
  end

  # PUT /api/v1/elections/1
  def update
    if @election.update_attributes params[:election]
      render 'api/v1/elections/show.rabl', status: :ok
    else
      render text: {errors: @election.errors}.to_json, status: :unprocessable_entity, layout: 'api_v1'
    end
  end

  # POST /api/v1/elections/1/addtag
  def addtag
    tag = Tag.find params[:tagId]
    if params[:parentTagId]
      parent_tag = Tag.find params[:parentTagId]
    end

    @election_tag = ElectionTag.new election: @election, tag: tag, parent_tag: parent_tag

    if @election_tag.save
      render 'api/v1/elections/show.rabl', status: :created
    else
      render text: {errors: @election_tag.errors}.to_json, status: :unprocessable_entity, layout: 'api_v1'
    end
  end
  
  # GET /api/v1/elections/1/comparisons
  def comparisons
  end

end
