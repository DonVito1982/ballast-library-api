# README

Application requisites:

* Ruby 3.2.9
* Sqlite3

## Setup

* Clone the repository
* `cd` into de repository path
* Install the dependencies
    ```bash
    bundle install
    ```
* Create a `.env` file with a `JWT_KEY` key. Similar to `.env-sample`
* Set the database
    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```
* Start the server
    ```bash
    rails s
    ```
