require 'spec_helper'

describe "Body Params" do
  
  before :all do
    module Entities
      class SomethingElse < Grape::Entity
        expose :text, :documentation => { :type => "string", :desc => "Entity name" }
      end
    end

    class BodyApi < Grape::API
      format :json

      desc "Test", body_entity: Entities::SomethingElse
      post '/something' do
      end
      add_swagger_documentation
    end
  end
  
  def app; BodyApi; end

  it "should document specified models" do
    get '/swagger_doc/something.json'
    expect(JSON.parse(last_response.body)).to eq({
      "apiVersion"=>"0.1",
      "swaggerVersion"=>"1.2",
      "resourcePath"=>"", 
      "apis"=>[{"path"=>"/something.{format}",
      "operations"=>[
        {"produces"=>["application/json"],
        "notes"=>"",
        "summary"=>"Test",
        "nickname"=>"POST-something---format-",
        "httpMethod"=>"POST",
        "parameters"=>[
           {"paramType"=>"body",
            "name"=>"SomethingElse",
            "description"=>"",
            "dataType"=>"SomethingElse",
            "required"=>true}],
        "type"=>"SomethingElse"}]}],
      "basePath"=>"http://example.org",
      "models"=>{
        "SomethingElse"=>{
            "id"=>"SomethingElse",
            "name"=>"SomethingElse",
            "properties"=>{
               "text"=>{
                  "type"=>"string",
                  "description"=>"Entity name"}}}}}
)
  end
end
