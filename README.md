# Search box with analitics

## Description

This is a simple articles website with search box. But each search request is saved in database and can be used for analitics. Data is will be saved in real time. 

## Installation

1. Clone this repository

```bash
git clone
```

2. Install requirements

```bash
bundle install 

yarn install 
```

3. Create database

```bash
rails db:create 🗄
```

4. Run migrations

```bash
rails db:migrate 🚀
```

5. Run seeds

```bash
rails db:seed 🌱
```

6. Run redis server

```bash
redis-server
```

7. Run server

```bash
bin/dev 🚀
```

## Usage

1. Open your browser and go to http://localhost:3000
2. Type what you want to search in search box
3. Click on search button
4. Go to http://localhost:3000/arguments to see all search requests

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
