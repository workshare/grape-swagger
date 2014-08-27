require 'spec_helper'

describe "Body Params" do
  
  before :all do
    module Entities
      class Something < Grape::Entity
        expose :text, :documentation => { :type => "string", :desc => "Entity name" }
      end
    end

    class BodyApi < Grape::API
      format :json
      desc 'This sets something', {
        entity: Entities::Something
      }

      desc "Test", entity: Entities::Something, body_entity: Entities::Something, params: Entities::Something.documentation.dup
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
            "name"=>"Something",
            "description"=>"",
            "dataType"=>"Something",
            "required"=>true}],
        "type"=>"Something"}]}],
      "basePath"=>"http://example.org",
      "models"=>{
        "Something"=>{
            "id"=>"Something",
            "name"=>"Something",
            "properties"=>{
               "text"=>{
                  "type"=>"string",
                  "description"=>"Content of something."}}}}}
)
  end
end
