
# Participants-App | Gerenciamento de Inscrições
Esta aplicação foi desenvolvida para gerenciar inscrições em eventos, conectando participantes com interesses em comum. A ideia principal é oferecer funcionalidades que permitam a organização de eventos para os participantes, a interação entre eles e a compra de ingressos.

![](https://img.shields.io/github/issues/TreinaDev/participants-app.svg)
![](https://img.shields.io/github/issues-pr/TreinaDev/participants-app.svg)

![Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)

## 🚀 Funcionalidades
### ✅ **Visualizar Eventos**
- Lista de eventos publicados com data a partir do dia atual.
- Exibição de detalhes como:
  - Descrição completa.
  - Nome do organizador.
  - Agenda do evento.
  - Valor do ingresso.
  - Botão para compra de ingresso (se disponível) ou mensagem de esgotado.

### ✅ **Criar Conta de Participante**
- Cadastro de novos usuários com nome, sobrenome, cpf, e-mail e senha.
- Possibilidade de completar o perfil com:
  - Links para redes sociais.
  - Cidade, estado e telefone.
- Salvar eventos como favoritos.
- Visualizar lista de ingressos adquiridos.
- Visulizar lista de feedbacks feitos.

### ✅ **Compra de Ingressos** 
- Escolha de ingressos disponíveis na página de detalhes do evento.
- Compra com status temporário de “ingresso confirmado”.
- Exibição de ingressos comprados na seção "Meus ingressos".

### ✅ **Ingresso QR Code e Controle de Entrada**
- Cada ingresso confirmado possui:
  - Token único de 36 caracteres alfanuméricos.
  - QR Code gerado para controle de acesso.
- Registro de utilização do ingresso:
  - Apenas uma vez por dia configurado no evento.

### ✅ **Lembretes para Ingressos**
- Solicitação de lembrete para eventos futuros sem ingressos disponíveis.
- Envio de e-mail no dia da abertura de vendas de ingressos.

### ✅ **Feed do Evento**
- Feed para postagens entre participantes com ingresso confirmado.
- Recursos do feed:
  - Suporte a texto enriquecido.
  - Upload de imagens.
  - Curtidas e comentários.
- Resumo das últimas 10 postagens na página inicial do usuário.
- Comunicados oficiais destacados, sem curtidas ou comentários.
- Feedbacks feitos pelos usuários que participaram do evento.

### ✅ **Feedbacks**
- Após o evento, usuários podem fornecer feedback:
  - Feedback geral ou específico por item da agenda.
  - Público ou anônimo.
- Feedbacks públicos aparecem no feed do evento.
- Palestrantes do evento podem responder feedbacks.
- Organizadores têm acesso a todos os feedbacks.

## 📝 Pré-requisitos
1. Setup:
   - Ruby 3.3.2+
   - Rails 8.0.1+
   - SQLite

2. Gems:
    - [capybara](https://github.com/teamcapybara/capybara)
    - [carmen](https://github.com/carmen-ruby/carmen)
    - [cpf_cnpj](https://github.com/fnando/cpf_cnpj)
    - [cuprite](https://github.com/rubycdp/cuprite)
    - [devise](https://github.com/heartcombo/devise)
    - [faraday](https://github.com/lostisland/faraday)
    - [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)
    - [image_processing](https://github.com/janko/image_processing)
    - [rack-cors](https://github.com/cyu/rack-cors)
    - [rqrcode](https://github.com/whomwah/rqrcode)
    - [rspec-rails](https://github.com/rspec/rspec-rails)
    - [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
    - [simplecov](https://github.com/simplecov-ruby/simplecov)
    - [solid_cache](https://github.com/rails/solid_cache)
    - [solid_cable](https://github.com/rails/solid_cable)
    - [solid_queue](https://github.com/rails/solid_queue)
    - [stimulus-rails](https://github.com/hotwired/stimulus-rails)
    - [tailwindcss-rails](https://github.com/rails/tailwindcss-rails)

## 💻 Como Contruir
Para construir o projeto, siga estas etapas:

```bash
# Abra o terminal (Prompt de comando ou PowerShell para Windows, Terminal para macOS ou Linux)
# Clone este repositório:
git clone https://github.com/TreinaDev/participants-app.git

# Navegue para a pasta do projeto:
cd participants-app

# Instale as dependências:
bundle install

# Crie e migre o banco de dados:
rails db:create
rails db:migrate

# Também é possível rodar as seeds para popular o banco com dados iniciais:
rails db:seed

# Pré-compile os assets estáticos para melhorar visualização do css
rails assets:precompile

# Execute o servidor:
bin/dev
```

**Acesse a aplicação**:
   Abra seu navegador e acesse `http://localhost:3000` para ver o participants-app em funcionamento.

**Login no Sistema**:
   Para se logar com o usuário criado pelas seeds, use os seguintes dados:

   - Email: `master@email.com`
   - Senha: `123456`

## 🚨 Testes
1. **Execute os testes**:
   ```bash
   rspec
   ```

## 🤝 Contribuidores
[<img src="https://avatars.githubusercontent.com/u/65695476?v=4" width=115 ><br> <sub> Cristiano Santana </sub>](https://github.com/CristianoSantan)|[<img src="https://avatars.githubusercontent.com/u/182559072?v=4" width=115 > <br> <sub> César Faustino </sub>](https://github.com/cmf000)|[<img src="https://avatars.githubusercontent.com/u/178613704?v=4" width=115 > <br> <sub> David Bolivar </sub>](https://github.com/thedavs99)|[<img src="https://avatars.githubusercontent.com/u/64371312?v=4" width=115 > <br> <sub> Gabriel Ribeiro </sub>](https://github.com/Gabriel-T-P)|[<img src="https://avatars.githubusercontent.com/u/182513782?v=4" width=115 > <br> <sub> João Branco </sub>](https://github.com/joaoCasteloBranco)|[<img src="https://avatars.githubusercontent.com/u/112505223?v=4" width=115 > <br> <sub> Samuel Rocha </sub>](https://github.com/SamuelRocha91)|
| :---: | :---: | :---: | :---: | :---: | :---: |
