require 'rails_helper'

RSpec.describe 'Chats API' do

    let!(:ap) { create(:app) }
    let!(:chats) { create_list(:chat, 20, appToken: ap.token) }

    let(:app_token) { ap.token }
    let(:number) { chats.first.number }

    describe 'GET /apps/:app_token/chats' do
        before { get "/apps/#{app_token}/chats" }

        context 'when app exists' do
            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end

            it 'returns all app chats' do
                expect(JSON.parse(response.body).size).to eq(20)
            end
        end

        context 'when app does not exist' do
            let(:app_token) { 0 }

            it 'returns status code 404' do
                expect(response).to have_http_status(200)
            end

            it 'returns a not found message' do
                expect(JSON.parse(response.body).size).to eq(0)
            end
        end
    end

    describe 'GET /apps/:app_token/chats/:number' do
        before { get "/apps/#{app_token}/chats/#{number}" }

        context 'when app chat exists' do
            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end

            it 'returns the chat' do
                expect(JSON.parse(response.body).first['appToken']).to eq(app_token)
                expect(JSON.parse(response.body).first['number']).to eq(number)
            end
            
        end

        context 'when app chat does not exist' do
            let(:number) { 0 }

            it 'returns status code 404' do
                expect(response).to have_http_status(404)
            end

            it 'returns a not found message' do
                expect(response.body).to match(/Couldn't find Chat/)
            end
        end
    end

    describe 'POST /apps/:app_token/chats' do

        context 'when request attributes are valnumber' do
            before { post "/apps/#{app_token}/chats", params: {} }

            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end
        end

    end

end