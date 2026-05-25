-- ============================================================
-- Frivatti Website — Supabase Schema
-- Generated: 2026-05-25
-- ============================================================

-- ============================================================
-- 1. TABLES
-- ============================================================

-- ---- banners -----------------------------------------------
create table if not exists public.banners (
  id                   uuid        primary key default gen_random_uuid(),
  badge_text           text,
  title                text        not null,
  subtitle             text,
  image_url            text,
  cta_primary_text     text        default 'Ver produtos',
  cta_primary_url      text        default '#',
  cta_secondary_text   text,
  cta_secondary_url    text,
  active               boolean     default true,
  order_index          integer     default 0,
  created_at           timestamptz default now(),
  updated_at           timestamptz default now()
);

-- ---- blog_posts --------------------------------------------
create table if not exists public.blog_posts (
  id           uuid        primary key default gen_random_uuid(),
  title        text        not null,
  category     text,
  content      text,
  excerpt      text,
  image_url    text,
  status       text        default 'draft'
               check (status in ('draft', 'published')),
  published_at timestamptz,
  created_at   timestamptz default now(),
  updated_at   timestamptz default now()
);

-- ---- vagas -------------------------------------------------
create table if not exists public.vagas (
  id           uuid        primary key default gen_random_uuid(),
  title        text        not null,
  location     text,
  type         text
               check (type in ('CLT', 'Estágio', 'PJ', 'Temporário')),
  area         text,
  description  text,
  requirements text,
  benefits     text,
  status       text        default 'published'
               check (status in ('published', 'draft', 'closed')),
  featured     boolean     default false,
  created_at   timestamptz default now(),
  updated_at   timestamptz default now()
);

-- ---- candidatos --------------------------------------------
create table if not exists public.candidatos (
  id           uuid        primary key default gen_random_uuid(),
  vaga_id      uuid        references public.vagas(id) on delete set null,
  vaga_title   text,
  name         text        not null,
  email        text,
  phone        text,
  city         text,
  cover_letter text,
  cv_url       text,
  status       text        default 'novo'
               check (status in ('novo', 'analise', 'aprovado', 'reprovado', 'arquivado')),
  notes        text,
  created_at   timestamptz default now(),
  updated_at   timestamptz default now()
);

-- ---- videos ------------------------------------------------
create table if not exists public.videos (
  id            uuid        primary key default gen_random_uuid(),
  title         text        not null,
  category      text,
  duration      text,
  thumbnail_url text,
  video_url     text,
  description   text,
  status        text        default 'published'
                check (status in ('published', 'draft')),
  order_index   integer     default 0,
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

-- ---- depoimentos -------------------------------------------
create table if not exists public.depoimentos (
  id          uuid        primary key default gen_random_uuid(),
  name        text        not null,
  role        text,
  type        text
              check (type in ('colaborador', 'parceiro')),
  quote       text,
  avatar_url  text,
  active      boolean     default true,
  order_index integer     default 0,
  created_at  timestamptz default now()
);

-- ---- produtos ----------------------------------------------
create table if not exists public.produtos (
  id          uuid        primary key default gen_random_uuid(),
  name        text        not null,
  category    text,
  description text,
  image_url   text,
  active      boolean     default true,
  order_index integer     default 0,
  created_at  timestamptz default now()
);

-- ---- obra_progresso ----------------------------------------
create table if not exists public.obra_progresso (
  id         uuid     primary key default gen_random_uuid(),
  item       text     not null,
  percentage integer  default 0
             check (percentage >= 0 and percentage <= 100),
  ordem      integer  default 0,
  updated_at timestamptz default now()
);

-- ---- obra_fotos --------------------------------------------
create table if not exists public.obra_fotos (
  id          uuid        primary key default gen_random_uuid(),
  image_url   text        not null,
  caption     text,
  order_index integer     default 0,
  created_at  timestamptz default now()
);


-- ============================================================
-- 2. ENABLE ROW LEVEL SECURITY
-- ============================================================

alter table public.banners          enable row level security;
alter table public.blog_posts       enable row level security;
alter table public.vagas            enable row level security;
alter table public.candidatos       enable row level security;
alter table public.videos           enable row level security;
alter table public.depoimentos      enable row level security;
alter table public.produtos         enable row level security;
alter table public.obra_progresso   enable row level security;
alter table public.obra_fotos       enable row level security;


-- ============================================================
-- 3. RLS POLICIES
-- ============================================================

-- ---- banners -----------------------------------------------
create policy "Public can view active banners"
  on public.banners for select
  to anon
  using (active = true);

create policy "Authenticated full access on banners"
  on public.banners for all
  to authenticated
  using (true)
  with check (true);

-- ---- blog_posts --------------------------------------------
create policy "Public can view published posts"
  on public.blog_posts for select
  to anon
  using (status = 'published');

create policy "Authenticated full access on blog_posts"
  on public.blog_posts for all
  to authenticated
  using (true)
  with check (true);

-- ---- vagas -------------------------------------------------
create policy "Public can view published vagas"
  on public.vagas for select
  to anon
  using (status = 'published');

create policy "Authenticated full access on vagas"
  on public.vagas for all
  to authenticated
  using (true)
  with check (true);

-- ---- candidatos --------------------------------------------
create policy "Anon can submit candidatura"
  on public.candidatos for insert
  to anon
  with check (true);

create policy "Authenticated full access on candidatos"
  on public.candidatos for all
  to authenticated
  using (true)
  with check (true);

-- ---- videos ------------------------------------------------
create policy "Public can view published videos"
  on public.videos for select
  to anon
  using (status = 'published');

create policy "Authenticated full access on videos"
  on public.videos for all
  to authenticated
  using (true)
  with check (true);

-- ---- depoimentos -------------------------------------------
create policy "Public can view active depoimentos"
  on public.depoimentos for select
  to anon
  using (active = true);

create policy "Authenticated full access on depoimentos"
  on public.depoimentos for all
  to authenticated
  using (true)
  with check (true);

-- ---- produtos ----------------------------------------------
create policy "Public can view active produtos"
  on public.produtos for select
  to anon
  using (active = true);

create policy "Authenticated full access on produtos"
  on public.produtos for all
  to authenticated
  using (true)
  with check (true);

-- ---- obra_progresso ----------------------------------------
create policy "Public can view obra_progresso"
  on public.obra_progresso for select
  to anon
  using (true);

create policy "Authenticated full access on obra_progresso"
  on public.obra_progresso for all
  to authenticated
  using (true)
  with check (true);

-- ---- obra_fotos --------------------------------------------
create policy "Public can view obra_fotos"
  on public.obra_fotos for select
  to anon
  using (true);

create policy "Authenticated full access on obra_fotos"
  on public.obra_fotos for all
  to authenticated
  using (true)
  with check (true);


-- ============================================================
-- 4. STORAGE BUCKET
-- ============================================================

insert into storage.buckets (id, name, public)
values ('media', 'media', true)
on conflict (id) do nothing;

create policy "Public media access"
  on storage.objects for select
  using (bucket_id = 'media');

create policy "Auth users can upload media"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'media');

create policy "Auth users can update media"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'media');

create policy "Auth users can delete media"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'media');


-- ============================================================
-- 5. SEED DATA
-- ============================================================

-- ---- obra_progresso ----------------------------------------
insert into public.obra_progresso (item, percentage, ordem) values
  ('Fundação e estrutura',                     100, 1),
  ('Instalações elétricas e hidráulicas',       82, 2),
  ('Área de produção e frigorificação',          65, 3),
  ('Acabamento e equipamentos',                  28, 4),
  ('Licenças e homologações',                    50, 5);

-- ---- vagas -------------------------------------------------
insert into public.vagas (title, location, type, area, description, requirements, benefits, status, featured) values
(
  'Médico Veterinário Campo',
  'Itaipulândia / Medianeira — PR',
  'CLT',
  'Técnica',
  'Acompanhamento sanitário e zootécnico dos produtores integrados nas regiões de Itaipulândia e Medianeira. Visitas periódicas, controle de plantel e suporte técnico ao produtor.',
  'Graduação em Medicina Veterinária com CRMV ativo. Habilitação categoria B. Disponibilidade para deslocamento regional. Experiência em suinocultura será diferencial.',
  'Veículo da empresa para deslocamento. Vale alimentação. Plano de saúde. Convênio farmácia. Participação em treinamentos e congressos da área.',
  'published',
  true
),
(
  'Operador de Produção',
  'Itaipulândia — PR',
  'CLT',
  'Produção',
  'Atuação nas linhas de produção da unidade frigorífica em Itaipulândia. Atividades de abate, corte, desossa e embalagem seguindo os padrões de qualidade e segurança alimentar da empresa.',
  'Ensino médio completo. Experiência anterior em frigorífico ou indústria alimentícia será valorizada. Disponibilidade para trabalho em turnos.',
  'Vale transporte. Vale alimentação. Cesta básica mensal. Plano de saúde após período de experiência. Uniforme e EPI fornecidos.',
  'published',
  false
),
(
  'Assistente de Logística',
  'Medianeira — PR',
  'CLT',
  'Logística',
  'Apoio às operações de recebimento, armazenagem e expedição de produtos. Controle de estoque, separação de pedidos e interface com transportadoras e clientes.',
  'Ensino médio completo. Desejável conhecimento em rotinas de logística ou almoxarifado. Habituado a trabalho em equipe e uso de planilhas eletrônicas.',
  'Vale transporte. Vale alimentação. Plano de saúde após período de experiência.',
  'published',
  false
),
(
  'Técnico Agrícola',
  'Itaipulândia / Medianeira — PR',
  'CLT',
  'Técnica',
  'Apoio técnico aos produtores integrados da região. Coleta de dados de produção, orientação em boas práticas de manejo, registro de informações no sistema da empresa e suporte ao médico veterinário responsável.',
  'Técnico Agrícola ou Agropecuário formado. Habilitação categoria B. Experiência em suinocultura ou avicultura será diferencial. Boa comunicação e disposição para trabalho em campo.',
  'Veículo da empresa para deslocamento. Vale alimentação. Plano de saúde. Oportunidade de crescimento na carreira técnica.',
  'published',
  true
),
(
  'Estágio em Marketing',
  'Medianeira — PR',
  'Estágio',
  'Marketing',
  'Auxílio na produção de conteúdo para redes sociais, criação de artes para campanhas internas e externas, apoio em eventos e feiras do setor. Oportunidade de aprendizado em marketing para o agronegócio.',
  'Cursando Publicidade e Propaganda, Marketing, Design Gráfico ou áreas afins (a partir do 2.º semestre). Conhecimento básico em ferramentas como Canva, Photoshop ou similares. Interesse pelo agronegócio.',
  'Bolsa compatível com o mercado. Vale transporte. Horário flexível para conciliar com estudos.',
  'published',
  false
);

-- ---- depoimentos -------------------------------------------
insert into public.depoimentos (name, role, type, quote, avatar_url, active, order_index) values
(
  'João Pedro Kessler',
  'Líder de Turno — Itaipulândia · 7 anos',
  'colaborador',
  'Trabalho na Frivatti há 7 anos e cresci dentro da empresa. Entrei como auxiliar de produção e hoje sou líder de turno. O clima é bom, tem respeito e as lideranças ouvem a gente.',
  'https://i.pravatar.cc/88?img=47',
  true,
  1
),
(
  'Simone Bellé',
  'Assistente de Qualidade — Medianeira · 4 anos',
  'colaborador',
  'O que mais valorizo aqui é a estabilidade. Tenho família, preciso de segurança — e a Frivatti me dá isso. Os benefícios são competitivos e a empresa está crescendo, o que nos anima.',
  'https://i.pravatar.cc/88?img=44',
  true,
  2
),
(
  'Camila Eberhardt',
  'Médica Veterinária de Campo · 2 anos',
  'colaborador',
  'Como veterinária de campo, tenho autonomia pra trabalhar e suporte quando preciso. A empresa investe em capacitação e o trabalho com os produtores é muito gratificante.',
  'https://i.pravatar.cc/88?img=49',
  true,
  3
),
(
  'Leandro Hartmann',
  'Representante comercial — Cascavel/PR · 8 anos',
  'parceiro',
  'Represento a Frivatti há 8 anos na região de Cascavel. O diferencial está na consistência do produto e no suporte pós-venda. Nunca tive problema que não fosse resolvido com rapidez.',
  'https://i.pravatar.cc/88?img=14',
  true,
  4
),
(
  'Valdir Ronsoni',
  'Produtor integrado — Matelândia/PR · 12 anos',
  'parceiro',
  'Integrado há 12 anos. O suporte técnico da Frivatti é o que me fez crescer. Fui de 600 para 2.400 terminações por ciclo com o acompanhamento da equipe deles. É uma parceria de verdade.',
  'https://i.pravatar.cc/88?img=12',
  true,
  5
),
(
  'Adriana Roik',
  'Distribuidora — Toledo/PR · 5 anos',
  'parceiro',
  'Como distribuidora, o que me fidelizou foi a pontualidade e a rastreabilidade que a Frivatti oferece. Os clientes do food service pedem exatamente isso — e entregamos com o respaldo de quem produz com responsabilidade.',
  'https://i.pravatar.cc/88?img=22',
  true,
  6
);

-- ---- videos ------------------------------------------------
insert into public.videos (title, category, duration, thumbnail_url, video_url, description, status, order_index) values
(
  'Boas práticas de manejo em suinocultura intensiva',
  'Suinocultura',
  '18:42',
  null,
  null,
  'Tutorial completo sobre manejo sanitário, ambiental e nutricional em granjas de terminação suína. Cobertura de densidade animal, ventilação, limpeza e desinfecção de instalações.',
  'published',
  1
),
(
  'Rastreabilidade do plantel: do nascimento ao abate',
  'Suinocultura',
  '12:15',
  null,
  null,
  'Passo a passo da identificação individual dos animais, registro de movimentações, controles sanitários e exportação de dados para o sistema de rastreabilidade da Frivatti.',
  'published',
  2
),
(
  'Biosseguridade na granja: protocolo completo',
  'Suinocultura',
  '22:08',
  null,
  null,
  'Protocolo de biosseguridade para granjas integradas: controle de acesso, vestiário sanitário, quarentena de animais, descarte correto e relacionamento com outros produtores da região.',
  'published',
  3
);

-- ---- blog_posts --------------------------------------------
insert into public.blog_posts (title, category, excerpt, content, status, published_at) values
(
  'Frivatti conquista certificação internacional para exportação à Ásia',
  'Exportação',
  'A unidade de Itaipulândia recebeu a habilitação do MAPA para exportação aos mercados asiáticos, abrindo novas oportunidades de negócio para a empresa e para os produtores integrados.',
  'A Frivatti concluiu o processo de habilitação junto ao Ministério da Agricultura, Pecuária e Abastecimento (MAPA) para exportação de carne suína aos mercados da Ásia. A certificação contempla a unidade frigorífica de Itaipulândia/PR e permite o envio de cortes suínos congelados e resfriados para países como China, Japão e Coreia do Sul.

O processo envolveu adequações nas instalações, atualização dos programas de autocontrole, treinamento de equipes e auditorias por parte dos órgãos competentes. A conquista representa um marco na trajetória da empresa e amplia significativamente o portfólio de destinos internacionais.

Para os produtores integrados, a certificação traz perspectivas de maior volume de captação e valorização do produto final. A diretoria da Frivatti reforça o compromisso com a qualidade e a rastreabilidade como pilares da expansão internacional.',
  'published',
  now() - interval '10 days'
),
(
  'Mercado asiático: oportunidades e exigências para a carne suína brasileira',
  'Mercado',
  'Entenda o que os importadores asiáticos exigem em termos de rastreabilidade, bem-estar animal e certificações sanitárias, e como a Frivatti se prepara para atender esses requisitos.',
  'O mercado asiático representa hoje o maior destino das exportações brasileiras de carne suína. China, Japão e Coreia do Sul impõem exigências rigorosas que vão além dos padrões sanitários tradicionais, abrangendo critérios de bem-estar animal, rastreabilidade de plantel e certificações específicas por espécie e corte.

Entre os principais requisitos destacam-se: rastreabilidade individual dos animais do nascimento ao abate, controle de uso de antibióticos e medicamentos veterinários, laudos de resíduos para cada lote exportado, e conformidade com protocolos de bem-estar animal reconhecidos internacionalmente.

A Frivatti investe continuamente na adequação dos seus processos e dos produtores integrados a esses padrões. O programa de rastreabilidade próprio da empresa, aliado ao suporte técnico nas granjas, garante que cada lote atenda às especificações exigidas pelos importadores asiáticos.

Com a nova habilitação obtida junto ao MAPA, a empresa está posicionada para aproveitar as oportunidades desse mercado crescente, gerando valor para toda a cadeia produtiva.',
  'published',
  now() - interval '5 days'
),
(
  'Biodigestores nas granjas: sustentabilidade e renda extra para o produtor',
  'Sustentabilidade',
  'A adoção de biodigestores nas propriedades integradas à Frivatti reduz o impacto ambiental da suinocultura e ainda gera créditos de carbono e biogás como fonte de renda complementar.',
  'A suinocultura gera volumes expressivos de resíduos orgânicos que, se mal gerenciados, representam passivo ambiental significativo. Por outro lado, quando tratados corretamente, esses resíduos se transformam em ativo: biogás para geração de energia e biofertilizante para lavouras.

O programa de biodigestores da Frivatti apoia os produtores integrados na implantação de sistemas de tratamento de dejetos, desde o dimensionamento do equipamento até o acompanhamento técnico pós-instalação. Atualmente, mais de 40% das granjas integradas à empresa já operam com biodigestores.

Os benefícios são múltiplos: redução do odor nas propriedades, menor impacto nos recursos hídricos, geração de biogás para uso na própria granja (aquecimento de creches, por exemplo) e produção de biofertilizante líquido e sólido de alta qualidade para uso nas lavouras.

Além dos ganhos operacionais, os produtores participantes do programa têm acesso a projetos de crédito de carbono, que geram renda complementar por meio da comercialização das reduções de emissões certificadas. A Frivatti atua como facilitadora desse processo, conectando os produtores com metodologias e compradores de créditos.',
  'published',
  now() - interval '2 days'
);

-- ---- produtos ----------------------------------------------
insert into public.produtos (name, category, description, image_url, active, order_index) values
(
  'Cortes Suínos Premium',
  'Cortes suínos',
  'Linha completa de cortes suínos frescos e congelados com rastreabilidade de origem: pernil, paleta, costela, carré, lombo, copa e cortes especiais para food service. Embalagem a vácuo com validade estendida.',
  null,
  true,
  1
),
(
  'Linha de Embutidos',
  'Embutidos',
  'Salames, linguiças, mortadelas e apresuntados produzidos com matéria-prima própria e receitas desenvolvidas pela equipe técnica da Frivatti. Disponíveis em embalagens para varejo e em formatos bulk para distribuidores.',
  null,
  true,
  2
),
(
  'Linha Export',
  'Exportação',
  'Cortes e produtos processados habilitados para exportação aos mercados da Ásia, Oriente Médio e América Latina. Produzidos sob rigoroso protocolo de rastreabilidade, com laudos de resíduos e certificação MAPA para cada lote.',
  null,
  true,
  3
);
