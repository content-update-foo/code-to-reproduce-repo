require 'rspec'
require 'octokit'
require 'pp'

describe 'My behaviour' do

  let(:content_repo) { 'content-update-foo/content-repo' }
  let(:client) { Octokit::Client.new(login: 'content-update-foo', password: 'content-update-bar') }

  it 'should do something' do

    while(true) do
      path = "test_data/test_update_#{Time.now}_#{Random.rand}.txt"

      response = lets_do_dis { client.create_contents(content_repo, path, 'I am creating', :file => 'spec/fixtures/new_file.txt') }
      response = lets_do_dis { client.update_contents(content_repo, path, 'I am updating 1', response.content.sha, 'Here be even moar damned content') }
      response = lets_do_dis { client.update_contents(content_repo, path, 'I am updating 2', response.content.sha, 'Here be even moar damned content') }
      response = lets_do_dis { client.update_contents(content_repo, path, 'I am updating 3', response.content.sha, 'Here be even moar damned content') }
      response = lets_do_dis { client.update_contents(content_repo, path, 'I am updating 4', response.content.sha, 'Here be even moar damned content') }
      response = lets_do_dis { client.update_contents(content_repo, path, 'I am updating 5', response.content.sha, 'Here be even moar damned content') }
      response = lets_do_dis { client.update_contents(content_repo, path, 'I am updating 6', response.content.sha, 'Here be even moar damned content') }
      response = lets_do_dis { client.update_contents(content_repo, path, 'I am updating 7', response.content.sha, 'Here be even moar damned content') }
      lets_do_dis { client.update_contents(content_repo, path, 'I am updating 8', response.content.sha, 'Here be even moar damned content') }

      sleep(2)
    end

  end

  def lets_do_dis

    begin
      response = yield
      puts '*** RESPONSE ***'
      pp response
      response
    rescue Octokit::Conflict => e
      pp e
      raise e
    end

  end

end