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

      desc "Test2", entity:Entities::SomethingElse, body_entity:Entities::SomethingElse
      post '/somethingelse' do
      end

      desc "Test3", entity:Entities::SomethingElse, body_entity:Entities::SomethingElse, params:Entities::SomethingElse.documentation.dup
      post '/somethingmore' do
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

it 'should have the same output if we specified entity and body entity' do
 get '/swagger_doc/somethingelse.json'
    expect(JSON.parse(last_response.body)).to eq({
      "apiVersion"=>"0.1",
      "swaggerVersion"=>"1.2",
      "resourcePath"=>"", 
      "apis"=>[{"path"=>"/somethingelse.{format}",
      "operations"=>[
        {"produces"=>["application/json"],
        "notes"=>"",
        "summary"=>"Test2",
        "nickname"=>"POST-somethingelse---format-",
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

it 'should have the same output if we specified entity, a body entity and some params' do
 get '/swagger_doc/somethingmore.json'
    expect(JSON.parse(last_response.body)).to eq({
      "apiVersion"=>"0.1",
      "swaggerVersion"=>"1.2",
      "resourcePath"=>"", 
      "apis"=>[{"path"=>"/somethingmore.{format}",
      "operations"=>[
        {"produces"=>["application/json"],
        "notes"=>"",
        "summary"=>"Test3",
        "nickname"=>"POST-somethingmore---format-",
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
