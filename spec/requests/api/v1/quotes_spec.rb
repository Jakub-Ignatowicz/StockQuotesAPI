require 'swagger_helper'

describe 'Api::V1::QuotesController', type: :request do
  path '/api/v1/quotes' do
    get 'Get all paginated quotes' do
      tags 'Quotes'
      let(:items) { 20 }
      let(:page) { 1 }
      let(:instrument_id) { 1 }
      let(:time) { '2023-03-29T20:35:12.000Z' }
      let(:open) { 1235.1234 }
      let(:close) { 1234.5678 }
      let(:high) { 1236.0 }
      let(:low) { 1233.9999 }
      let(:volume) { 10_000 }
      parameter name: 'page', in: :query, type: :integer, description: 'Current page number', example: 1
      parameter name: 'items', in: :query, type: :integer,
                description: 'Number of items per page(default 20 and maximum of 100)', example: 20
      parameter name: 'instrument_id', in: :query, type: :integer, description: 'Id of an instrument that quote belongs to',
                example: 1
      parameter name: 'time', in: :query, type: :string, format: 'date-time', description: 'Timestamp of quote you want to find',
                example: '2023-03-29T20:35:12.000Z'
      parameter name: 'open', in: :query, type: :number, description: 'Open price of quote you want to find',
                example: 1235.1234
      parameter name: 'close', in: :query, type: :number, description: 'Close price of quote you want to find',
                example: 1234.5678
      parameter name: 'high', in: :query, type: :number, description: 'High price of quote you want to find',
                example: 1236.0
      parameter name: 'low', in: :query, type: :number, description: 'Low price of quote you want to find',
                example: 1233.9999
      parameter name: 'volume', in: :query, type: :integer, description: 'How many transactions happened in this quote',
                example: 10_000

      produces 'application/json'

      response '200', 'Quotes retrieved' do
        let!(:quotes) { FactoryBot.create_list(:quote, 3) }

        schema type: :object,
               properties: {
                 records: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer, example: 1 },
                       time: { type: :string, example: '2023-03-29T20:35:12.000Z' },
                       instrument_id: { type: :integer, example: 1 },
                       ticker: { type: :string, example: 'AMZN' },
                       mic: { type: :string, example: 'XNGS' },
                       low: { type: :number, example: 1233.9999 },
                       high: { type: :number, example: 1236.0 },
                       open: { type: :number, example: 1235.1234 },
                       close: { type: :number, example: 1234.5678 },
                       volume: { type: :integer, example: 10_000 }
                     },
                     required: %w[id instrument_id ticker mic low high open close volume]
                   }
                 },

                 pagination: {
                   type: :object,
                   properties: {
                     current_page: { type: :integer, example: 1 },
                     pages_count: { type: :integer, example: 13 },
                     render_count: { type: :integer, example: 1 },
                     items_count: { type: :integer, example: 13 },
                     prev_url: { type: :string, example: '/api/v1/quotes?page=' },
                     next_url: { type: :string, example: '/api/v1/quotes?page=2' }
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
    post('Create an quote') do
      tags 'Quotes'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :quote, in: :body, schema: {
        type: :object,
        properties: {
          instrument_id: { type: :integer, example: 1 },
          time: { type: :string, example: '2023-03-29T20:35:12.000Z' },
          low: { type: :number, example: 1233.9999 },
          high: { type: :number, example: 1236.0 },
          open: { type: :number, example: 1235.1234 },
          close: { type: :number, example: 1234.5678 },
          volume: { type: :integer, example: 10_000 }
        },
        required: %w[instrument_id time low high open close volume]
      }
      let(:instrument) { FactoryBot.create(:instrument) }

      response(201, 'Created quote') do
        let(:quote) { FactoryBot.create(:quote) }

        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 instrument_id: { type: :integer, example: 1 },
                 time: { type: :string, example: '2023-03-29T20:35:12.000Z' },
                 ticker: { type: :string, example: 'AMZN' },
                 mic: { type: :string, example: 'XNGS' },
                 low: { type: :number, example: 1233.9999 },
                 high: { type: :number, example: 1236.0 },
                 open: { type: :number, example: 1235.1234 },
                 close: { type: :number, example: 1234.5678 },
                 volume: { type: :integer, example: 10_000 }
               },
               required: %w[id instrument_id ticker mic low high open close volume]
        run_test!
      end

      response(422, 'Invalid params') do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     low: {
                       type: :array,
                       items: { type: :string },
                       example: ['must exist']
                     }
                   }
                 }
               }
        let(:quote) do
          { instrument_id: instrument.id, low: -1, high: 0.11e1, open: 0.11e1, close: 0.11e1, volume: 10_000 }
        end
        run_test!
      end
    end
  end
  path '/api/v1/quotes/{id}' do
    get 'Retrieves just one quote' do
      tags 'Quotes'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'ID of the quote to retrieve', example: '1'

      response '200', 'Quote found' do
        let!(:quote) { FactoryBot.create(:quote) }
        let(:id) { quote.id }

        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 instrument_id: { type: :integer, example: 1 },
                 time: { type: :string, example: '2023-03-29T20:35:12.000Z' },
                 ticker: { type: :string, example: 'AMZN' },
                 mic: { type: :string, example: 'XNGS' },
                 low: { type: :number, example: 1233.9999 },
                 high: { type: :number, example: 1236.0 },
                 open: { type: :number, example: 1235.1234 },
                 close: { type: :number, example: 1234.5678 },
                 volume: { type: :integer, example: 10_000 }
               },
               required: %w[id instrument_id ticker mic low high open close volume]

        run_test!
      end

      response '404', 'Quote not found' do
        let(:id) { 'invalid-id' }

        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Quote not found' }
               }
        run_test!
      end
    end

    put 'Updates entire quote' do
      tags 'Quotes'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, description: 'ID of the quote to update', example: '1'
      parameter name: :quote, in: :body, schema: {
        type: :object,
        properties: {
          instrument_id: { type: :integer, example: 1 },
          time: { type: :string, example: '2023-03-29T20:35:12.000Z' },
          ticker: { type: :string, example: 'AMZN' },
          mic: { type: :string, example: 'XNGS' },
          low: { type: :number, example: 1233.9999 },
          high: { type: :number, example: 1236.0 },
          open: { type: :number, example: 1235.1234 },
          close: { type: :number, example: 1234.5678 },
          volume: { type: :integer, example: 10_000 }
        }
      }
      let(:initialQuote) { FactoryBot.create(:quote) }
      let(:instrument) { FactoryBot.create(:instrument) }

      let(:id) { initialQuote.id }

      response(200, 'Quote updated') do
        let(:quote) { { low: 123.321, high: 3213.1231 } }
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 instrument_id: { type: :integer, example: 1 },
                 time: { type: :string, example: '2023-03-29T20:35:12.000Z' },
                 ticker: { type: :string, example: 'AMZN' },
                 mic: { type: :string, example: 'XNGS' },
                 low: { type: :number, example: 1233.9999 },
                 high: { type: :number, example: 1236.0 },
                 open: { type: :number, example: 1235.1234 },
                 close: { type: :number, example: 1234.5678 },
                 volume: { type: :integer, example: 10_000 }
               }

        run_test!
      end

      response(404, 'Quote not found') do
        let(:quote) { { low: 123.321, high: 3213.1231 } }
        let(:id) { 'invalid-id' }

        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Quote not found' }
               }

        run_test!
      end

      response(422, 'Invalid params') do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     low: {
                       type: :array,
                       items: { type: :string },
                       example: ['must be greater than or equal to 0']
                     }
                   }
                 }
               }
        let(:quote) do
          { instrument_id: instrument.id, low: -1, high: 0.11e1, open: 0.11e1, close: 0.11e1, volume: 10_000 }
        end
        run_test!
      end
    end

    patch 'Updates part of a quote' do
      tags 'Quotes'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, description: 'ID of the quote to update', example: '1'
      parameter name: :quote, in: :body, schema: {
        type: :object,
        properties: {
          instrument_id: { type: :integer, example: 1 },
          time: { type: :string, example: '2023-03-29T20:35:12.000Z' },
          ticker: { type: :string, example: 'AMZN' },
          mic: { type: :string, example: 'XNGS' },
          low: { type: :number, example: 1233.9999 },
          high: { type: :number, example: 1236.0 },
          open: { type: :number, example: 1235.1234 },
          close: { type: :number, example: 1234.5678 },
          volume: { type: :integer, example: 10_000 }
        }
      }
      let(:initialQuote) { FactoryBot.create(:quote) }
      let(:instrument) { FactoryBot.create(:instrument) }

      let(:id) { initialQuote.id }

      response(200, 'Quote updated') do
        let(:quote) { { low: 123.321, high: 3213.1231 } }
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 instrument_id: { type: :integer, example: 1 },
                 time: { type: :string, example: '2023-03-29T20:35:12.000Z' },
                 ticker: { type: :string, example: 'AMZN' },
                 mic: { type: :string, example: 'XNGS' },
                 low: { type: :number, example: 1233.9999 },
                 high: { type: :number, example: 1236.0 },
                 open: { type: :number, example: 1235.1234 },
                 close: { type: :number, example: 1234.5678 },
                 volume: { type: :integer, example: 10_000 }
               }

        run_test!
      end

      response(404, 'Quote not found') do
        let(:quote) { { low: 123.321, high: 3213.1231 } }
        let(:id) { 'invalid-id' }

        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Quote not found' }
               }

        run_test!
      end

      response(422, 'Invalid params') do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     low: {
                       type: :array,
                       items: { type: :string },
                       example: ['must be greater than or equal to 0']
                     }
                   }
                 }
               }
        let(:quote) do
          { instrument_id: instrument.id, low: -1, high: 0.11e1, open: 0.11e1, close: 0.11e1, volume: 10_000 }
        end
        run_test!
      end
    end

    delete 'Deletes a quote' do
      tags 'Quotes'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, description: 'ID of the quote to update', example: '1'
      let!(:quote) { FactoryBot.create(:quote) }

      response(200, 'Quote deleted') do
        let(:id) { quote.id }

        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 instrument_id: { type: :integer, example: 1 },
                 time: { type: :string, example: '2023-03-29T20:35:12.000Z' },
                 ticker: { type: :string, example: 'AMZN' },
                 mic: { type: :string, example: 'XNGS' },
                 low: { type: :number, example: 1233.9999 },
                 high: { type: :number, example: 1236.0 },
                 open: { type: :number, example: 1235.1234 },
                 close: { type: :number, example: 1234.5678 },
                 volume: { type: :integer, example: 10_000 }
               }

        run_test!
      end

      response(404, 'Quote not found') do
        let(:id) { 'invalid-id' }

        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Quote not found' }
               }
        run_test!
      end
    end
  end
end

