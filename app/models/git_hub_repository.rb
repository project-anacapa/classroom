class GitHubRepository
  include GitHub

  attr_reader :id

  def initialize(client, id)
    @client = client
    @id     = id
  end

  # Public
  #
  def full_name
    with_error_handling { @client.repository(@id).full_name }
  end

  # Public
  #
  def get_starter_code_from(source)
    with_error_handling do
      @client.put(
        "/repositories/#{@id}/import",
        headers: { accept: 'application/vnd.github.barred-rock-preview' },
        'vcs': 'git',
        'vcs_url': "https://github.com/#{source.full_name}"
      )
    end
  end

  # Public
  #
  def set_push_webhook(url)
    with_error_handling do
      @client.create_hook(
      @id,
      'web',
      {
        :url => url,
        :content_type => 'json'
      },
      {
        :events => ['push', 'pull_request'],
        :active => true
      }
      )
    end
  end

  # Public
  #
  def repository(full_repo_name = nil)
    with_error_handling do
      @client.repository(full_repo_name || @id)
    end
  end
end
