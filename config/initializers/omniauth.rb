Rails.application.config.middleware.use OmniAuth::Builder do
	if ENV['development'] || ENV['test']
   provider :github, Rails.application.secrets.GITHUB_KEY, Rails.application.secrets.GITHUB_SECRET, scope: 'user'
 else
   provider :github, ENV['_SECRET_GITHUB_KEY'], ENV['_SECRET_GITHUB_SECRET'], scope: 'user'
 end

end