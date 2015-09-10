require 'rails_helper'

RSpec.shared_examples "voted" do

  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:votable_name) { described_class.controller_name.singularize.underscore }
  let(:votable) { create(votable_name, user: author) }

  describe "POST #vote_up" do
    context 'Non-authenticated user' do
      it "cannot changes votes_sum" do
        expect{ post :vote_up, id: votable, format: :js }.to_not change(Vote, :count)
      end

      it "response status error 401" do
        post :vote_up, id: votable, format: :js
        expect(response.status).to eq(401)
      end
    end

    context 'Authenticated user as author' do
      before { sign_in author }

      it "not change votes_sum" do
        expect{ post :vote_up, id: votable, format: :js }.to_not change(Vote, :count)
      end

      it "redirect to root path" do
        post :vote_up, id: votable, format: :js
        expect(response.status).to eq(422)
      end
    end

    context 'Another authenticated user' do
      before { sign_in user }

      it 'add vote to database' do
        expect { patch :vote_up, id: votable, format: :json }.to change(Vote, :count).by(1)
      end

      it "change votes_sum" do
        expect{ post :vote_up, id: votable, format: :js }.to change{ votable.votes_sum }.from(0).to(1)
      end

      it "render json success" do
        post :vote_up, id: votable, format: :js
        expect(response).to be_success
      end
    end

    context 'Another authenticated user voting multiple times' do
      before { sign_in user }
      before { patch :vote_up, id: votable, format: :json }

      it 'does not save second vote in database' do
        expect { patch :vote_up, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'responds with error' do
        patch :vote_up, id: votable, format: :json
        expect(response.status).to eq(422)
      end
    end
  end

  describe "POST #vote_down" do
    context 'Non-authenticated user' do
      it "not change votes_sum" do
        expect{ post :vote_down, id: votable, format: :js }.to_not change(Vote, :count)
      end

      it "response status error 401" do
        post :vote_down, id: votable, format: :js
        expect(response.status).to eq(401)
      end
    end

    context 'Authenticated user as author' do
      before { sign_in author }

      it "not change votes_sum" do
        expect{ post :vote_down, id: votable, format: :js }.to_not change(Vote, :count)
      end

      it "redirect to root path" do
        post :vote_down, id: votable, format: :js
        expect(response.status).to eq(422)
      end
    end

    context 'Another authenticated user' do
      before { sign_in user }

      it 'add vote to database' do
        expect { patch :vote_down, id: votable, format: :json }.to change(Vote, :count).by(1)
      end

      it "change votes_sum" do
        expect{ post :vote_down, id: votable, format: :js }.to change{ votable.votes_sum }.from(0).to(-1)
      end

      it "render json success" do
        post :vote_down, id: votable, format: :js
        expect(response).to be_success
      end
    end

    context 'Another authenticated user voting multiple times' do
      before { sign_in user }
      before { patch :vote_down, id: votable, format: :json }

      it 'does not save second vote in database' do
        expect { patch :vote_down, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'responds with error' do
        patch :vote_down, id: votable, format: :json
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE #cancel_vote" do
    let!(:vote) { create(:vote, user: user, votable: votable) }

    context 'with user has vote' do
      before { sign_in user }

      it 'removes vote from database' do
        expect { patch :cancel_vote, id: votable, format: :json }.to change(Vote, :count).by(-1)
      end

      it 'changes votes_sum' do
        expect { patch :cancel_vote, id: votable, format: :json }.to change{ votable.votes_sum }.from(1).to(0)
      end

      it 'responds with success' do
        patch :cancel_vote, id: votable, format: :json
        expect(response).to be_success
      end
    end

    context 'without user has vote' do
      before { sign_in author }
      it 'does not delete any vote from database' do
        expect { patch :cancel_vote, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'responds with error' do
        patch :cancel_vote, id: votable, format: :json
        expect(response.status).to eq(422)
      end
    end
  end

end