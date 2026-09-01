# postmarketOS no Steam Deck — 3 ambientes QEMU (Phosh, GNOME Mobile e KDE Plasma Mobile) via Distrobox

> Guia validado em **01/09/2026**.
> Imagens oficiais **postmarketOS v26.06** (builds de 28/08/2026), **QEMU 11.x** (pacote `qemu-desktop` do Arch), **distrobox + podman** (pré-instalados no SteamOS 3.5+). Todas as URLs, hashes e comandos abaixo foram conferidos nas fontes oficiais na data acima.

---

## 1. Visão geral

Você vai criar **3 máquinas virtuais independentes**, cada uma com uma interface mobile do postmarketOS:

| VM | Interface | O que é |
|---|---|---|
| `pmos-phosh` | **Phosh** | Shell da Purism (Librem 5), GNOME adaptado para celular, Wayland nativo |
| `pmos-gnome-mobile` | **GNOME Mobile** | GNOME Shell em modo mobile (gestos, layout de celular) |
| `pmos-plasma-mobile` | **KDE Plasma Mobile** | Plasma 6 adaptado para mobile (o "KDE Mobile") |

**Arquitetura do que vamos montar:**

```
SteamOS (Deck, modo Desktop)
 └── distrobox (container Arch Linux, rootless via podman)
      └── QEMU/KVM (aceleração por hardware do APU Van Gogh)
           └── postmarketOS v26.06 (Phosh | GNOME Mobile | Plasma Mobile)
```

**Por que distrobox?**
- O SteamOS é imutável: o `/usr` é read-only e pacotes instalados com `pacman` **somem a cada atualização** do sistema.
- Desde o SteamOS 3.5, **distrobox e podman já vêm instalados** e funcionam direto (confirmado pelo blog do desenvolvedor da Igalia e pela comunidade).
- O container vive em `~/.local/share/containers` (no `/home`), então **sobrevive a atualizações do SteamOS**.
- Dentro de um container Arch temos `pacman`, QEMU com interface GTK, e acesso a `/dev/kvm` e `/dev/dri` passados explicitamente.

**Por que QEMU/KVM e não VirtualBox?** KVM usa a virtualização por hardware (SVM/AMD-V) do Deck → desempenho próximo do nativo. É o caminho usado e comprovado pela comunidade para rodar VMs no Deck.

---

## 2. Requisitos

- **Steam Deck com SteamOS atualizado** (3.5 ou mais novo; ideal 3.6+/3.7 — verifique no modo Desktop → Configurações do Sistema → Sobre, ou `cat /etc/os-release`).
- **Modo Desktop** (o QEMU abre uma janela; no Modo Jogo não há gerenciador de janelas).
- **~30 GB livres** no disco interno (as 3 imagens descompactadas ocupam alguns GB cada; reserve com folga).
- Internet para baixar as imagens (~5 GB no total).
- O Deck tem 16 GB de RAM unificada — rode **uma VM por vez** (recomendado 4 GB por VM).

> **Importante sobre a BIOS do Deck:** a virtualização (SVM) do APU Van Gogh já vem ativa de fábrica e **não existe opção para ligar/desligar na BIOS** do Deck. Se o `/dev/kvm` não aparecer, o problema é o módulo do kernel (veja Passo 0.2), não a BIOS.

---

## 3. Passo 0 — Verificações antes de qualquer comando

Abra o **Konsole** no modo Desktop (`Ctrl+Alt+T` ou menu de aplicativos) e rode, **nesta ordem**, os testes abaixo. Não pule: eles evitam 90% dos erros.

### 0.1 — distrobox instalado?

```bash
distrobox version
```

**Esperado:** imprime uma versão (ex.: `distrobox: 1.8.1`).
**Se der erro ("command not found"):** seu SteamOS é anterior ao 3.5. Instale na mão:
```bash
curl -s https://distrobox.it/install | sudo sh
```
(ou use o Flatpak do distrobox pela Discover). Em seguida refaça o teste.

### 0.2 — KVM disponível e acessível? (o passo que mais gera erro)

```bash
lscpu | grep -i svm
ls -l /dev/kvm
```

**Cenário A — esperado (ideal):**
```
Virtualization:                  AMD-V
...
crw-rw---- 1 root kvm 10, 232 ... /dev/kvm
```
A VM rodará acelerada. Ainda assim faça o **0.2.1** abaixo para garantir acesso de dentro do container (podman rootless não propaga grupos do usuário por padrão — só o `chmod`/udev resolve de forma garantida).

**Cenário B — `/dev/kvm` não existe:**
```bash
sudo modprobe kvm_amd
ls -l /dev/kvm
```
Se continuar sem existir, o kernel do seu SteamOS não carregou o módulo (raro) — siga para a seção 11 (fallback TCG).

**Cenário C — existe mas com permissão `crw------- root root` (ou você não consegue abrir):**

Aplique a correção definitiva (regra udev + grupo) — ela persiste entre reboots e não depende de grupos suplementares dentro do container:
```bash
# garante o grupo kvm
getent group kvm >/dev/null || sudo groupadd -r kvm
# regra udev: /dev/kvm legível por todos (0666)
echo 'KERNEL=="kvm", MODE="0666"' | sudo tee /etc/udev/rules.d/99-kvm.rules
# recarrega as regras e aplica já na sessão atual
sudo udevadm control --reload-rules && sudo udevadm trigger
sudo chmod 666 /dev/kvm
# bônus: adiciona seu usuário ao grupo kvm (não faz mal e ajuda outros usos)
sudo usermod -aG kvm "$USER"
```

**Esperado:** `ls -l /dev/kvm` mostra `crw-rw-rw-` (ou `crw-rw----` + você no grupo kvm).
**Por que 0666?** Dentro do container o processo roda como seu usuário (uid 1000) e o podman rootless **não** repassa os grupos suplementares do host para dentro do container; a permissão aberta no device node é o método que funciona de forma garantida (e é aceitável num aparelho de usuário único — se preferir mais rigidez, use `usermod` + a flag `--group-add keep-groups` no `distrobox create`, seção 4).
**Obs.:** `sudo usermod` só tem efeito em sessões novas; o `chmod 666` + udev já resolve sem reiniciar.

### 0.3 — Espaço em disco

```bash
df -h /home
```

**Esperado:** vários GB disponíveis. Confira também o total da tabela de imagens (seção 6) antes de baixar.

### 0.4 — Modo Desktop

Se ainda estiver no Modo Jogo: botão **Steam → Power → Switch to Desktop**. O restante do guia roda no Konsole do Desktop.

---

## 4. Passo 1 — Criar o container distrobox (Arch Linux)

```bash
distrobox create \
  --name pmos-deck \
  --image archlinux:latest \
  --yes \
  --additional-flags "--device /dev/kvm --device /dev/dri"
```

**O que cada flag faz:**
- `--additional-flags` → repassa flags para o `podman create` por baixo.
- `--device /dev/kvm` → **obrigatório**: expõe a virtualização ao container (sem isso o QEMU não acelera).
- `--device /dev/dri` → expõe o render node do GPU (Radeon 680M do Deck) para a janela do QEMU renderizar com GL.
- ~~`--shm-size=1g`~~ **não use**: o distrobox compartilha o namespace IPC com o host (`--ipc host`) e o podman rejeita `--shm-size` nesse caso, com o erro `cannot set shmsize when running in the host IPC Namespace` — a criação do container falha na hora. O tamanho padrão (64 MB) é suficiente para o QEMU.

**Esperado:** download da imagem Arch (`docker.io/library/archlinux:latest`, ~200 MB) e mensagem de criação com sucesso.

**Erros previstos:**
- `Error: stat /dev/kvm: no such file or directory` → o `/dev/kvm` não existe no host (faça Passo 0.2, Cenário B).
- `Error: stat /dev/dri: no such file or directory` → `/dev/dri` ausente; recrie o container sem essa flag (a janela ainda abre, com renderização por software).
- `Error: invalid config provided: cannot set shmsize when running in the {host } IPC Namespace` → você passou `--shm-size` no `--additional-flags`; o distrobox usa `--ipc host` e o podman não permite os dois juntos. Remova `--shm-size` do comando (a versão atual do guia/script já não usa).
- Demorar muito no pull → é normal na primeira vez (rede do Deck); não interrompa.

**Verifique que o container existe e entre nele:**

```bash
distrobox list
distrobox enter pmos-deck
```

Dentro do container você verá o prompt com o hostname do container. Teste o acesso ao KVM **de dentro** dele:

```bash
ls -l /dev/kvm /dev/dri
```

**Esperado:** `crw-rw-rw- ... /dev/kvm` e `renderD128` listado. Se `/dev/kvm` não estiver acessível (permission denied), volte ao Passo 0.2, Cenário C, e **recrie o container** (`distrobox rm -f pmos-deck` e repita o create).

---

## 5. Passo 2 — Instalar QEMU + firmware no container

Já **dentro do container** (`distrobox enter pmos-deck`):

```bash
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed qemu-desktop edk2-ovmf mesa libglvnd
```

**Por que esses pacotes:**
- `qemu-desktop` → build do Arch com **interface GTK**, **suporte a GL/virgl** (`virtio-vga-gl`) e backends de áudio (PulseAudio/PipeWire). (O `qemu-base` é headless — não serve.)
- `edk2-ovmf` → firmware **UEFI** (OVMF). As imagens do postmarketOS para x86_64 são "Generic x86_64 **EFI** System": só bootam via UEFI, não por BIOS legado.
- `mesa` + `libglvnd` → drivers de GPU userspace (amdgpu/radeonsi) para o QEMU renderizar a janela com aceleração no Deck.

**Valide a instalação (ainda dentro do container):**

```bash
qemu-system-x86_64 --version
qemu-img --version | head -1
ls -l /usr/share/edk2/x64/OVMF_CODE.4m.fd /usr/share/edk2/x64/OVMF_VARS.4m.fd
```

**Esperado:** versões do QEMU (11.x), do qemu-img, e os dois arquivos de firmware existindo.

**Erros previstos:**
- `error: failed to init transaction (unable to lock database)` → outro `pacman` rodando; feche e repita.
- `qemu-system-x86_64: command not found` → o pacote não instalou; confira com `pacman -Q qemu-desktop`.
- Arquivos OVMF não encontrados nesse caminho → rode `find /usr/share -name "OVMF_CODE*" 2>/dev/null` para achar o caminho real do seu pacote.

Saia do container quando terminar (digite `exit`).

---

## 6. Passo 3 — Baixar as 3 imagens oficiais

As imagens oficiais do postmarketOS para x86_64 ficam em `images.postmarketos.org`. A versão estável atual é a **v26.06**, e as builds são refeitas **semanalmente** (a pasta tem a data, ex.: `20260828-0134`). Os links abaixo são os **verificados em 01/09/2026** (builds de 28/08/2026) — eles continuam válidos mesmo depois (builds antigas permanecem no servidor).

| Ambiente | Arquivo (build 20260828) | Tamanho | SHA-256 |
|---|---|---|---|
| Phosh | `20260828-0134-postmarketOS-v26.06-phosh-29.1-generic-x86_64-lts.img.xz` | 1,6 GiB | `1387caf51a51de0e754c8e9dc50d90e1e9dd4b30ba9006cbc1b2d31c7a0ba2b4` |
| GNOME Mobile | `20260828-0141-postmarketOS-v26.06-gnome-mobile-4-generic-x86_64-lts.img.xz` | 1,6 GiB | `6f605e21e76a2074d9a53b1f9e1c1c6ce98e77869f930b966af6944b59f5275a` |
| Plasma Mobile | `20260828-0145-postmarketOS-v26.06-plasma-mobile-6-generic-x86_64-lts.img.xz` | 1,8 GiB | `21f4772459e25178ef1935d8b0002203ba904e0d76e6a931eab233951d1bc205` |

Crie a estrutura de pastas e baixe (rode no **host**, no Konsole):

```bash
mkdir -p ~/pmos/phosh ~/pmos/gnome-mobile ~/pmos/plasma-mobile
cd ~/pmos/phosh
curl -fLO https://images.postmarketos.org/bpo/v26.06/generic-x86_64/phosh/20260828-0134/20260828-0134-postmarketOS-v26.06-phosh-29.1-generic-x86_64-lts.img.xz
curl -fLO https://images.postmarketos.org/bpo/v26.06/generic-x86_64/phosh/20260828-0134/20260828-0134-postmarketOS-v26.06-phosh-29.1-generic-x86_64-lts.img.xz.sha256
sha256sum -c *.sha256
```

> Se preferir, use o script `pmos-deck.sh` (seção 10), que baixa as três, **descobre automaticamente a build mais nova** no servidor e confere o hash de cada uma.

**Descompacte (cada arquivo vira um disco de alguns GB — normalmente 4–8 GB por imagem):**

```bash
xz -d -k *.img.xz    # -k mantém o .xz; apague os .xz depois para liberar espaço
rm -f *.img.xz
ls -lh ~/pmos/phosh
```

Repita o download/descompactação para `gnome-mobile` e `plasma-mobile` com os links correspondentes da tabela (ou rode `~/pmos-deck.sh setup` que faz tudo).

**Erros previstos:**
- `sha256sum: WARNING: computed CHECKSUM did NOT match` → download corrompido; apague o `.xz` e baixe de novo.
- `No space left on device` → libere espaço (as imagens vão para `/home`; no Deck você pode apagar jogos não usados ou usar o cartão SD).
- **"Como achar a build mais nova?"** → abra `https://images.postmarketos.org/bpo/v26.06/generic-x86_64/phosh/` no navegador do Deck e use o link marcado com **`latest`** (a pasta com data no nome). O padrão do nome é sempre `DATA-postmarketOS-v26.06-<ui>-<versão>-generic-x86_64-lts.img.xz`.

---

## 7. Passo 4 — Rodar o Phosh (primeira VM)

Agora a parte principal. O comando abaixo inicia a VM do Phosh com **KVM, UEFI (OVMF), disco SATA, GPU virtual com aceleração (virgl) e janela GTK**. Rode do **host** (o QEMU executa dentro do container via `distrobox enter`; a janela abre normalmente no Desktop do Deck):

```bash
distrobox enter pmos-deck -- bash -lc '
  cd ~/pmos/phosh &&
  cp -n /usr/share/edk2/x64/OVMF_VARS.4m.fd ~/pmos/phosh/OVMF_VARS.fd 2>/dev/null; \
  exec qemu-system-x86_64 \
    -name pmos-phosh \
    -machine q35,accel=kvm \
    -cpu host \
    -smp 4 \
    -m 4096 \
    -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
    -drive if=pflash,format=raw,file=OVMF_VARS.fd \
    -drive file=20260828-0134-postmarketOS-v26.06-phosh-29.1-generic-x86_64-lts.img,format=raw,if=none,id=hd0 \
    -device ich9-ahci,id=ahci \
    -device ide-hd,drive=hd0,bus=ahci.0 \
    -device virtio-vga-gl \
    -display gtk,gl=on \
    -device qemu-xhci \
    -device usb-tablet \
    -nic user,model=virtio-net-pci
'
```

**Explicação rápida dos parâmetros críticos:**
- `-machine q35,accel=kvm -cpu host` → máquina moderna acelerada por hardware.
- pflash OVMF (CODE read-only + VARS gravável) → boot UEFI, obrigatório para essas imagens.
- `-device ich9-ahci` + `ide-hd` → disco como SATA: driver presente em qualquer kernel x86 (é o mais garantido; se quiser mais velocidade, troque por virtio-blk — veja seção 11).
- `-device virtio-vga-gl -display gtk,gl=on` → GPU virtual 3D com virgl.
- `-device qemu-xhci -device usb-tablet` → mouse absoluto (o touchscreen do Deck move o cursor da VM; trackpads também funcionam).
- `-nic user` → rede NAT: o guest já sai com DHCP e internet usando a rede do Deck (DNS via 10.0.2.3).

**O que você deve ver:**
1. Logo UEFI/OVMF (rápido) e boot do kernel do postmarketOS.
2. Tela de login do **Phosh** (ou login automático direto para a interface).
3. Credenciais padrão do postmarketOS: usuário **`user`**, senha **`147147`**.
4. Primeira inicialização é mais lenta (primeiro boot gera configurações); depois fica ágil.

**Controles:**
- `Ctrl+Alt+G` → captura/solta o mouse na janela da VM.
- `Ctrl+Alt+F` → tela cheia (útil no Deck).
- Para desligar: use o menu de energia dentro do Phosh (deslize de cima) ou no terminal da VM `sudo poweroff`. Evite fechar a janela à força.

**Erros previstos no primeiro boot:**
- `Could not open /dev/kvm: Permission denied` → Passo 0.2, Cenário C (e recrie o container com o device liberado).
- `failed to initialize KVM: Function not implemented` / QEMU cai para TCG sozinho → rodou sem KVM; aceitável só como teste lento.
- Janela abre preta / QEMU aborta com erro de EGL → o GL do container falhou. Rode com fallback 2D:
  - troque `-device virtio-vga-gl` por `-device virtio-vga` e `-display gtk,gl=on` por `-display gtk`.
  - (O guest passa a renderizar com software — llvmpipe — mais lento, mas funciona.)
- Kernel panic com `VFS: Unable to mount root fs` → o driver do disco não foi achado; é raro com SATA, mas se acontecer troque o disco para virtio: `-drive file=...,format=raw,if=virtio` (remova as duas linhas `ich9-ahci`/`ide-hd`).
- Tela preta depois do logo UEFI, sem boot → tente `-device VGA` no lugar de `virtio-vga-gl` (driver VGA padrão existe em todo kernel).
- A janela não aparece no Desktop → veja seção 11 (variável `GDK_BACKEND=x11`).

---

## 8. Passo 5 — GNOME Mobile (2ª VM)

Mesma receita, mudando **imagem, pasta e nome**. (Cada VM tem seu próprio `OVMF_VARS.fd` — não compartilhe o mesmo arquivo entre VMs.)

```bash
distrobox enter pmos-deck -- bash -lc '
  cd ~/pmos/gnome-mobile &&
  cp -n /usr/share/edk2/x64/OVMF_VARS.4m.fd OVMF_VARS.fd 2>/dev/null; \
  exec qemu-system-x86_64 \
    -name pmos-gnome-mobile \
    -machine q35,accel=kvm \
    -cpu host \
    -smp 4 \
    -m 4096 \
    -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
    -drive if=pflash,format=raw,file=OVMF_VARS.fd \
    -drive file=20260828-0141-postmarketOS-v26.06-gnome-mobile-4-generic-x86_64-lts.img,format=raw,if=none,id=hd0 \
    -device ich9-ahci,id=ahci \
    -device ide-hd,drive=hd0,bus=ahci.0 \
    -device virtio-vga-gl \
    -display gtk,gl=on \
    -device qemu-xhci \
    -device usb-tablet \
    -nic user,model=virtio-net-pci
'
```

**Diferenças do Phosh:**
- No **primeiro boot** o GNOME Mobile roda o "Initial Setup" (idioma, fuso, usuário) — complete com mouse normalmente.
- É o ambiente **mais pesado** dos três: se estiver travado, suba a RAM (`-m 5120`/`-m 6144`) e/ou feche o Steam antes de rodar.
- Login padrão (se pedir): `user` / `147147`.

---

## 9. Passo 6 — KDE Plasma Mobile (3ª VM)

```bash
distrobox enter pmos-deck -- bash -lc '
  cd ~/pmos/plasma-mobile &&
  cp -n /usr/share/edk2/x64/OVMF_VARS.4m.fd OVMF_VARS.fd 2>/dev/null; \
  exec qemu-system-x86_64 \
    -name pmos-plasma-mobile \
    -machine q35,accel=kvm \
    -cpu host \
    -smp 4 \
    -m 4096 \
    -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
    -drive if=pflash,format=raw,file=OVMF_VARS.fd \
    -drive file=20260828-0145-postmarketOS-v26.06-plasma-mobile-6-generic-x86_64-lts.img,format=raw,if=none,id=hd0 \
    -device ich9-ahci,id=ahci \
    -device ide-hd,drive=hd0,bus=ahci.0 \
    -device virtio-vga-gl \
    -display gtk,gl=on \
    -device qemu-xhci \
    -device usb-tablet \
    -nic user,model=virtio-net-pci
'
```

**Diferenças:** Plasma Mobile 6 com toque/gestos; no primeiro boot pode aparecer um assistente de boas-vindas — é normal. Usuário/senha padrão `user` / `147147`.

---

## 10. Passo 7 — Script `pmos-deck.sh` (atalho para tudo)

Junto com este guia está o script **`pmos-deck.sh`** (na raiz deste repositório). Ele automatiza os Passos 0–9:

```bash
# 1) Verifica o host (distrobox, /dev/kvm, espaço, container, imagens)
./pmos-deck.sh validate

# 2) Corrige acesso ao KVM (udev + grupo + chmod) — uma vez só
./pmos-deck.sh fix-kvm

# 3) Cria o container, instala QEMU e baixa as 3 imagens (com hash)
./pmos-deck.sh setup

# 4) Roda cada ambiente
./pmos-deck.sh run phosh
./pmos-deck.sh run gnome-mobile
./pmos-deck.sh run plasma-mobile
```

Variáveis de ambiente opcionais:
- `PMOS_GL=0` → janela sem aceleração (fallback 2D, mais compatível).
- `PMOS_TCG=1` → força emulação por software (sem KVM; lento, só para diagnóstico).
- `PMOS_AUDIO=1` → habilita som via PipeWire/PulseAudio do Deck.
- `PMOS_RAM=6144` / `PMOS_SMP=6` → ajusta memória/CPUs da VM.

---

## 11. Tabela de erros previstos e soluções

| # | Sintoma | Causa provável | Solução |
|---|---|---|---|
| 1 | `distrobox: command not found` | SteamOS < 3.5 | `curl -s https://distrobox.it/install \| sudo sh` |
| 2 | `stat /dev/kvm: no such file` no create | módulo kvm_amd não carregado | `sudo modprobe kvm_amd` e repita; senão use TCG |
| 3 | `Could not open /dev/kvm: Permission denied` | permissão 0660 e grupo não propaga no podman | Passo 0.2 Cenário C (udev 0666) e **recrie o container** |
| 4 | QEMU abre mas MUITO lento (CPU 100% no host) | rodando sem KVM (TCG) | confira `/dev/kvm` e `-accel kvm`; rode `pmos-deck.sh validate` |
| 5 | `failed to initialize KVM: Function not implemented` | hypervisor não disponível no host | fallback `-accel tcg` (seção 12) |
| 6 | Tela preta na janela / erro de EGL | GL do container falhou (mesa/device) | `-device virtio-vga` + `-display gtk` (ou `PMOS_GL=0`) |
| 7 | Janela não aparece no Desktop | Wayland/gamescope com GTK | `GDK_BACKEND=x11 qemu-system-x86_64 ...`; confira se está no modo Desktop |
| 8 | Kernel panic `VFS: Unable to mount root fs` | driver do disco ausente | use SATA (padrão) ou troque para `if=virtio`; não use NVMe |
| 9 | Boot para no logo/EFI shell | OVMF sem a imagem certa | confira pflash CODE+VARS; nunca rode com `-bios` só |
| 10 | `sha256sum ... MISMATCH` | download corrompido | apague e baixe de novo |
| 11 | `No space left on device` | /home cheio | apague `.xz`, mova imagens para o SD ou libere espaço |
| 12 | Login pede senha | padrão do pmOS | `user` / `147147` |
| 13 | Sem internet no guest | (raro) NAT/DHCP | confira com `ip a` no guest; o `-nic user` entrega DHCP em eth0; se preciso, `sudo setup-interfaces` |
| 14 | Sem som | áudio off por padrão | rode com `PMOS_AUDIO=1` (usa o socket Pulse do Deck) |
| 15 | GNOME Mobile travado | RAM insuficiente | `-m 5120`; feche o Steam/jogos antes |
| 16 | Container sumiu após update do SteamOS | distrobox do host atualizou e perdeu o container | `distrobox list`; se faltar, recrie com o mesmo nome (as imagens em `~/pmos` ficam) |
| 17 | `qemu-system-x86_64: command not found` dentro do container | pacotes não instalados | repita o `pacman -S qemu-desktop edk2-ovmf mesa libglvnd` |
| 18 | VMs não bootam depois de muito tempo paradas | imagem "suja" de testes | recopie a imagem original ou use overlay (seção 12) |
| 19 | Toque não funciona na VM | sem dispositivo touch virtual | mouse é o esperado: touchscreen do Deck move o cursor (usb-tablet) |
| 20 | Quer rodar em monitor externo | — | use a dock; a janela QEMU acompanha o KDE normalmente |
| 21 | `cannot set shmsize when running in the host IPC Namespace` ao criar o container | `--shm-size` + `--ipc host` (padrão do distrobox) | remova `--shm-size` do `--additional-flags` e recrie o container |

---

## 12. Extras

### SSH para dentro da VM (testar sem janela)
Adicione ao comando QEMU: `-netdev user,id=n0,hostfwd=tcp::2222-:22 -device virtio-net-pci,netdev=n0` (no lugar do `-nic user`). No guest, habilite o sshd uma vez:
```bash
sudo rc-service sshd start
sudo rc-update add sshd default
```
Do Deck: `ssh -p 2222 user@localhost` (senha `147147`).

### Resetar um ambiente sem baixar de novo (snapshot)
Crie um overlay qcow2 sobre a imagem original; para "resetar", apague o overlay:
```bash
qemu-img create -f qcow2 -F raw -b ~/pmos/phosh/<imagem>.img ~/pmos/phosh/overlay.qcow2
# use -drive file=~/pmos/phosh/overlay.qcow2,format=qcow2,if=none,id=hd0
# reset: rm ~/pmos/phosh/overlay.qcow2 && qemu-img create ...
```

### Atualizar o postmarketOS dentro do guest
```bash
sudo apk update && sudo apk upgrade
```
(imagens v26.06 = estável; há também builds `edge` no servidor, mais instáveis.)

### Desempenho
- Feche o Steam (modo Desktop deixa ele rodando em segundo plano) antes de rodar VMs pesadas.
- `-smp 4` usa 4 dos 8 threads do Deck; `-m 4096` usa 4 dos 16 GB — valores equilibrados.
- O modo "Performance" do Deck (Menu Quick Access → Performance) ajuda.
- VMs longas consomem bastante bateria — use o carregador.

### Fallback total sem KVM (só para confirmar que a imagem funciona)
Troque `-machine q35,accel=kvm -cpu host` por `-machine q35 -accel tcg -cpu max`. O boot leva vários minutos; use só como diagnóstico.

### Alternativas (se quiser comparar)
- **KDE neon Mobile** tem imagens prontas para QEMU: `https://files.kde.org/neon/images/mobile/` (Plasma Mobile sem o pmOS).
- **Fedora Plasma Mobile spin**: `https://fedoraproject.org/spins/kde-mobile/`.
- postmarketOS **edge** (diário): `https://images.postmarketos.org/bpo/edge/generic-x86_64/`.

---

## 13. Referências (todas consultadas em 01/09/2026)

- Página de instalação do postmarketOS (v26.06, usuário/senha padrão): https://postmarketos.org/install/
- Imagens oficiais x86_64 (Phosh, GNOME Mobile, Plasma Mobile — builds de 28/08/2026): https://images.postmarketos.org/bpo/v26.06/generic-x86_64/
- Wiki pmOS — QEMU (pmbootstrap, rede, SSH): https://wiki.postmarketos.org/wiki/Category:QEMU
- Wiki pmOS — dispositivo "Generic x64 UEFI device": https://wiki.postmarketos.org/index.php?title=Generic_x64_UEFI_device
- Getting Plasma Mobile (x86_64 → postmarketOS): https://plasma-mobile.org/get/
- Distrobox (pré-instalado no SteamOS 3.5+; man page do `create` com `--additional-flags`): https://distrobox.it/usage/distrobox-create/
- ArchWiki — QEMU (pacotes `qemu-desktop`/`qemu-base`/`qemu-full`): https://wiki.archlinux.org/title/QEMU
- Pacote Arch `qemu-desktop` (dependências: GTK, virgl, áudio): https://archlinux.org/packages/extra/x86_64/qemu-desktop/
- Blog da Igalia — distrobox e Nix no SteamOS 3.5: https://blogs.igalia.com/berto/2024/06/05/more-ways-to-install-software-in-steamos-distrobox-and-nix/
- Relato da comunidade — KVM via distrobox no Steam Deck: https://steamcommunity.com/app/1675200/discussions/0/3761104049348898945/

> **Aviso final:** você está mexendo apenas em arquivos do seu `/home` (container e imagens) e numa regra udev — nada disso altera o sistema SteamOS de forma permanente. Se algo der errado, `distrobox rm -f pmos-deck` e apagar `~/pmos` devolvem o Deck ao estado anterior.
