Rails.application.config.middleware.use OmniAuth::Builder do
   provider :github, Rails.application.secrets.GITHUB_KEY, Rails.application.secrets.GITHUB_SECRET, scope: 'user'
end