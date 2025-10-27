# 🎬 Mainô Filmes

Mainô Filmes é uma aplicação Ruby on Rails 8 moderna para gerenciamento de filmes, com automação, design responsivo, integração com IA, arquitetura escalável e recursos avançados.

---

## 💡 **Destaques do Projeto**

- **Arquitetura Clean & Service Objects:**  
  Toda lógica de negócio foi extraída dos controllers para Service Objects em `app/services/`, seguindo princípios SOLID e Clean Architecture.  
  Isso garante testabilidade, manutenibilidade e separação clara de responsabilidades.

- **Internacionalização Completa (i18n):**  
  Suporte dinâmico a português e inglês, inclusive nas rotas e interface.

- **Importação em Massa com Sidekiq + Redis:**  
  Upload de CSV processado em background, com status em tempo real e notificação por e-mail ao usuário.

- **Integração com OpenAI (GPT-4o-mini):**  
  Preenchimento automático de dados do filme via IA, incluindo categoria inteligente e tags.

- **Sessão de Comentário Anônimo Segura:**  
  Comentários podem ser feitos sem login.  
  O sistema identifica o autor anônimo via cookie/sessão (`anon_session_id`), permitindo que apenas ele edite ou exclua seu comentário, sem exigir autenticação.  
  Se o cookie não bater, os botões de editar/excluir não aparecem nem funcionam.

- **Permissões e Segurança:**  
  Usuários autenticados só podem editar/excluir seus próprios filmes e comentários.  
  Comentários anônimos só podem ser editados/excluídos pelo autor da sessão.

- **Design Moderno e Tema Escuro:**  
  Layout responsivo, fonte Poppins, UX aprimorada, botões animados e navegação intuitiva.

- **Testes e Cobertura:**  
  Código organizado para facilitar testes automatizados.  
  Cobertura de models, controllers e helpers.

- **Upload de Arquivos com Active Storage:**  
  Pôster de filmes com processamento de imagem seguro.

- **Paginação eficiente com Kaminari.**

---

## ⚙️ Funcionalidades

- CRUD de filmes com upload de pôster
- Categorias e tags dinâmicas (criação automática via IA)
- Busca e filtros avançados
- Comentários autenticados e anônimos (com controle de sessão)
- Autenticação via Devise
- Importação em massa via CSV (Sidekiq + Redis)
- Notificação por e-mail ao importar filmes
- Internacionalização (português e inglês)
- Tema escuro e layout responsivo

---

## 🏗️ **Arquitetura e Organização**

- **Service Objects:**

  - `Movies::FilterService` — Filtros e busca de filmes
  - `Movies::AssignTagsService` — Atribuição de tags
  - `Movies::FetchMovieDataService` — Integração com IA
  - `Movies::AuthorizeUserService` — Permissões
  - `Categories::CreateCategoryService` — Criação sem duplicidade
  - `Categories::DestroyCategoryService` — Remoção segura

- **Sessão de Comentário Anônimo:**

  - Campo `anon_session_id` salvo no comentário e no cookie do navegador
  - Só o autor da sessão vê e pode usar os botões de editar/excluir
  - Comentários anônimos nunca podem ser editados/excluídos por terceiros

- **Background Jobs:**

  - Importação CSV processada por `MovieImportWorker`
  - Status atualizado em tempo real
  - E-mail enviado ao usuário ao finalizar (sucesso ou erro)

- **Integração com IA:**

  - Endpoint `/movies/fetch_movie_data?title=`
  - Preenche todos os campos do filme, inclusive categoria e tags
  - Cria categoria automaticamente se não existir, sem duplicidade (case/acento-insensitive)

- **Internacionalização:**
  - Todas as mensagens, labels e rotas adaptadas dinamicamente
  - Suporte total a PT e EN

---

## 🚀 Como rodar o projeto localmente

1. **Clone o repositório**

   ```bash
   git clone https://github.com/bellaFG/desafio-maino-filmes.git
   cd desafio-maino-filmes
   ```

2. **Instale as dependências**

   ```bash
   bundle install
   yarn install
   ```

3. **Configure o banco de dados**

   ```bash
   rails db:create db:migrate db:seed
   ```

4. **Configure variáveis de ambiente**
   Crie um arquivo `.env` na raiz:

   ```
   OPENAI_API_KEY=your_openai_api_key
   SMTP_USERNAME=your_mailtrap_username
   SMTP_PASSWORD=your_mailtrap_password
   ```

5. **Suba o Redis (necessário para Sidekiq)**

   ```bash
   docker run -d --name redis-maino -p 6379:6379 redis
   ```

6. **Rode o Sidekiq (em outro terminal)**

   ```bash
   bundle exec sidekiq
   ```

7. **Inicie o servidor Rails**
   ```bash
   rails s
   ```

Acesse [http://localhost:3000](http://localhost:3000)

---

## 🧪 Como rodar os testes

Execute todos os testes automatizados do projeto com:

```bash
rails test
```

Os testes cobrem models, controllers, helpers e garantem que toda a arquitetura e funcionalidades estejam funcionando conforme esperado.

---

## 📦 Importação em massa via CSV

- Acesse a página principal de filmes e clique em **Importar CSV**.
- Faça upload de um arquivo `.csv` com o seguinte formato:

  ```csv
  title,director,year,duration,synopsis
  Interestelar,Christopher Nolan,2014,169,Um grupo de astronautas viaja através de um buraco de minhoca...
  O Poderoso Chefão,Francis Ford Coppola,1972,175,Um épico sobre uma família mafiosa americana.
  ```

- O processamento é feito em background via Sidekiq.
- O status da importação pode ser acompanhado na tela de histórico.
- Ao final, você receberá um e-mail de notificação (Mailtrap).

---

## 🧠 Preenchimento automático via IA

- Digite o título do filme e clique em "Preencher dados com IA".
- Os campos de sinopse, ano, duração, diretor, categoria e tags serão preenchidos automaticamente.
- Se a categoria sugerida pela IA não existir, ela será criada automaticamente (sem duplicidade).

---

## 💬 Comentários Anônimos com Controle de Sessão

- Usuários não autenticados podem comentar.
- O sistema salva um identificador único no cookie do navegador.
- Só o autor anônimo pode editar/excluir seu comentário (mesma sessão/navegador).
- Botões de editar/excluir só aparecem para o dono do comentário.
- Comentários autenticados continuam protegidos pelo login.

---

## ✅ Funcionalidades opcionais concluídas

- Importação em massa via CSV com processamento em background (Sidekiq)
- Notificação por e-mail ao finalizar importação
- Preenchimento automático de dados via OpenAI
- Internacionalização (i18n)
- Tema escuro e layout responsivo
- Comentário anônimo seguro por sessão

---

## 📝 Observações

- Para rodar Sidekiq, é necessário o Redis ativo.
- O envio de e-mails utiliza Mailtrap para ambiente de desenvolvimento.
- O deploy pode ser feito em Render, mas Sidekiq/Redis só funcionam localmente em plano gratuito.

---

## ✉️ E-mails de Notificação e Recuperação de Senha

- O envio de e-mails (notificações de importação, recuperação de senha, etc.) é feito via **SendGrid API**.
- Para produção (Render), configure as variáveis de ambiente:
  - `SENDGRID_API_KEY` — sua chave da API do SendGrid
  - `MAIL_SENDER` — e-mail verificado no painel do SendGrid
- **Atenção:**  
  No plano gratuito do Render, os e-mails enviados pelo SendGrid costumam cair na caixa de spam.  
  Recomende aos usuários que verifiquem o spam ao solicitar recuperação de senha ou notificações.

---

## 👩‍💻 Autor

Desenvolvido por Isabella Fernandes Gonzales para o Desafio Técnico Full Stack — Mainô.

---
