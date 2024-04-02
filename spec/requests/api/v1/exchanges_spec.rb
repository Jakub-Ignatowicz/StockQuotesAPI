require 'swagger_helper'

describe 'Api::V1::ExchangesController', type: :request do
  path '/api/v1/exchanges' do
    get 'Get all paginated exchanges' do
      tags 'Exchanges'
      let(:items) { 20 }
      let(:page) { 1 }
      let(:name) { 'Nasdaq Stock Market' }
      let(:mic) { 'XNAS' }
      parameter name: 'page', in: :query, type: :integer, description: 'Current page number', example: 1
      parameter name: 'items', in: :query, type: :integer,
                description: 'Number of items per page(default 20 and maximum of 100)', example: 20
      parameter name: 'name', in: :query, type: :string, description: 'Name of the exchange you want to find',
                example: 'Nasdaq Stock Market'
      parameter name: 'mic', in: :query, type: :string, description: 'Mic of the exchange you want to find',
                example: 'XNAS'

      produces 'application/json'

      response '200', 'Exchanges retrieved' do
        let!(:exchanges) { FactoryBot.create_list(:exchange, 3) }

        schema type: :object,
               properties: {
                 records: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer, example: 1 },
                       mic: { type: :string, example: 'XNAS' },
                       name: { type: :string, example: 'Nasdaq Stock Market' }
                     },
                     required: %w[id mic name]
                   }
                 },

                 pagination: {
                   type: :object,
                   properties: {
                     current_page: { type: :integer, example: 1 },
                     pages_count: { type: :integer, example: 13 },
                     render_count: { type: :integer, example: 1 },
                     items_count: { type: :integer, example: 13 },
                     prev_url: { type: :string, example: '/api/v1/exchanges?page=' },
                     next_url: { type: :string, example: '/api/v1/exchanges?page=2' }
                   },
                   required: %w[current_page pages_count render_count items_count]
                 }
               },
               required: %w[records]

        run_test!
      end
      response '400', 'Invalid page input' do
        let(:page) { 3 }

        schema type: :object,
               properties: {
                 error: { type: :string, example: 'expected :page in 1..2; got 3' }
               }

        run_test!
      end
    end
    post('Create an exchange') do
      tags 'Exchanges'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :exchange, in: :body, schema: {
        type: :object,
        properties: {
          mic: { type: :string, example: 'XNAS' },
          name: { type: :string, example: 'Nasdaq Stock Market' }
        },
        required: %w[mic name]
      }

      response(201, 'Created exchange') do
        let(:exchange) { { mic: 'TEST', name: 'Test Exchange' } }

        schema type: :object,
               properties: {
                 mic: { type: :string, example: 'XNAS' },
                 name: { type: :string, example: 'Nasdaq Stock Market' }
               },
               required: %w[mic name]
        run_test!
      end

      response(422, 'Invalid params') do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     mic: {
                       type: :array,
                       items: { type: :string },
                       example: ['mic can only contain letters and numbers']
                     },
                     name: {
                       type: :array,
                       items: { type: :string },
                       example: ["can't be blank", 'is too long (maximum is 256 characters)']
                     }
                   }
                 }
               }
        let(:exchange) { { mic: '', name: 'Test Exchange' } }
        run_test!

        let(:exchange) { { mic: 'AB&3', name: 'Test Exchange' } }
        run_test!

        let(:exchange) { { mic: 'TEST', name: 'a' * 257 } }
        run_test!
      end
    end
  end
  path '/api/v1/exchanges/{id}' do
    get 'Retrieves just one exchange' do
      tags 'Exchanges'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'ID of the exchange to retrieve', example: '1'

      response '200', 'Exchange found' do
        let!(:exchange) { FactoryBot.create(:exchange) }
        let(:id) { exchange.id }

        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 mic: { type: :string, example: 'XNAS' },
                 name: { type: :string, example: 'Nasdaq Stock Market' }
               },
               required: %w[id mic name]

        run_test!
      end

      response '404', 'Exchange not found' do
        let(:id) { 'invalid-id' }

        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Exchange not found' }
               }
        run_test!
      end
    end

    put 'Updates entire exchange' do
      tags 'Exchanges'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, description: 'ID of the exchange to update', example: '1'
      parameter name: :exchange, in: :body, schema: {
        type: :object,
        properties: {
          mic: { type: :string, example: 'XNAS' },
          name: { type: :string, example: 'Nasdaq Stock Market' }
        }
      }
      let(:ex) { FactoryBot.create(:exchange) }

      let(:id) { ex.id }
      let(:exchange) { { mic: 'XNAS', name: 'Nasdaq Stock Market' } }

      response(200, 'Exchange updated') do
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 mic: { type: :string, example: 'XNAS' },
                 name: { type: :string, example: 'Nasdaq Stock Market' }
               },
               required: %w[id mic name]

        run_test!
      end

      response(404, 'Exchange not found') do
        let(:id) { 'invalid-id' }

        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Exchange not found' }
               }

        run_test!
      end

      response(422, 'Invalid params') do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     mic: {
                       type: :array,
                       items: { type: :string },
                       example: ['mic can only contain letters and numbers']
                     },
                     name: {
                       type: :array,
                       items: { type: :string },
                       example: ["can't be blank", 'is too long (maximum is 256 characters)']
                     }
                   }
                 }
               }

        let(:exchange) { { mic: '', name: 'Test Exchange' } }
        run_test!

        let(:exchange) { { mic: 'AB&3', name: 'Test Exchange' } }
        run_test!

        let(:exchange) { { mic: 'TEST', name: 'a' * 257 } }
        run_test!
      end
    end

    patch 'Updates the part of exchange' do
      tags 'Exchanges'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, description: 'ID of the exchange to update', example: '1'
      parameter name: :exchange, in: :body, schema: {
        type: :object,
        properties: {
          mic: { type: :string, example: 'XNAS' },
          name: { type: :string, example: 'Nasdaq Stock Market' }
        },
        required: %w[mic name]
      }
      let(:ex) { FactoryBot.create(:exchange) }

      let(:id) { ex.id }
      let(:exchange) { { mic: 'XNAS', name: 'Nasdaq Stock Market' } }

      response(200, 'Exchange updated') do
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 mic: { type: :string, example: 'XNAS' },
                 name: { type: :string, example: 'Nasdaq Stock Market' }
               },
               required: %w[id mic name]

        run_test!
      end

      response(404, 'Exchange not found') do
        let(:id) { 'invalid-id' }

        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Exchange not found' }
               }

        run_test!
      end

      response(422, 'Invalid params') do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     mic: {
                       type: :array,
                       items: { type: :string },
                       example: ['mic can only contain letters and numbers']
                     },
                     name: {
                       type: :array,
                       items: { type: :string },
                       example: ["can't be blank", 'is too long (maximum is 256 characters)']
                     }
                   }
                 }
               }

        let(:exchange) { { mic: '', name: 'Test Exchange' } }
        run_test!

        let(:exchange) { { mic: 'AB&3', name: 'Test Exchange' } }
        run_test!

        let(:exchange) { { mic: 'TEST', name: 'a' * 257 } }
        run_test!
      end
    end

    delete 'Deletes an exchange' do
      tags 'Exchanges'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, description: 'ID of the exchange to update', example: '1'
      let!(:exchange) { FactoryBot.create(:exchange) }

      response(200, 'Exchange deleted') do
        let(:id) { exchange.id }

        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 mic: { type: :string, example: 'XNAS' },
                 name: { type: :string, example: 'Nasdaq Stock Market' }
               },
               required: %w[id mic name]

        run_test!
      end

      response(404, 'Exchange not found') do
        let(:id) { 'invalid-id' }

        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Exchange not found' }
               }
        run_test!
      end
    end
  end
end

