
# 🚛 Grand Utopia Logistics Rework

> *Corrigindo a economia do Grand Utopia sem modificar uma única empresa — apenas ajustando o que cada uma produz e consome.*

---

## 📋 Sobre o Mod

**Grand Utopia Logistics Rework** é um mod de correção econômica para o mapa **Grand Utopia** (por MyGodness).

O Grand Utopia é um mapa espetacular — 268 empresas, 49 cidades, 7.500 km² de estradas meticulosamente construídas. Mas a economia do mapa tem um problema: **muitas empresas existem visualmente (prefabs 3D bonitos, skins personalizadas) mas não geram nem consomem cargas** — são "empresas fantasmas" na economia.

Este mod **não adiciona nem remove empresas**. Ele **corrige os inputs e outputs** de cada empresa existente para que:

- ✅ Toda empresa tenha um propósito na economia
- ✅ Cadeias logísticas façam sentido (fazenda → indústria → mercado → consumidor)
- ✅ Cidades tenham fretes de **IDA e VOLTA** (não apenas exportação)
- ✅ Regiões inteiras (como Mygotopia) ganhem vida econômica

---

## 🎯 Filosofia

```
NÃO criamos empresas novas.
NÃO modificamos prefabs, logos, ou skins.
NÃO alteramos o mapa visualmente.

Apenas CORRIGIMOS o que cada empresa PRODUZ e CONSOME.
Tudo que você vê no jogo continua EXATAMENTE igual.
Só que agora os fretes fazem sentido.
```

---

## 🔍 Diagnóstico

### Situação original

Das 268 empresas do Grand Utopia (excluindo VTCs de jogadores):

| Status | Quantidade | % |
|--------|-----------|-----|
| ✅ Funcionais (cargas balanceadas) | 113 | 42% |
| ❌ Fantasmas (sem nenhuma carga) | 122 | 46% |
| ⚠️ Só importam (ex: postos, mercados) | 7 | 3% |
| ⚠️ Só exportam | 3 | 1% |

### O que é "fantasma" vs "só importa"

É importante entender: **nem toda empresa fantasma precisa ser ativada**.

- **Postos de combustível** (`mago`, `noxia`) — faz sentido só importarem. Um posto recebe gasolina e diesel, não produz nada. É correto estar como "só importa".
- **Mercados** (`orelia_mkt`, `blumen`, `jim_tps_mkt`) — recebem alimentos e produtos, produzem apenas lixo/recicláveis. É correto.
- **Empresas fantasmas** — algumas são **estações de ônibus/rodoviárias** aguardando a SCS liberar a DLC de ônibus. Se ativadas, precisam de carga de "passageiros" (invisível) com rota exclusiva estação → estação.
- **Empresas fantasmas produtivas** — madeireiras, fábricas, construtoras, estaleiros. **ESSAS são prioridade.**

> ⚠️ **Nota sobre estações de ônibus:** O Grand Utopia possui prefabs de rodoviárias que o MyGodness posicionou no mapa aguardando futura DLC de ônibus da SCS. Se formos ativá-las, será necessário criar uma carga especial "passageiros" (invisível, sem modelo 3D) com rota exclusiva entre estações — nunca para transportadoras ou portos.

---

## 🗺️ Plano de Correção

### Fase 1 — Mygotopia: Kamelot (em andamento)

Prioridade máxima. Kamelot é a cidade inicial do autor e atualmente está morta.

| Empresa | Cidade | Problema | Correção |
|---------|--------|----------|----------|
| **boisserie** | Kamelot | Fantasma | Serraria (recebe toras, produz madeira processada) |
| **wilnet_trans** | Kamelot | Fantasma | Transportadora regional |
| **gocamping** | Kamelot, Foxhaven | Desbalanceado (25 in / 5 out) | Equipamentos de camping/lazer |

**Não precisa mexer:**
- `mago` (Kamelot) — posto de combustível. Só importar está correto.
- `noxia` (Kamelot) — química. Só importar está correto.

### Fase 2 — Mygotopia: Windfield

Ativar empresas da capital portuária que estão mortas.

| Empresa | Correção |
|---------|----------|
| **sanbuilders** | Construtora (só importa: cimento, tijolos, aço) |
| **c_navale** | Estaleiro (recebe aço, produz embarcações) |
| **blt_yacht** | Fabricante de iates |
| **ika_bohag** | Móveis e decoração |

**Não mexer:**
- `scania_dlr` e `volvo_dlr` — concessionárias. Só importam peças. Correto.
- `sporklift` — pode ser estação de ônibus. Aguardar definição.
- `supercesta` — supermercado. Só importa. Correto.

### Fase 3 — Mygotopia: Demais cidades

Foxhaven, Liberty Bay, Bad Water, Two Rivers, Bully, Oakwood, Westbank.

### Fase 4 — Ilha Principal: Cidades grandes

Tours, Pérignat, Gavroche, Rivenchy, Monteil.

### Fase 5 — Ilha Principal: Cidades menores e vilarejos

### Fase 6 — Balanceamento fino

Ajustar quantidades, criar rotas regionais dentro de Mygotopia para resolver o problema de "só exporta, nunca importa".

---

## 📦 Instalação

1. **Baixe** o arquivo `.scs` da [aba Releases](https://github.com/Oberbet/Grand-Utopia-Logistics-Rework/releases)
2. **Copie** para `Documents/Euro Truck Simulator 2/mod/`
3. **Ative** no Gerenciador de Mods com o mod **abaixo** do Grand Utopia na lista (prioridade maior)

### Ordem de carregamento recomendada

```
[topo da lista — menor prioridade]
1. Grand Utopia (mapa base)

[base da lista — maior prioridade]
2. Grand Utopia Logistics Rework ← seu mod
3. Akokan Island (se tiver)
4. Outros mods compatíveis
```

---

## 🤝 Compatibilidade

- **Requer:** Grand Utopia (qualquer versão 1.54+)
- **Compatível com:** Akokan Island, Patrons Island (addons oficiais)
- **NÃO compatível com:** Outros mods que modifiquem as mesmas empresas (cuidado ao combinar com outros reworks de economia)
- **Conflitos conhecidos:** Nenhum até o momento

---

## 🛠️ Desenvolvimento

### Estrutura do projeto

```
Grand-Utopia-Logistics-Rework/
├── README.md                     ← Este arquivo
├── manifest.sii                  ← Identificação do mod
├── DIAGNOSTICO_COMPLETO.md       ← Análise detalhada da economia
│
└── def/
    └── company/
        ├── boisserie/            ← Empresa corrigida
        │   ├── in/               ← Cargas que ela RECEBE
        │   └── out/              ← Cargas que ela PRODUZ
        ├── wilnet_trans/
        └── ... (demais)
```

### Formato dos arquivos

Cada carga é um arquivo `.sii` de 4 linhas:

```siilanguage
SiiNunit
{
cargo_def : .logs {
 cargo: "cargo.logs"
}
}
```

- O nome do arquivo (`logs.sii`) define o nome curto
- `cargo_def : .logs` — identificador interno (use o mesmo nome do arquivo)
- `cargo: "cargo.logs"` — referência à carga global (já existe no jogo)

---

## 👏 Créditos

- **MyGodness (Ricki)** — Criador do magnífico mapa Grand Utopia, milhares de horas de trabalho dedicado
- **Comunidade Grand Utopia** — Pelas empresas VTC, skins personalizadas e suporte contínuo
- **Apoiadores Patreon** — Que mantêm o projeto vivo

---

## 📊 Progresso

```
Fase 1 (Kamelot)      ░░░░░░░░░░░░░░░░░░░░   0%
Fase 2 (Windfield)    ░░░░░░░░░░░░░░░░░░░░   0%
Fase 3 (Mygotopia resto)░░░░░░░░░░░░░░░░░░   0%
Fase 4 (Ilha princ.)  ░░░░░░░░░░░░░░░░░░░░   0%
Fase 5 (Vilarejos)    ░░░░░░░░░░░░░░░░░░░░   0%
Fase 6 (Balanceamento)░░░░░░░░░░░░░░░░░░░░   0%
```
