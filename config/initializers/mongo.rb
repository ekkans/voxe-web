MongoMapper.config = { 
  "production"  => { 'uri' => ENV['MONGOHQ_URL'] },
  "development" => { 'uri' => "mongodb://localhost/joinplato_test" },
  "test"        => { 'uri' => "mongodb://localhost/joinplato_test" }
}

MongoMapper.connect(Rails.env)
