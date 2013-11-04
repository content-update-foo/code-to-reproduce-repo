require 'rspec'
require 'octokit'
require 'pp'


describe 'Low level commit to sort my problems' do

  let(:content_repo) { 'www-thoughtworks-com/tw-test' }
  let(:client) { Octokit::Client.new(login: 'onesandtwos', password: 'Qwerty234!') }
  let(:master_ref) { 'heads/master' }

  it 'should create a file' do
    path = "test_data/test_update_#{Time.now}_#{Random.rand}.txt"
    client.create_contents(content_repo, path, 'I am creating', :file => 'spec/fixtures/new_file.txt')
  end

  xit 'should do something' do
    while (true)
      do_it()
    end
  end

  it 'should try harder' do
    path = File.join('update_data', "/test_low_level_commit_#{Time.now}_#{Random.rand}.txt")

    while (true)
      begin
        do_it(path)
      rescue Octokit::UnprocessableEntity => e
        puts '***** Retrying'
        retry if e.message.include? '422'
      rescue Exception => e
        pp e
      end
    end
  end

end

def do_it(path)
  puts path
  sha_latest_commit = client.ref(content_repo, master_ref).object.sha
  sha_base_tree = client.commit(content_repo, sha_latest_commit).commit.tree.sha

  blob_sha = lets_do_dis { client.create_blob(content_repo, Base64.strict_encode64("Ding dong the witch is dead #{Time.now}"), 'base64') }

  sha_new_tree = lets_do_dis { client.create_tree(content_repo, [{
                                                       :path => path,
                                                       :mode => '100644',
                                                       :type => 'blob',
                                                       :sha => blob_sha}
  ], {:base_tree => sha_base_tree})}.sha


  commit_message = 'Committed via Octokit!'
  sha_new_commit = lets_do_dis { client.create_commit(content_repo, commit_message, sha_new_tree, sha_latest_commit) }.sha
  updated_ref = client.update_ref(content_repo, master_ref, sha_new_commit, false)
  puts "********** #{client.rate_limit}"
  puts updated_ref
end
