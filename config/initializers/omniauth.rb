Rails.application.config.middleware.use OmniAuth::Builder do
	if ENV['RAILS_ENV']  == 'production'
		provider :github, ENV['_SECRET_GITHUB_KEY'], ENV['_SECRET_GITHUB_SECRET'], scope: 'user' 
	else
   	provider :github, Rails.application.secrets.GITHUB_KEY, Rails.application.secrets.GITHUB_SECRET, scope: 'user'
 end
end