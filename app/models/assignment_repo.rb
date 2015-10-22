class AssignmentRepo < ActiveRecord::Base
  include GitHubPlan
  include GitHubRepoable

  has_one :organization, -> { unscope(where: :deleted_at) }, through: :assignment

  belongs_to :assignment
  belongs_to :repo_access

  validates :assignment, presence: true

  validates :github_repo_id, presence:   true
  validates :github_repo_id, uniqueness: true

  validates :repo_access, presence:   true
  validates :repo_access, uniqueness: { scope: :assignment }

  # Public
  #
  def creator
    assignment.creator
  end

  # Public
  #
  def private?
    !assignment.public_repo?
  end

  # Public
  #
  def github_team_id
    repo_access.github_team_id
  end

  # Public
  #
  def repo_name
    github_user = GitHubUser.new(repo_access.user.github_client)
    "#{assignment.slug}-#{github_user.login}"
  end

  # Public
  #
  def starter_code_repo_id
    assignment.starter_code_repo_id
  end

  # Public
  #
  def push_webhook
    assignment.push_webhook
  end

end
