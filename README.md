# 🚛 Grand Utopia Logistics Rework

> *Corrigindo a economia do Grand Utopia — ativando empresas fantasmas, criando cadeias logísticas e especializando distribuidoras.*

---

## 📋 Sobre o Mod

**Grand Utopia Logistics Rework** é um mod de correção econômica para o mapa **Grand Utopia** (por MyGodness).

O Grand Utopia é um mapa espetacular — 268 empresas, 49 cidades, 7.500 km² de estradas meticulosamente construídas. Mas **46% das empresas estavam mortas na economia**: existiam visualmente mas não geravam nem consumiam cargas.

Este mod **não adiciona nem remove empresas**. Ele corrige os inputs e outputs de cada empresa para que **tudo tenha um propósito logístico**.

---

## ✅ O que o mod já faz

### Fase 1 — Ressuscitar empresas fantasmas ✔️

**156 empresas** que estavam completamente mortas na economia foram ativadas:

- **Mygotopia completa** — Kamelot, Windfield, Foxhaven, Liberty Bay, Bad Water, Two Rivers, Bully, Oakwood, Westbank agora têm empresas funcionais
- **Ilha Principal** — dezenas de cidades com indústrias, fazendas e comércios ativados
- **Indústrias pesadas**: siderurgia, refinaria, química, estaleiros, fábrica de caminhões
- **Agronegócio**: fazendas, pecuária, pedreiras, pescarias, serrarias
- **Comércio**: supermercados, lojas de departamento, concessionárias, delicatessens
- **Transporte**: dezenas de transportadoras conectando tudo

### Fase 2 — Cadeias logísticas funcionais ✔️

Cadeias produtivas completas foram estabelecidas:

```
Fazenda → Distribuidora de Carnes → Supermercados
Serraria → Distribuidora de Móveis → Lojas
Refinaria → Distribuidora Química → Postos + Indústrias
Pedreira → Distribuidora de Construção → Construtoras
Pesca → Distribuidora de Congelados → Peixarias + Mercados
```

### Fase 3 — Enois como Importadora 🇧🇷 ✔️

A **Enois** (presente nas cidades portuárias) foi configurada como **importadora de produtos brasileiros**:

| Importa do Brasil | Exporta para o Brasil |
|------------------|---------------------|
| Café, Açúcar, Suco de Laranja | Vinho, Queijo |
| Etanol, Minério de Ferro, Soja | Máquinas, Eletrônicos, Peças |

---

## 🚧 O que está em desenvolvimento (WIP)

### Fase 4 — Especialização de Distribuidoras 🔄

Atualmente, todas as transportadoras têm a mesma lista genérica de cargas. Estamos especializando cada uma num segmento específico:

| Cadeia | Distribuidoras | Cidades |
|--------|---------------|---------|
| 🥩 Carnes | crm, ladoga, rimaf | 2+2+3 |
| 🧀 Laticínios | casania, rocheron, rosmark | 3+1+2 |
| 🌾 Grãos/Cereais | domdepo, globeur, sag_tre | 7+3+1 |
| 🍎 Frutas/Verduras | log_atlan, low_field, suprema | 3+6+2 |
| ❄️ Congelados | trameri, universsim, zelenye | 4+5+1 |
| 🛒 **Alimentos + Supermercado** | **euskaltrans** | **23** 🚀 |
| 🚗 Veículos | totoche, tdf | 4+4 |
| 🏗️ Construção | transacantal, trasmatech, grandouest | 9+10+6 |
| ⛽ Química | sjlog, lisette_log, nos_pat | 5+5+12 |
| 🪑 Madeira/Móveis | lostboys, teamzephyr, syllurgy | 6+5+3 |
| 🇧🇷 Importadora | **enois** | Portos |

> **euskaltrans:** Alimentos + itens de supermercado (bebidas, laticínios, carnes, frutas, grãos, roupas, material de escritório, produtos de limpeza). Abastece supermercados e mercados locais em 23 cidades.

**27 empresas sendo especializadas. WIP.**

### Fase 5 — Penistone como petroleira 🛢️

A empresa Penistone (Windfield) será convertida de loja genérica para petroleira/distribuidora de combustíveis.

### Fase 6 — Gocamping

A gocamping (Kamelot, Foxhaven) será readequada conforme avaliação do cenário no mapa.

---

## 📦 Instalação

1. **Baixe** o arquivo `.scs` da [aba Releases](https://github.com/Oberbet/Grand-Utopia-Logistics-Rework/releases) ou da Steam Workshop (assim que publicado)
2. **Copie** para `Documents/Euro Truck Simulator 2/mod/`
3. **Ative** no Gerenciador de Mods com prioridade **MAIOR que o Grand Utopia** (mod mais abaixo na lista)

> ⚠️ **Sempre baixe do repositório oficial ou da Steam Workshop.** Evite download de sites terceiros — você pode baixar uma versão desatualizada ou modificada sem seu conhecimento.

### Ordem de carregamento

```
[topo — menor prioridade]
  Grand Utopia (mapa base)

[base — maior prioridade]
  Grand Utopia Logistics Rework
  Akokan Island (se tiver)
  Outros mods
```

---

## 🤝 Compatibilidade

- ✅ **Requer:** Grand Utopia (qualquer versão 1.54+)
- ✅ **Compatível com:** Akokan Island, Patrons Island
- ✅ **Compatível com:** Qualquer mod que NÃO modifique as mesmas empresas
- ⚠️ **Evite:** Outros mods que modifiquem a economia do Grand Utopia

---

## 🗺️ Mapa Logístico

Consulte o arquivo [`MAPA_LOGISTICO.md`](MAPA_LOGISTICO.md) para diagramas detalhados de cada cadeia produtiva.

---

## 👏 Créditos

- **MyGodness (Ricki)** — Criador do magnífico mapa Grand Utopia, milhares de horas de trabalho dedicado
- **Comunidade Grand Utopia** — Pelas empresas VTC, skins personalizadas e suporte contínuo
- **Apoiadores Patreon** — Que mantêm o projeto vivo

---

> *"Grand Utopia é lindo. Merece uma economia à altura."*

---

## 📊 Progresso Geral

```
Fase 1 (Ativar fantasmas)    ████████████████████ 100%
Fase 2 (Cadeias funcionais)  ████████████████████ 100%
Fase 3 (Enois importadora)   ████████████████████ 100%
Fase 4 (Especialização)      ██████░░░░░░░░░░░░░░  30% (WIP)
Fase 5 (Penistone)           ░░░░░░░░░░░░░░░░░░░░   0%
Fase 6 (Gocamping)           ░░░░░░░░░░░░░░░░░░░░   0%
```

---

## 🛠️ Desenvolvimento e Contribuição

Este mod é **open source**. Contribuições são bem-vindas!

### Estrutura do projeto

```
Grand-Utopia-Logistics-Rework/
├── README.md
├── manifest.sii
├── MAPA_LOGISTICO.md
│
└── def/
    └── company/
        ├── [empresa]/
        │   ├── in/         ← Cargas que RECEBE
        │   └── out/        ← Cargas que PRODUZ
        └── ...
```

### Como contribuir

1. Faça um fork do repositório
2. Crie uma branch: `git checkout -b feature/nova-correcao`
3. Commit suas mudanças: `git commit -m "Corrige empresa X"`
4. Push: `git push origin feature/nova-correcao`
5. Abra um Pull Request

### Formato dos arquivos

Cada carga é um arquivo `.sii` de 4 linhas:

```siilanguage
SiiNunit
{
cargo_def : .almond {
 cargo: "cargo.almond"
}
}
```

- Nome do arquivo = nome da carga (ex: `almond.sii`)
- `cargo_def : .almond` = identificador interno (mesmo nome)
- `cargo: "cargo.almond"` = referência à carga global

### Automação — Criar arquivos em massa

**No Linux (bash):**

```bash
# Cria in/out para uma transportadora
for cargo in almonds apples beans beef beverages; do
  echo 'SiiNunit{ cargo_def : .'$cargo' { cargo: "cargo.'$cargo'" } }' > def/company/minha_empresa/in/$cargo.sii
  echo 'SiiNunit{ cargo_def : .'$cargo' { cargo: "cargo.'$cargo'" } }' > def/company/minha_empresa/out/$cargo.sii
done
```

**No Windows (PowerShell):**

```powershell
# Cria in/out para uma transportadora
$cargas = @("almonds","apples","beans","beef","beverages")
foreach ($c in $cargas) {
  $content = "SiiNunit{ cargo_def : .$c { cargo: `"cargo.$c`" } }"
  $content | Out-File -FilePath "def/company/minha_empresa/in/$c.sii" -Encoding ascii
  $content | Out-File -FilePath "def/company/minha_empresa/out/$c.sii" -Encoding ascii
}
```

### Gerar .scs para distribuição

**No Linux:**

```bash
# Na raiz do projeto
cd Grand-Utopia-Logistics-Rework
zip -r ../Grand-Utopia-Logistics-Rework-v1.0.0-beta.scs . -x ".git/*"
```

**No Windows (PowerShell):**

```powershell
# Na raiz do projeto
Compress-Archive -Path * -DestinationPath ..\Grand-Utopia-Logistics-Rework-v1.0.0-beta.zip
# Renomeie .zip para .scs
Rename-Item ..\Grand-Utopia-Logistics-Rework-v1.0.0-beta.zip ..\Grand-Utopia-Logistics-Rework-v1.0.0-beta.scs
```

**No Windows (7-Zip — recomendado):**

```powershell
# Se tiver 7-Zip instalado em C:\Program Files\7-Zip\
& "C:\Program Files\7-Zip\7z.exe" a -tzip ..\Grand-Utopia-Logistics-Rework-v1.0.0-beta.scs * -xr!".git"
```

> O arquivo `.scs` é um `.zip` renomeado. O ETS2 aceita ambos os formatos.

---

## 📜 Licença

Distribuição livre. Uso, modificação e compartilhamento permitidos sem restrições. Para garantir a versão mais atualizada e estável, **baixe sempre do repositório oficial no GitHub ou da Steam Workshop**.

Créditos à comunidade Grand Utopia são apreciados mas não obrigatórios.
