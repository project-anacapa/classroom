require 'rails_helper'

RSpec.describe RepoAccess, type: :model do
  describe 'callbacks', :vcr do
    let(:organization) { GitHubFactory.create_owner_classroom_org }
    let(:student)      { GitHubFactory.create_classroom_student   }

    before(:each) do
      @repo_access = RepoAccess.create(user: student, organization: organization)
    end

    after(:each) do
      @repo_access.destroy if @repo_access
    end

    describe 'before_validation' do
      describe '#add_membership_to_github_organization' do
        it 'adds the users membership to the GitHub organization' do
          student_github_login = GitHubUser.new(student.github_client, student.uid).login
          assert_requested :put, github_url("/orgs/#{organization.title}/memberships/#{student_github_login}")
        end
      end

      describe '#accept_membership_to_github_organization' do
        it 'accepts the users membership to the Organization' do
          assert_requested :patch, github_url("/user/memberships/orgs/#{organization.title}")
        end
      end
    end

    describe 'before_destroy' do
      describe '#silently_remove_organization_member' do
        it 'removes the user from the organization' do
          @repo_access.destroy
          student_github_login = GitHubUser.new(student.github_client, student.uid).login
          delete_request_url   = "/organizations/#{organization.github_id}/members/#{student_github_login}"
          assert_requested :delete, github_url(delete_request_url)
        end
      end
    end
  end
end
