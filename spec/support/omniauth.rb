def set_omniauth
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:github] = {
  	'provider' => 'github',
    'uid' => '1234',
    "info" => {
      "email" => 'alex@example.com',
      "name" => 'Alex Peattie'
     }
  }
end