# BankStone
[![Hex version badge](https://img.shields.io/hexpm/v/bank_stone.svg)](https://hex.pm/packages/bank_stone)
[![CircleCI](https://circleci.com/gh/theguuholi/bank_stone.svg?style=svg)](https://circleci.com/gh/theguuholi/bank_stone)
[![codecov](https://codecov.io/gh/theguuholi/bank_stone/branch/master/graph/badge.svg)](https://codecov.io/gh/theguuholi/bank_stone)

# Api publica para utilizacao sem ter necessidade de clonar o Projeto
* [`Api Documentation`](https://documenter.getpostman.com/view/3640132/SW17RumD)
* Postman [`Workdspace`](https://www.getpostman.com/collections/0e7d3ce6152c3b1e15f2)

# Informacoes Tecnicas
* Ecossistema Elixir

## Ferramentas em geral para CI e CD
* CI - CircleCi, porque eu acho simples de utilizar e tem um visual bacana
* Analise de Cobertura, CodeCov.
* CD - Infelizmente nao implementei, porque tive duvida durante todo o desenvolvimento em qual nuvem hospedar (GCP, Aws ou gigalixir)
* Deploy local: Gigalixir porque eu nao preciso gastar com nuvem, e porque e simples de utilizar o Gigalixir

## Ferramentas para desenvolvimento
* Formatter, garante um codigo legivel
* Credo, analise de codigo e qualidade
* Sobelow, seguranca
* Coveralls, relatorio de testes

# Start da aplicacao

Independente do ambiente, seja teste, dev ou prod, eu recomendo configurar o arquivo
[`.env`](https://github.com/theguuholi/bank_stone/blob/master/.env)

## ENV
* gmail, foi o que utilizei, favor validar as politicas de seguranca do google para disparar emails, antes de colocar os dados da sua conta
* Variaveis de banco de dados e keybases

To start your Phoenix server Local:
  * You must have *Elixir, Phoenix and Postgresql* Installed
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Start api with Docker:
  * You must have *Docker* and *Docker-compose*
  * To start the application `docker-compose up`
  * Running all tests with `docker-compose exec api mix test` after start application
  * Running all tests with coverage `docker-compose exec api mix coveralls` after start application
