require 'rails_helper'

RSpec.describe AssignmentInvitationsController, type: :controller do
  describe 'GET #show', :vcr do
    let(:invitation) { create(:assignment_invitation) }

    context 'unauthenticated request' do
      it 'redirects the new user to sign in with GitHub' do
        get :show, id: invitation.key
        expect(response).to redirect_to(login_path)
      end
    end

    context 'authenticated request' do
      let(:user) { GitHubFactory.create_classroom_student }

      before(:each) do
        session[:user_id] = user.id
      end

      it 'will bring you to the page' do
        get :show, id: invitation.key
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PATCH #accept_invitation', :vcr do
    let(:organization) { GitHubFactory.create_owner_classroom_org }
    let(:user)         { GitHubFactory.create_classroom_student   }

    let(:assignment) do
      Assignment.create(creator: organization.users.first,
                        title: 'ruby-project',
                        starter_code_repo_id: '1062897',
                        organization: organization,
                        public_repo: false)
    end

    let(:invitation) { AssignmentInvitation.create(assignment: assignment) }

    before(:each) do
      request.env['HTTP_REFERER'] = "http://classroomtest.com/group-assignment-invitations/#{invitation.key}"
      session[:user_id] = user.id
    end

    after(:each) do
      AssignmentRepo.destroy_all
      RepoAccess.destroy_all
    end

    it 'redeems the users invitation' do
      patch :accept_invitation, id: invitation.key
      expect(user.assignment_repos.count).to eql(1)
    end

    context 'github repository creation fails' do
      before do
        allow_any_instance_of(AssignmentRepo)
          .to receive(:create_github_repository)
          .and_raise(GitHub::Error)
      end

      it 'does not create a an assignment repo record' do
        patch :accept_invitation, id: invitation.key

        expect(assignment.assignment_repos.count).to eq(0)
      end
    end

    context 'github import fails' do
      before do
        allow_any_instance_of(GitHubRepository)
          .to receive(:get_starter_code_from)
          .and_raise(GitHub::Error)
      end

      it 'removes the repository on GitHub' do
        patch :accept_invitation, id: invitation.key

        assert_requested :delete, github_url('/repositories/44262216')
      end
    end
  end
end
