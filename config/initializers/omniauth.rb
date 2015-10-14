Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Rails.application.secrets.github_client_id,
                    Rails.application.secrets.github_client_secret,
    {
      :scope => 'user:email,repo,delete_repo,admin:org',
      :client_options => {
        :site => 'https://github.ucsb.edu/api/v3',
        :authorize_url => 'https://github.ucsb.edu/login/oauth/authorize',
        :token_url => 'https://github.ucsb.edu/login/oauth/access_token'
      }
    }

end
