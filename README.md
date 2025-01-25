
# Participants | Gerenciamento de Inscrições

Esta aplicação Ruby on Rails foi desenvolvida para gerenciar inscrições em eventos, conectando participantes com interesses em comum. A ideia principal é oferecer funcionalidades que permitam a organização de eventos, a interação entre participantes e a compra de ingressos.

## Funcionalidades

### **Visualizar Eventos**
- Lista de eventos publicados com data a partir do dia atual.
- Exibição de detalhes como:
  - Descrição completa.
  - Nome do organizador.
  - Agenda do evento.
  - Valor do ingresso.
  - Botão para compra de ingresso (se disponível) ou mensagem de esgotado.
  
### **Criar Conta de Participante**
- Cadastro de novos usuários com nome, sobrenome, e-mail e senha.
- Possibilidade de completar o perfil com:
  - Links para redes sociais.
  - Cidade, estado e telefone.
  - Outras informações relevantes.
- Salvar eventos como favoritos.
- Visualizar lista de ingressos adquiridos.

### **Compra de Ingressos**
- Escolha de ingressos disponíveis na página de detalhes do evento.
- Simulação de compra com status temporário de “ingresso confirmado”.
- Exibição de ingressos comprados na seção "Meus ingressos".

### **Ingresso QR Code e Controle de Entrada**
- Cada ingresso confirmado possui:
  - Token único de 36 caracteres alfanuméricos.
  - QR Code gerado para controle de acesso.
- Registro de utilização do ingresso:
  - Apenas uma vez por dia configurado no evento.

### **Lembretes para Ingressos**
- Solicitação de lembrete para eventos futuros sem ingressos disponíveis.
- Envio de e-mail no dia da abertura de vendas de ingressos.

### **Feed do Evento**
- Feed para postagens entre participantes com ingresso confirmado.
- Recursos do feed:
  - Suporte a texto enriquecido.
  - Upload de imagens.
  - Curtidas e comentários.
- Resumo das últimas 10 postagens na página inicial do usuário.
- Comunicados oficiais destacados, sem curtidas ou comentários.

### **Feedbacks**
- Após o evento, usuários podem fornecer feedback:
  - Feedback geral ou específico por item da agenda.
  - Público ou anônimo.
- Feedbacks públicos aparecem no feed do evento.
- Organizadores têm acesso a todos os feedbacks.

## Pré-requisitos
1. setup:
   - Ruby 3.3.5+
   - Rails 8.0.1+
   - SQLite 

2. gems instaladas:
   - gem "devise", "~> 4.9"
   - gem "faraday", "~> 2.12"
   - gem "rspec-rails"
   - gem "capybara"

## Instalação

1. **Clone este repositório**:
   ```bash
   git clone https://github.com/TreinaDev/participants-app.git
   cd participants-app
   ```

2. **Instale as dependências**:
   ```bash
   bundle install
   ```

3. **Configure o banco de dados**:
   Configure o arquivo `database.yml` conforme as necessidades do seu ambiente. Em seguida, crie e migre o banco de dados:
   ```bash
   rails db:create
   rails db:migrate
   ```
   Também é possível rodar as seeds para popular o banco com dados iniciais:
   ```bash
    rails db:seed
   ```

4. **Execute o servidor**:
   ```bash
   rails server
   ```

5. **Execute os testes**:
   ```bash
   rspec
   ```

6. **Acesse a aplicação**:
   Abra seu navegador e acesse `http://localhost:3000` para ver o participants-app em funcionamento.

7. **Login no Sistema**:
   Para se logar com o usuário criado pelas seeds, use os seguintes dados:

   - Email do dono: `user@email.com`
   - Senha: `123456`

* ...
# events_api
