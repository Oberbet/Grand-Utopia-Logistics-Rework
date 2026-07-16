# 🗺️ Mapa Logístico — Grand Utopia Logistics Rework

> *Como as distribuidoras especializadas se conectam com a produção, os portos e o consumo final.*

---

## Visão Geral do Sistema

```
                    ┌─────────────────────────────────────────────────────────────┐
                    │                    PORTOS DE IMPORTAÇÃO                      │
                    │  enois (café, açúcar, suco, etanol, minério, soja)          │
                    │  gallia_ferry (containers, veículos, máquinas)              │
                    └──────────────────────────┬──────────────────────────────────┘
                                               │
                                               ▼
                    ┌─────────────────────────────────────────────────────────────┐
                    │              HUBS DE DISTRIBUIÇÃO GERAL                     │
                    │  (já existem, NÃO mexemos - recebem de TUDO)                │
                    │                                                             │
                    │  adtranslog (87 in)  │  diplo (189 in)   │  gu_express      │
                    │  butin_fils (93 in)  │  husky_b (91 in)  │  + várias outras  │
                    └──────────────────────────┬──────────────────────────────────┘
                                               │
                  ┌────────────────────────────┼────────────────────────────┐
                  │                            │                            │
                  ▼                            ▼                            ▼
    ┌─────────────────────────┐  ┌─────────────────────────┐  ┌─────────────────────────┐
    │   DISTRIBUIDORAS        │  │   DISTRIBUIDORAS        │  │   DISTRIBUIDORAS        │
    │   ESPECIALIZADAS        │  │   ESPECIALIZADAS        │  │   ESPECIALIZADAS        │
    │   (NOSSO MOD)           │  │   (NOSSO MOD)           │  │   (NOSSO MOD)           │
    └───────────┬─────────────┘  └───────────┬─────────────┘  └───────────┬─────────────┘
                │                            │                            │
                ▼                            ▼                            ▼
    ┌─────────────────────────┐  ┌─────────────────────────┐  ┌─────────────────────────┐
    │     PONTOS DE VENDA     │  │     INDÚSTRIAS          │  │     PORTOS DE            │
    │     (CONSUMO FINAL)     │  │     (PROCESSAMENTO)     │  │     EXPORTAÇÃO          │
    │  supermercados, lojas,  │  │  fábricas, montadoras,  │  │  cont_port_fr/it        │
    │  concessionárias, etc.  │  │  serrarias, etc.        │  │                        │
    └─────────────────────────┘  └─────────────────────────┘  └─────────────────────────┘
```

---

## Cadeia 1 — Carnes 🥩

```
                    ┌─────────────────────────────┐
                    │      FAZENDAS (produção)     │
                    │  cowshelter, agronord,       │
                    │  agrominta, euroacres        │
                    │  OUTPUT: beef, pork, chicken │
                    │  lamb, live_cattle           │
                    └──────────────┬──────────────┘
                                   │
                                   ▼
                    ┌─────────────────────────────┐
                    │   DISTRIBUIDORA DE CARNES   │
                    │   crm ─── 2 cidades         │
                    │   ladoga ── 2 cidades       │
                    │   rimaf ─── 3 cidades       │
                    │                             │
                    │   INPUT: beef, pork,        │
                    │   chicken, lamb, sausages   │
                    │   OUTPUT: beef, pork,       │
                    │   chicken, lamb, sausages   │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    ▼              ▼              ▼
          ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
          │  SUPERMERCADOS│ │  AÇOUGUES    │ │  PORTOS      │
          │  orelia_mkt  │ │  (lojas)     │ │  (exportação)│
          │  supercesta  │ │  nbfc        │ │  cont_port   │
          │  kaarfor     │ │  cesta_sl    │ │              │
          └──────────────┘ └──────────────┘ └──────────────┘
```

---

## Cadeia 2 — Laticínios 🧀

```
                    ┌─────────────────────────────┐
                    │      FAZENDAS LEITEIRAS     │
                    │  cowshelter                 │
                    │  OUTPUT: milk, cheese,      │
                    │  butter, yogurt,            │
                    │  cottage_cheese, goat_cheese│
                    └──────────────┬──────────────┘
                                   │
                                   ▼
                    ┌─────────────────────────────┐
                    │  DISTRIBUIDORA LATICÍNIOS   │
                    │  casania ── 3 cidades       │
                    │  rocheron ─ 1 cidade        │
                    │  rosmark ── 2 cidades       │
                    │                             │
                    │  INPUT: milk, cheese,       │
                    │  butter, yogurt             │
                    │  OUTPUT: milk, cheese,      │
                    │  butter, yogurt             │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    ▼              ▼              ▼
          ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
          │  SUPERMERCADOS│ │  DELICATESSEN│ │  PORTOS      │
          │  orelia_mkt  │ │  tesore_gust │ │              │
          │  mammouth    │ │  lavish_food │ │              │
          │  blumen      │ │              │ │              │
          └──────────────┘ └──────────────┘ └──────────────┘
```

---

## Cadeia 3 — Cereais e Grãos 🌾

```
                    ┌─────────────────────────────┐
                    │      FAZENDAS DE GRÃOS      │
                    │  agrominta, euroacres,      │
                    │  fallow, fattoria_f         │
                    │                             │
                    │  OUTPUT: wheat, barley,     │
                    │  corn, rice, grain,         │
                    │  potatoes, vegetables       │
                    └──────────────┬──────────────┘
                                   │
                                   ▼
                    ┌─────────────────────────────┐
                    │   DISTRIBUIDORA DE GRÃOS    │
                    │  domdepo ── 7 cidades       │
                    │  globeur ── 3 cidades       │
                    │  sag_tre ── 1 cidade        │
                    │                             │
                    │  INPUT: wheat, barley,      │
                    │  corn, rice, flour, grain   │
                    │  OUTPUT: wheat, barley,     │
                    │  corn, rice, flour, grain   │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    ▼              ▼              ▼
          ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
          │  INDÚSTRIAS  │ │  SUPERMERCADOS│ │  PADARIAS    │
          │  spinelli    │ │  orelia_mkt  │ │  (lojas)     │
          │  (massas)    │ │  kaarfor     │ │  eco         │
          │  huilant     │ │  supercesta  │ │              │
          └──────────────┘ └──────────────┘ └──────────────┘
```

---

## Cadeia 4 — Frutas e Hortaliças 🍎

```
                    ┌─────────────────────────────┐
                    │    FAZENDAS / PLANTATION    │
                    │  euroacres, fattoria_f,     │
                    │  huerta, fallow             │
                    │                             │
                    │  OUTPUT: apples, oranges,   │
                    │  bananas, tomatoes,         │
                    │  potatoes, carrots,         │
                    │  grapes, olives, etc.       │
                    └──────────────┬──────────────┘
                                   │
                                   ▼
                    ┌─────────────────────────────┐
                    │  DISTRIBUIDORA FRUTAS/VERD. │
                    │  log_atlan ─ 3 cidades      │
                    │  low_field ─ 6 cidades      │
                    │  suprema ─── 2 cidades      │
                    │                             │
                    │  INPUT: frutas e verduras   │
                    │  OUTPUT: frutas e verduras  │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    ▼              ▼              ▼
          ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
          │  SUPERMERCADOS│ │  FEIRAS      │ │  INDÚSTRIAS  │
          │  orelia_mkt  │ │  (lojas)     │ │  huilant     │
          │  blumen      │ │  eco         │ │  (óleos)     │
          │  kaarfor     │ │              │ │  brawen      │
          └──────────────┘ └──────────────┘ └──────────────┘
```

---

## Cadeia 5 — Congelados ❄️

```
                    ┌─────────────────────────────┐
                    │    PESCARIAS / INDÚSTRIAS   │
                    │  polar_fish, exomar         │
                    │  norr_food                  │
                    │                             │
                    │  OUTPUT: frozen_hake,       │
                    │  salmon, cod, shrimp,       │
                    │  frozen_vegetables,         │
                    │  icecream                   │
                    └──────────────┬──────────────┘
                                   │
                                   ▼
                    ┌─────────────────────────────┐
                    │ DISTRIBUIDORA CONGELADOS   │
                    │  trameri ─── 4 cidades      │
                    │  universsim ─ 5 cidades     │
                    │  zelenye ─── 1 cidade       │
                    │                             │
                    │  INPUT: congelados          │
                    │  OUTPUT: congelados         │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    ▼              ▼              ▼
          ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
          │  SUPERMERCADOS│ │  PEIXARIAS   │ │  PORTOS      │
          │  kaarfor     │ │  norr_food   │ │  (exportação)│
          │  mammouth    │ │  lavish_food │ │              │
          │  orelia_mkt  │ │              │ │              │
          └──────────────┘ └──────────────┘ └──────────────┘
```

---

## Cadeia 6 — euskaltrans: Hub Alimentício para Supermercados 🛒

**A euskaltrans está em 23 cidades** — de Kamelot e Windfield em Mygotopia até Tours e Rivenchy na ilha principal. Funciona como a **central de abastecimento** de supermercados e mercados locais.

```
                    ┌──────────────────────────────────────────┐
                    │  PRODUTORES DE ALIMENTOS                 │
                    │  (fazendas, laticínios, pescarias,       │
                    │   indústrias alimentícias, grãos,        │
                    │   frutas, hortaliças, carnes)            │
                    └───────────────────┬──────────────────────┘
                                        │
                                        ▼
                    ┌──────────────────────────────────────────┐
                    │  EUSKALTRANS (23 cidades!)               │
                    │  Hub Alimentício + Itens de Supermercado │
                    │                                          │
                    │  RECEBE E DISTRIBUI:                     │
                    │  ─ Alimentos: carnes, laticínios,        │
                    │    grãos, frutas, verduras, congelados    │
                    │  ─ Bebidas: sucos, refrigerantes, água   │
                    │  ─ Mercearia: massas, arroz, feijão,     │
                    │    enlatados, óleos, temperos             │
                    │  ─ Não-alimentícios: roupas, material    │
                    │    de escritório, produtos de limpeza,   │
                    │    higiene, brinquedos                    │
                    └───────────────────┬──────────────────────┘
                                        │
                                        ▼
                    ┌──────────────────────────────────────────┐
                    │  SUPERMERCADOS E MERCADOS LOCAIS         │
                    │  (orelha_mkt, kaarfor, blumen,           │
                    │   supercesta, mammouth, norr_food,       │
                    │   nbfc, cesta_sl, etc.)                  │
                    └──────────────────────────────────────────┘
```

**Por que ela não vira só alimentos:** Supermercados vendem mais que comida. Roupas, material de escritório, produtos de limpeza são itens de prateleira. A euskaltrans leva TUDO que um supermercado precisa — menos veículos, móveis e materiais de construção (que têm distribuidoras próprias).


---

## Cadeia 7 — Veículos 🚗

Para veículos, usamos distribuidoras com presença moderada (4 cidades cada):

```
                    ┌─────────────────────────────┐
                    │     FÁBRICAS/MONTADORAS     │
                    │  volvo_fac, scania_fac      │
                    │                             │
                    │  OUTPUT: tractors, trucks,  │
                    │  cars, motorcycles          │
                    └──────────────┬──────────────┘
                                   │
                                   ▼
                    ┌─────────────────────────────┐
                    │  DISTRIBUIDORA VEÍCULOS     │
                    │  totoche ──── 4 cidades     │
                    │  tdf ──────── 4 cidades     │
                    │                             │
                    │  INPUT: veículos, peças     │
                    │  OUTPUT: veículos, peças    │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    ▼              ▼              ▼
          ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
          │ CONCESSIONÁR.│ │  OFICINAS    │ │  PORTOS      │
          │  scania_dlr  │ │  itcc        │ │  (exportação)│
          │  volvo_dlr   │ │              │ │              │
          │  voitureux   │ │              │ │              │
          └──────────────┘ └──────────────┘ └──────────────┘
```

---

## Cadeia 8 — Materiais de Construção 🏗️

```
                    ┌─────────────────────────────┐
                    │    PEDREIRAS / SIDERURGIA   │
                    │  quarry, marmo,             │
                    │  mvm_carriere, cemelt_fla   │
                    │                             │
                    │  OUTPUT: gravel, sand,      │
                    │  cement, steel, bricks,     │
                    │  marble, stone              │
                    └──────────────┬──────────────┘
                                   │
                                   ▼
                    ┌─────────────────────────────┐
                    │ DISTRIBUIDORA CONSTRUÇÃO   │
                    │  transacantal ─ 9 cidades   │
                    │  trasmatech ── 10 cidades   │
                    │  grandouest ── 6 cidades    │
                    │                             │
                    │  INPUT: materiais           │
                    │  OUTPUT: materiais          │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    ▼              ▼              ▼
          ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
          │ CONSTRUTORAS │ │  LOJAS       │ │  PORTOS      │
          │  sanbuilders │ │  bricolagem  │ │  (exportação)│
          │  batisse_base│ │  egres       │ │              │
          │  batisse_hs  │ │              │ │              │
          └──────────────┘ └──────────────┘ └──────────────┘
```

---

## Cadeia 9 — Química e Combustíveis ⛽

```
                    ┌─────────────────────────────┐
                    │      REFINARIAS/QUÍMICAS    │
                    │  bhb_raffin (refinaria)     │
                    │  chimi (ind. química)       │
                    │  wgcc (ind. química)        │
                    │  petroleum (petrolífera)    │
                    │                             │
                    │  OUTPUT: diesel, petrol,    │
                    │  chemicals, fertilizer,     │
                    │  LPG, kerosene, plásticos   │
                    └──────────────┬──────────────┘
                                   │
                                   ▼
                    ┌─────────────────────────────┐
                    │ DISTRIBUIDORA QUÍMICA       │
                    │  sjlog ───── 5 cidades      │
                    │  lisette_log ─ 5 cidades    │
                    │  nos_pat ─── 12 cidades     │
                    │                             │
                    │  INPUT: químicos            │
                    │  OUTPUT: químicos           │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    ▼              ▼              ▼
          ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
          │  POSTOS      │ │  FAZENDAS    │ │  INDÚSTRIAS  │
          │  mago        │ │  agrominta   │ │  gomme_monde │
          │  turbo       │ │  euroacres   │ │  (pneus)     │
          │  noxia       │ │  cowshelter  │ │  onnelik     │
          └──────────────┘ └──────────────┘ └──────────────┘
```

---

## Cadeia 10 — Madeira e Móveis 🪑

```
                    ┌─────────────────────────────┐
                    │     FLORESTAS/SERRARIAS     │
                    │  boisserie, timberturtle    │
                    │  crnodrvo_log, tree_et      │
                    │  ee_paper, scs_paper        │
                    │                             │
                    │  OUTPUT: logs, lumber,      │
                    │  sawpanels, paper           │
                    └──────────────┬──────────────┘
                                   │
                                   ▼
                    ┌─────────────────────────────┐
                    │  DISTRIBUIDORA MADEIRA/MÓV. │
                    │  lostboys ─── 6 cidades     │
                    │  teamzephyr ─ 5 cidades     │
                    │  syllurgy ─── 3 cidades     │
                    │                             │
                    │  INPUT: madeira, painéis    │
                    │  OUTPUT: móveis, painéis    │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    ▼              ▼              ▼
          ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
          │  LOJAS MÓV.  │ │  CONSTRUÇÃO  │ │  PORTOS      │
          │  ika_bohag   │ │  batisse     │ │  (exportação)│
          │  mobler      │ │  sanbuilders │ │              │
          │  lintukainen │ │              │ │              │
          └──────────────┘ └──────────────┘ └──────────────┘
```

---

## Cadeia 11 — Enois (Importadora de Produtos Brasileiros) 🌎🇧🇷

```
                    ┌─────────────────────────────────────┐
                    │        BRASIL (produção)             │
                    │  Café, Açúcar, Suco de Laranja,      │
                    │  Etanol, Minério de Ferro, Soja      │
                    │  "Chegam" pelos portos de Mygotopia  │
                    └──────────────────┬──────────────────┘
                                       │
                                       ▼
                    ┌─────────────────────────────────────┐
                    │       ENOIS (cidades portuárias)     │
                    │  Bad Water, Liberty Bay, Windfield   │
                    │                                      │
                    │  IMPORTA DO BRASIL:                  │
                    │  café, açúcar, suco, etanol,         │
                    │  minério de ferro, soja              │
                    │                                      │
                    │  EXPORTA PARA O BRASIL:              │
                    │  vinho, queijo, máquinas,            │
                    │  eletrônicos, peças                  │
                    └──────────────────┬──────────────────┘
                                       │
                    ┌──────────────────┼──────────────────┐
                    ▼                                  ▼
     ┌─────────────────────────┐         ┌─────────────────────────┐
     │  DISTRIBUI PELO MAPA:  │         │  RECEBE DO MAPA PARA    │
     │  café → supermercados  │         │  EXPORTAR:              │
     │  açúcar → indústrias   │         │  vinho (de fattoria_f)  │
     │  etanol → postos       │         │  queijo (de cowshelter) │
     │  minério → siderurgia  │         │  máquinas (de indústrias)│
     │  soja → fazendas       │         │  eletrônicos            │
     └─────────────────────────┘         └─────────────────────────┘
```

---

## Mapa Geral de Conexões

```
PRODUTORES          DISTRIBUIDORAS            CONSUMIDORES
╔══════════════╗    ╔══════════════════╗    ╔══════════════════╗
║ FAZENDAS     ║───▶║ CARNES          ║───▶║ SUPERMERCADOS    ║
║ (cowshelter, ║    ║ crm, ladoga,    ║    ║ orelia_mkt,      ║
║  agronord)   ║    ║ rimaf           ║    ║ kaarfor, blumen  ║
╚══════════════╝    ╚══════════════════╝    ╚══════════════════╝

╔══════════════╗    ╔══════════════════╗    ╔══════════════════╗
║ FAZENDAS     ║───▶║ LATICÍNIOS      ║───▶║ SUPERMERCADOS    ║
║ (cowshelter) ║    ║ casania,        ║    ║ delicatessens    ║
║              ║    ║ rocheron,       ║    ║ (tesore_gust,    ║
║              ║    ║ rosmark         ║    ║ lavish_food)     ║
╚══════════════╝    ╚══════════════════╝    ╚══════════════════╝

╔══════════════╗    ╔══════════════════╗    ╔══════════════════╗
║ FAZENDAS     ║───▶║ GRÃOS           ║───▶║ INDÚSTRIAS       ║
║ (agrominta,  ║    ║ domdepo,        ║    ║ (spinelli,       ║
║  euroacres,  ║    ║ globeur,        ║    ║ huilant)         ║
║  fallow)     ║    ║ sag_tre         ║    ║ + supermercados  ║
╚══════════════╝    ╚══════════════════╝    ╚══════════════════╝

╔══════════════╗    ╔══════════════════╗    ╔══════════════════╗
║ FAZENDAS     ║───▶║ FRUTAS/VERDURAS ║───▶║ SUPERMERCADOS    ║
║ (huerta,     ║    ║ log_atlan,      ║    ║ + indústrias     ║
║  fattoria_f, ║    ║ low_field,      ║    ║ (huilant,        ║
║  euroacres)  ║    ║ suprema         ║    ║ brawen)          ║
╚══════════════╝    ╚══════════════════╝    ╚══════════════════╝

╔══════════════╗    ╔══════════════════╗    ╔══════════════════╗
║ PESCARIAS    ║───▶║ CONGELADOS      ║───▶║ SUPERMERCADOS    ║
║ (polar_fish, ║    ║ trameri,        ║    ║ peixarias        ║
║  exomar)     ║    ║ universsim,     ║    ║ (norr_food,      ║
║              ║    ║ zelenye         ║    ║ lavish_food)     ║
╚══════════════╝    ╚══════════════════╝    ╚══════════════════╝

╔══════════════╗    ╔══════════════════╗    ╔══════════════════╗
║ INDÚSTRIAS   ║───▶║ VEÍCULOS        ║───▶║ CONCESSIONÁRIAS ║
║ (volvo_fac,  ║    ║ totoche, tdf    ║    ║ (scania_dlr,    ║
║  scania_fac) ║    ║                 ║    ║ volvo_dlr,      ║
║              ║    ║                 ║    ║ voitureux)      ║
╚══════════════╝    ╚══════════════════╝    ╚══════════════════╝

╔══════════════╗    ╔══════════════════╗    ╔══════════════════╗
║ PEDREIRAS/   ║───▶║ CONSTRUÇÃO      ║───▶║ CONSTRUTORAS     ║
║ SIDERURGIA   ║    ║ transacantal,   ║    ║ (sanbuilders,    ║
║ (quarry,     ║    ║ trasmatech,     ║    ║ batisse_base,    ║
║  cemelt_fla) ║    ║ grandouest      ║    ║ batisse_hs)      ║
╚══════════════╝    ╚══════════════════╝    ╚══════════════════╝

╔══════════════╗    ╔══════════════════╗    ╔══════════════════╗
║ REFINARIAS/  ║───▶║ QUÍMICA         ║───▶║ POSTOS +         ║
║ QUÍMICAS     ║    ║ sjlog,          ║    ║ FAZENDAS +       ║
║ (bhb_raffin, ║    ║ lisette_log,    ║    ║ INDÚSTRIAS       ║
║  chimi, wgcc)║    ║ nos_pat         ║    ║ (gomme_monde)    ║
╚══════════════╝    ╚══════════════════╝    ╚══════════════════╝

╔══════════════╗    ╔══════════════════╗    ╔══════════════════╗
║ FLORESTAS/   ║───▶║ MADEIRA/MÓVEIS  ║───▶║ LOJAS MÓVEIS     ║
║ SERRARIAS    ║    ║ lostboys,       ║    ║ (ika_bohag,      ║
║ (boisserie,  ║    ║ teamzephyr,     ║    ║ mobler,          ║
║  tree_et)    ║    ║ syllurgy        ║    ║ lintukainen)     ║
╚══════════════╝    ╚══════════════════╝    ╚══════════════════╝

╔══════════════╗    ╔══════════════════╗    ╔══════════════════╗
║ BRASIL       ║───▶║ ENOIS           ║───▶║ MAPA INTEIRO     ║
║ (café,       ║    ║ (importadora)   ║    ║ (café → mercados,║
║  açúcar,     ║    ║ cidades         ║    ║ etanol → postos, ║
║  minério)    ║    ║ portuárias)     ║    ║ soja → fazendas) ║
╚══════════════╝    ╚══════════════════╝    ╚══════════════════╝
```

---

## Resumo: Impacto no Jogo

```
ANTES DA ESPECIALIZAÇÃO:
  Todas as transportadoras → mesmas 30 cargas genéricas
  Qualquer empresa leva qualquer produto
  "Carro, moto, cabrito, alimento, roupa" tudo misturado

DEPOIS DA ESPECIALIZAÇÃO:
  Cada distribuidora → UM segmento específico
  Cadeias lógicas fazem sentido
  Mais rotas regionais (produto não viaja o mapa inteiro)
  Mais realismo (carne vem de fazenda, não de distribuidora geral)
  Enois como portal Brasil ↔ Grand Utopia 🇧🇷
```

---

## Empresas que VÃO MUDAR (especializar)

| Empresa atual | Vai ser | Cidades | Impacto |
|---------------|---------|---------|---------|
| crm | 🥩 Carnes | 2 | |
| ladoga | 🥩 Carnes | 2 | |
| rimaf | 🥩 Carnes | 3 | |
| casania | 🧀 Laticínios | 3 | |
| rocheron | 🧀 Laticínios | 1 | |
| rosmark | 🧀 Laticínios | 2 | |
| domdepo | 🌾 Grãos/Cereais | 7 | 🚀 |
| globeur | 🌾 Grãos/Cereais | 3 | |
| sag_tre | 🌾 Grãos/Cereais | 1 | |
| log_atlan | 🍎 Frutas/Verduras | 3 | |
| low_field | 🍎 Frutas/Verduras | 6 | 🚀 |
| suprema | 🍎 Frutas/Verduras | 2 | |
| trameri | ❄️ Congelados | 4 | |
| universsim | ❄️ Congelados | 5 | 🚀 |
| zelenye | ❄️ Congelados | 1 | |
| euskaltrans | 🛒 Alimentos+Supermercado | 23 | 🚀 Hub de abastecimento |
| totoche | 🚗 Veículos | 4 | |
| tdf | 🚗 Veículos | 4 | |
| transacantal | 🏗️ Construção | 9 | 🚀 |
| trasmatech | 🏗️ Construção | 10 | 🚀 |
| grandouest | 🏗️ Construção | 6 | 🚀 |
| sjlog | ⛽ Química | 5 | 🚀 |
| lisette_log | ⛽ Química | 5 | 🚀 |
| nos_pat | ⛽ Química | 12 | 🚀🚀 |
| lostboys | 🪑 Madeira/Móveis | 6 | 🚀 |
| teamzephyr | 🪑 Madeira/Móveis | 5 | 🚀 |
| syllurgy | 🪑 Madeira/Móveis | 3 | |
| enois | 🇧🇷 Importadora | portos | Especial |

**nos_pat** (12 cidades), **trasmatech** (10 cidades), **transacantal** (9 cidades) — estas têm o maior impacto. **euskaltrans** (23 cidades) vira hub alimentício para supermercados, já que sua presença capilar é ideal para abastecer o comércio local.
