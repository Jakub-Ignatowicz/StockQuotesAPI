require 'swagger_helper'

describe 'Api::V1::InstrumentsController', type: :request do
  path '/api/v1/instruments' do
    get 'Get all paginated instruments' do
      tags 'Instruments'
      let(:items) { 20 }
      let(:page) { 1 }
      let(:name) { 'Apple' }
      let(:ticker) { 'AAPL' }
      let(:exchange_id) { 1 }
      parameter name: 'page', in: :query, type: :integer, description: 'Current page number', example: 1
      parameter name: 'items', in: :query, type: :integer,
                description: 'Number of items per page(default 20 and maximum of 100)', example: 20
      parameter name: 'name', in: :query, type: :string, description: 'Name of a instrument you want to find',
                example: 'Apple'
      parameter name: 'ticker', in: :query, type: :string, description: 'Ticker of a instrument you want to find',
                example: 'AAPL'
      parameter name: 'exchange_id', in: :query, type: :integer,
                description: 'Id of exchange that instrument you are searching on is listed on', example: 1

      produces 'application/json'

      response '200', 'Instruments retrieved' do
        let!(:instruments) { FactoryBot.create_list(:instrument, 3) }

        schema type: :object,
               properties: {
                 records: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer, example: 1 },
                       ticker: { type: :string, example: 'AAPL' },
                       name: { type: :string, example: 'Apple' },
                       mic: { type: :string, example: 'XNAS' },
                       exchange_id: { type: :integer, example: 1 }
                     },
                     required: %w[id ticker name mic exchange_id]
                   }
                 },

                 pagination: {
                   type: :object,
                   properties: {
                     current_page: { type: :integer, example: 1 },
                     pages_count: { type: :integer, example: 13 },
                     render_count: { type: :integer, example: 1 },
                     items_count: { type: :integer, example: 13 },
                     prev_url: { type: :string, example: '/api/v1/instruments?page=' },
                     next_url: { type: :string, example: '/api/v1/instruments?page=2' }
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
    post('Create an instrument') do
      tags 'Instruments'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :instrument, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Apple' },
          ticker: { type: :string, example: 'AAPL' },
          mic: { type: :string, example: 'XNGS' },
          exchange_id: { type: :integer, example: 1 }
        },
        required: %w[mic name exchange_id]
      }
      let(:exchange) { FactoryBot.create(:exchange) }

      response(201, 'Created instrument') do
        # TODO
        let(:instrument) { { ticker: 'TEST', name: 'Test Instrument', exchange_id: exchange.id } }

        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 ticker: { type: :string, example: 'AAPL' },
                 name: { type: :string, example: 'Apple' },
                 mic: { type: :string, example: 'XNGS' },
                 exchange_id: { type: :integer, example: 'Nasdaq Stock Market' }
               },
               required: %w[ticker name exchange_id]
        run_test!
      end

      response(422, 'Invalid params') do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     ticker: {
                       type: :array,
                       items: { type: :string },
                       example: ['ticker can only contain letters and numbers']
                     },
                     name: {
                       type: :array,
                       items: { type: :string },
                       example: ["can't be blank"]
                     },
                     exchange: {
                       type: :array,
                       items: { type: :string },
                       example: ['must exist']
                     }

                   }
                 }
               }
        let(:instrument) { { ticker: 'T@ST', name: 'Test Instrument', exchange_id: exchange.id } }
        run_test!

        let(:instrument) { { ticker: 'TEST', name: '', exchange_id: exchange.id } }
        run_test!

        let(:instrument) { { ticker: 'T@ST', name: 'Test Instrument', exchange_id: 234_341_234 } }
        run_test!
      end
    end
  end
  path '/api/v1/instruments/{id}' do
    get 'Retrieves just one instrument' do
      tags 'Instruments'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'ID of the instrument to retrieve', example: '1'

      response '200', 'Instrument found' do
        let!(:instrument) { FactoryBot.create(:instrument) }
        let(:id) { instrument.id }

        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 ticker: { type: :string, example: 'AAPL' },
                 name: { type: :string, example: 'Apple' },
                 mic: { type: :string, example: 'XNGS' },
                 exchange_id: { type: :integer, example: 'Nasdaq Stock Market' }
               },
               required: %w[id ticker name exchange_id]

        run_test!
      end

      response '404', 'Instrument not found' do
        let(:id) { 'invalid-id' }

        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Instrument not found' }
               }
        run_test!
      end
    end

    put 'Updates entire instrument' do
      tags 'Instruments'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, description: 'ID of the instrument to update', example: '1'
      parameter name: :instrument, in: :body, schema: {
        type: :object,
        properties: {
          ticker: { type: :string, example: 'AAPL' },
          name: { type: :string, example: 'Apple' },
          mic: { type: :string, example: 'XNGS' },
          exchange_id: { type: :integer, example: 'Nasdaq Stock Market' }
        }
      }
      let(:ins) { FactoryBot.create(:instrument) }

      let(:id) { ins.id }
      let(:instrument) { { Ticker: 'NEW', name: 'APPLE' } }

      response(200, 'Instrument updated') do
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 ticker: { type: :string, example: 'AAPL' },
                 name: { type: :string, example: 'Apple' },
                 mic: { type: :string, example: 'XNGS' },
                 exchange_id: { type: :integer, example: 'Nasdaq Stock Market' }
               },
               required: %w[id mic name]

        run_test!
      end

      response(404, 'Instrument not found') do
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
                     ticker: {
                       type: :array,
                       items: { type: :string },
                       example: ['ticker can only contain letters and numbers']
                     },
                     name: {
                       type: :array,
                       items: { type: :string },
                       example: ["can't be blank"]
                     },
                     exchange: {
                       type: :array,
                       items: { type: :string },
                       example: ['must exist']
                     }

                   }
                 }
               }
        let(:instrument) { { ticker: 'T@ST', name: 'Test Instrument', exchange_id: exchange.id } }
        run_test!

        let(:instrument) { { ticker: 'TEST', name: '', exchange_id: exchange.id } }
        run_test!

        let(:instrument) { { ticker: 'T@ST', name: 'Test Instrument', exchange_id: 234_341_234 } }
        run_test!
      end
    end

    patch 'Updates part of instrument' do
      tags 'Instruments'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, description: 'ID of the instrument to update', example: '1'
      parameter name: :instrument, in: :body, schema: {
        type: :object,
        properties: {
          ticker: { type: :string, example: 'AAPL' },
          name: { type: :string, example: 'Apple' },
          mic: { type: :string, example: 'XNGS' },
          exchange_id: { type: :integer, example: 'Nasdaq Stock Market' }
        }
      }
      let(:ins) { FactoryBot.create(:instrument) }
      let(:id) { ins.id }
      let(:instrument) { { Ticker: 'NEW', name: 'APPLE' } }

      response(200, 'Instrument updated') do
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 ticker: { type: :string, example: 'AAPL' },
                 name: { type: :string, example: 'Apple' },
                 mic: { type: :string, example: 'XNGS' },
                 exchange_id: { type: :integer, example: 'Nasdaq Stock Market' }
               },
               required: %w[id mic name]

        run_test!
      end

      response(404, 'Instrument not found') do
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
                     ticker: {
                       type: :array,
                       items: { type: :string },
                       example: ['ticker can only contain letters and numbers']
                     },
                     name: {
                       type: :array,
                       items: { type: :string },
                       example: ["can't be blank"]
                     },
                     exchange: {
                       type: :array,
                       items: { type: :string },
                       example: ['must exist']
                     }

                   }
                 }
               }
        let(:instrument) { { ticker: 'T@ST', name: 'Test Instrument', exchange_id: exchange.id } }
        run_test!

        let(:instrument) { { ticker: 'TEST', name: '', exchange_id: exchange.id } }
        run_test!

        let(:instrument) { { ticker: 'T@ST', name: 'Test Instrument', exchange_id: 234_341_234 } }
        run_test!
      end
    end

    delete 'Deletes an instrument' do
      tags 'Instruments'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, description: 'ID of the instrument to update', example: '1'
      let!(:instrument) { FactoryBot.create(:instrument) }

      response(200, 'Instrument deleted') do
        let(:id) { instrument.id }

        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 ticker: { type: :string, example: 'AAPL' },
                 name: { type: :string, example: 'Apple' },
                 mic: { type: :string, example: 'XNGS' },
                 exchange_id: { type: :integer, example: 'Nasdaq Stock Market' }
               },
               required: %w[id mic name]

        run_test!
      end

      response(404, 'Instrument not found') do
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

