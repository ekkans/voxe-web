#= require backbone/models_and_collections

describe 'Election model', ->

  beforeEach ->
    # CandidaciesCollection STUB
    @candidaciesCollectionStub = sinon.stub(window, 'CandidaciesCollection')
    candidaciesCollection = new Backbone.Collection()
    @candidaciesCollectionStub.returns(candidaciesCollection)

    # TagsCollection STUB
    @tagsCollectionStub = sinon.stub(window, 'TagsCollection')
    tagsCollection = new Backbone.Collection()
    @tagsCollectionStub.returns(tagsCollection)

    # TagModel STUB
    @tagModelStub = sinon.stub(window, 'TagModel')
    tagModel = new Backbone.Model()
    @tagModelStub.returns(tagModel)

  it 'name method should respond with name attribute', ->
    election = new ElectionModel(name: 'toto')
    expect(election.name()).toEqual('toto')

  it 'namespace method should respond with namespace attribute', ->
    election = new ElectionModel(namespace: 'toto')
    expect(election.namespace()).toEqual('toto')

  describe 'add a tag', ->
    # ok with w/o parent
    # ok with parent
    # nok
    describe 'w/o a parent', ->
      beforeEach ->
        @server = sinon.fakeServer.create()

        @election = new ElectionModel(id: '123')
        tag = new TagModel(name: 'test')
        @election.addTag tag

      afterEach ->
        @server.restore()

      it 'should send the correct request', ->
        expect(@server.requests.length).toEqual(1)
        expect(@server.requests[0].method).toEqual('POST')
        expect(@server.requests[0].url).toEqual("#{@election.url()}/addtag")

  describe 'non persistent', ->
    it 'should have a url without id', ->
      election = new ElectionModel()
      expect(election.url()).toEqual('/api/v1/elections')

  describe 'persistent', ->
    it 'should have a url with an id', ->
      election = new ElectionModel(id: '123')
      expect(election.url()).toEqual('/api/v1/elections/123')

  afterEach ->
    @candidaciesCollectionStub.restore()
    @tagsCollectionStub.restore()
    @tagModelStub.restore()

