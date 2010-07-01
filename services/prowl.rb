service :prowl do |data, payload|
  url = URI.parse('https://prowl.weks.net/publicapi/add')
  repository = payload['repository']['url'].split("/")
  application = repository[-2], "/", repository[-1]
  description = "#{payload['commits'].length} commits pushed to #{application} (#{payload['commits'][-1]['id'][0..7]}..#{payload['commits'][0]['id'][0..7]})
  
Latest Commit by #{payload['commits'][-1]['author']['name']}
#{payload['commits'][-1]['id'][0..7]} #{payload['commits'][-1]['message']}"

  req = Net::HTTP::Post.new(url.path)
  req.set_form_data('apikey' => data['apikey'], 'application' => application, 'description' => description)

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true if url.port == 443 || url.instance_of?(URI::HTTPS)
  http.start { |http| http.request(req) }
end
