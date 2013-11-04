def lets_do_dis

  begin
    response = yield
    puts '*** RESPONSE ***'
    response
  rescue Octokit::Conflict => e
    pp e
    raise e
  end

end