<p align="center">
  <img width="200" src="https://cdn.freebiesupply.com/logos/thumbs/2x/rails-1-logo.png" alt="Rails Logo">
</p>

# Stock quotes API with Ruby on Rails

This repository contains a simple Stock Quotes API built in Ruby on Rails that utilizes Postgres as its primary database. The API is designed to handle basic CRUD operations for stock quotes concurrently.

## Setup

Before running the application, ensure that you have Rails and Postgres installed on your system.

1. Clone the repository:

   ```bash
   git clone https://github.com/Jakub-Ignatowicz/StockQuotesAPI.git
   cd StockQuotesAPI 
   ```

2. Install dependencies:

   ```bash
   bundle
   ```

3. Run the application:
   ```bash
   rails s
   ```

## API Routes and Example Usage

For example usage of this API you can clone this repo and go to route /api-docs/index.html or just check out it right here:   

## Concurrency 

Handling concurrency for every model with optimistic locking what you can see in "concurrency" section of each model spec file

## Dependencies

- github.com/rspec/rspec-rails: Testing library.
- github.com/thoughtbot/factory_bot_rails: Simplifies data generation for testing.
- github.com/faker-ruby/faker: Provides dummy data for testing. 
- github.com/ddnexus/pagy: Pagination library. 
- github.com/rswag/rswag: Auto-generation for documentation of API with rspec.
