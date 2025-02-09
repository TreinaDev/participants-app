source "https://rubygems.org"

# 📌 Framework e Configuração Principal
gem "rails", "~> 8.0.1"
gem "puma", ">= 5.0"
gem "sqlite3", ">= 2.1"
gem "tzinfo-data", platforms: %i[windows jruby]

# 📌 Frontend e Assets
gem "importmap-rails"
gem "jbuilder"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "propshaft"

# 📌 Autenticação e Segurança
gem "devise", "~> 4.9"
gem "rack-cors"

# 📌 API e Comunicação Externa
gem "faraday", "~> 2.12"
gem "cpf_cnpj", "~> 1.0"                # Validação de CPF e CNPJ
gem "carmen"                            # Dados geográficos

# 📌 Jobs e Cache
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# 📌 QR Code e Processamento de Imagem
gem "rqrcode"                           # Geração de QR codes
gem "image_processing", "~> 1.2"        # Manipulação de imagens para Active Storage

# 📌 Melhorias de Performance e Entrega de Arquivos Estáticos
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails"
  gem "capybara"
  gem "cuprite"
  gem "simplecov", require: false
  gem "factory_bot_rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "shoulda-matchers", "~> 6.4"         # Matchers para RSpec
  gem "webmock"                            # Mock de requisições HTTP
end
