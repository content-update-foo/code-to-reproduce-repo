require_relative 'spec_helper'

require 'rspec'
require 'octokit'
require 'pp'

describe 'My behaviour' do

  let(:content_repo) { 'content-update-foo/content-repo' }
  let(:client) { Octokit::Client.new(login: 'content-update-foo', password: 'content-update-bar') }

  #before :all do
  #
  #  stack = Faraday::Builder.new do |builder|
  #    builder.response :logger
  #    builder.use Octokit::Response::RaiseError
  #    builder.adapter Faraday.default_adapter
  #  end
  #
  #  Octokit.middleware = stack
  #
  #end

  it 'should break on concurrent updates' do

    while(true) do

      path = "test_data/test_update_#{Time.now}_#{Random.rand}.txt"

      response = lets_do_dis { client.create_contents(content_repo, path, 'I am creating', :file => 'spec/fixtures/new_file.txt') }
      sleep(2)
      lets_do_dis { client.update_contents(content_repo, path, 'I am updating 1', response.content.sha, 'Here be even moar damned content') }
      sleep(2)
    end

  end

end