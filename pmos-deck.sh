#!/usr/bin/env bash
#
# pmos-deck.sh — postmarketOS (Phosh, GNOME Mobile, KDE Plasma Mobile)
# no Steam Deck via Distrobox (Arch) + QEMU/KVM.
#
# Uso:
#   ./pmos-deck.sh validate                # checa host + container + imagens
#   ./pmos-deck.sh fix-kvm                 # corrige acesso a /dev/kvm (uma vez)
#   ./pmos-deck.sh setup [ui ...]          # container + pacotes + imagens (padrão: as 3)
#   ./pmos-deck.sh run <ui>                # inicia a VM (phosh|gnome-mobile|plasma-mobile)
#
# Variáveis de ambiente opcionais:
#   PMOS_GL=0      janela sem aceleração 3D (fallback 2D)
#   PMOS_TCG=1     força emulação por software (sem KVM, lento)
#   PMOS_AUDIO=1   habilita som via PulseAudio/PipeWire do Deck
#   PMOS_RAM=4096  memória da VM em MB
#   PMOS_SMP=4     CPUs virtuais
#   PMOS_DISK=virtio   usa virtio-blk no lugar de SATA (mais rápido, menos compatível)
#   PMOS_PINNED=1  usa as URLs fixas (build 20260828) em vez de descobrir a mais nova
#
# Validado em 01/09/2026 (imagens postmarketOS v26.06, QEMU 11.x, SteamOS 3.5+).
# Veja o guia completo em POSTMARKETOS_STEAM_DECK.md.

set -euo pipefail

CONTAINER="pmos-deck"
BASE_DIR="$HOME/pmos"
IMAGE_BASE="https://images.postmarketos.org/bpo/v26.06/generic-x86_64"
UIS=(phosh gnome-mobile plasma-mobile)

# Builds fixas verificadas em 01/09/2026 — fallback se a descoberta automática falhar.
declare -A PINNED=(
  [phosh]="20260828-0134/20260828-0134-postmarketOS-v26.06-phosh-29.1-generic-x86_64-lts.img.xz"
  [gnome-mobile]="20260828-0141/20260828-0141-postmarketOS-v26.06-gnome-mobile-4-generic-x86_64-lts.img.xz"
  [plasma-mobile]="20260828-0145/20260828-0145-postmarketOS-v26.06-plasma-mobile-6-generic-x86_64-lts.img.xz"
)

say()  { printf '\033[1;32m[ OK ]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[AVISO]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[ERRO ]\033[0m %s\n' "$*"; }
die()  { fail "$*"; exit 1; }

usage() {
  sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

# ---------------------------------------------------------------- validate
cmd_validate() {
  echo "== Validando o host (SteamOS) =="
  if command -v distrobox >/dev/null; then say "distrobox: $(distrobox version | head -1)"
  else fail "distrobox ausente (SteamOS < 3.5?). Instale: curl -s https://distrobox.it/install | sudo sh"; fi

  if [ -e /dev/kvm ]; then
    say "/dev/kvm existe ($(stat -c '%A' /dev/kvm))"
  else
    fail "/dev/kvm ausente. Tente: sudo modprobe kvm_amd (ou rode ./pmos-deck.sh fix-kvm)"
  fi

  if [ -e /dev/dri/renderD128 ]; then say "/dev/dri/renderD128 presente"; else warn "/dev/dri/renderD128 ausente — janela sem aceleração 3D"; fi

  free_mb=$(df -Pk "$HOME" | awk 'NR==2 {print int($4/1024)}')
  say "Espaço livre em ~: ${free_mb} MB"
  if [ "$free_mb" -lt 25000 ]; then
    warn "Menos de 25 GB livres: as 3 imagens descompactadas precisam de bastante espaço."
  fi

  echo
  echo "== Validando o container =="
  if distrobox list 2>/dev/null | grep -qw "$CONTAINER"; then
    say "container '$CONTAINER' existe"
    if distrobox enter "$CONTAINER" -- bash -lc 'command -v qemu-system-x86_64 >/dev/null' 2>/dev/null; then
      say "qemu-system-x86_64 instalado no container"
    else
      fail "QEMU não instalado no container. Rode: ./pmos-deck.sh setup"
    fi
  else
    fail "container '$CONTAINER' não existe. Rode: ./pmos-deck.sh setup"
  fi

  echo
  echo "== Validando imagens =="
  for ui in "${UIS[@]}"; do
    img=$(ls "$BASE_DIR/$ui"/*.img 2>/dev/null | head -n1 || true)
    if [ -n "$img" ]; then say "$ui -> $(basename "$img") ($(du -h "$img" | cut -f1))"
    else fail "$ui -> imagem ausente. Rode: ./pmos-deck.sh setup $ui"; fi
  done
}

# ----------------------------------------------------------------- fix-kvm
cmd_fix_kvm() {
  echo "== Corrigindo acesso ao /dev/kvm =="
  if [ ! -e /dev/kvm ]; then
    echo ">> /dev/kvm não existe; tentando carregar o módulo..."
    sudo modprobe kvm_amd || warn "modprobe kvm_amd falhou (kernel sem KVM? use PMOS_TCG=1 como último recurso)"
  fi
  getent group kvm >/dev/null || sudo groupadd -r kvm
  echo 'KERNEL=="kvm", MODE="0666"' | sudo tee /etc/udev/rules.d/99-kvm.rules >/dev/null
  sudo udevadm control --reload-rules
  sudo udevadm trigger
  sudo chmod 666 /dev/kvm 2>/dev/null || true
  sudo usermod -aG kvm "$USER" 2>/dev/null || true
  echo
  ls -l /dev/kvm
  echo
  say "Pronto. Se o sudo pedir senha e você nunca definiu uma no Deck, rode 'passwd' primeiro."
  echo "IMPORTANTE: se o container '$CONTAINER' já existia, recrie-o para pegar o device liberado:"
  echo "  distrobox rm -f $CONTAINER && ./pmos-deck.sh setup"
}

# ------------------------------------------- descoberta da build mais nova
discover_rel() {
  local ui="$1" html date file
  html=$(curl -fsSL --retry 3 "$IMAGE_BASE/$ui/" 2>/dev/null) || return 1
  date=$(printf '%s' "$html" | sed -n 's/.*href="\([0-9]\{8\}-[0-9]\{4\}\)\/".*/\1/p' | head -n1)
  [ -n "$date" ] || return 1
  html=$(curl -fsSL --retry 3 "$IMAGE_BASE/$ui/$date/" 2>/dev/null) || return 1
  file=$(printf '%s' "$html" | sed -n 's/.*href="\([^"]*\.img\.xz\)".*/\1/p' | head -n1)
  [ -n "$file" ] || return 1
  printf '%s/%s' "$date" "$file"
}

fetch_image() {
  local ui="$1" rel="" file img
  if [ "${PMOS_PINNED:-0}" = "1" ]; then
    rel="${PINNED[$ui]}"
  else
    rel=$(discover_rel "$ui") || { warn "descoberta automática falhou; usando build fixa de 28/08/2026"; rel="${PINNED[$ui]}"; }
  fi
  mkdir -p "$BASE_DIR/$ui"
  file="${rel##*/}"
  img="${file%.xz}"
  if [ -f "$BASE_DIR/$ui/$img" ]; then
    say "$ui: imagem já existe ($img)"
    return
  fi
  echo ">> $ui: baixando $file ..."
  curl -fL --retry 3 -o "$BASE_DIR/$ui/$file" "$IMAGE_BASE/$ui/$rel"
  curl -fL --retry 3 -o "$BASE_DIR/$ui/$file.sha256" "$IMAGE_BASE/$ui/$rel.sha256"
  ( cd "$BASE_DIR/$ui" && sha256sum -c "$file.sha256" ) || die "hash SHA-256 não confere para $ui — apague o arquivo e tente de novo"
  echo ">> $ui: descompactando (pode demorar)..."
  xz -d -k -T0 "$BASE_DIR/$ui/$file"
  rm -f "$BASE_DIR/$ui/$file" "$BASE_DIR/$ui/$file.sha256"
  say "$ui: pronto ($(du -h "$BASE_DIR/$ui/$img" | cut -f1))"
}

# ------------------------------------------------------------------- setup
cmd_setup() {
  local uis=("$@"); [ ${#uis[@]} -eq 0 ] && uis=("${UIS[@]}")
  for ui in "${uis[@]}"; do
    case " ${UIS[*]} " in *" $ui "*) ;; *) die "UI desconhecida: $ui (use: ${UIS[*]})";; esac
  done

  echo "== 1/3 Container distrobox =="
  if distrobox list 2>/dev/null | grep -qw "$CONTAINER"; then
    say "container '$CONTAINER' já existe"
  else
    local flags="--shm-size=1g"
    if [ -e /dev/kvm ]; then flags="$flags --device /dev/kvm"; else warn "/dev/kvm ausente — a VM rodará sem aceleração"; fi
    if [ -e /dev/dri ]; then flags="$flags --device /dev/dri"; else warn "/dev/dri ausente — janela sem aceleração 3D"; fi
    distrobox create --name "$CONTAINER" --image archlinux:latest --yes --additional-flags "$flags"
    say "container criado"
  fi

  echo
  echo "== 2/3 Instalando QEMU + firmware no container (primeira vez demora) =="
  distrobox enter "$CONTAINER" -- bash -lc \
    'sudo pacman -Syu --noconfirm && sudo pacman -S --noconfirm --needed qemu-desktop edk2-ovmf mesa libglvnd'
  say "QEMU instalado: $(distrobox enter "$CONTAINER" -- bash -lc 'qemu-system-x86_64 --version | head -1')"

  echo
  echo "== 3/3 Baixando imagens (${uis[*]}) =="
  for ui in "${uis[@]}"; do fetch_image "$ui"; done

  echo
  say "Tudo pronto! Rode: ./pmos-deck.sh run phosh  (ou gnome-mobile / plasma-mobile)"
}

# -------------------------------------------------------------------- run
cmd_run() {
  local ui="${1:-}"
  case " ${UIS[*]} " in *" $ui "*) ;; *) die "Uso: ./pmos-deck.sh run <ui>  — ui ∈ {${UIS[*]}}";; esac

  distrobox list 2>/dev/null | grep -qw "$CONTAINER" || die "container '$CONTAINER' não existe. Rode: ./pmos-deck.sh setup"

  local ram="${PMOS_RAM:-4096}" smp="${PMOS_SMP:-4}" accel="kvm" cpu="host"
  if [ "${PMOS_TCG:-0}" = "1" ] || [ ! -e /dev/kvm ]; then
    warn "KVM indisponível — usando emulação por software (TCG). Vai ser LENTO."
    accel="tcg"; cpu="max"
  fi

  local vga="virtio-vga-gl" disp="gtk,gl=on"
  if [ "${PMOS_GL:-1}" != "1" ] || [ ! -e /dev/dri/renderD128 ]; then
    warn "GL indisponível — usando virtio-vga 2D (guest renderiza por software)."
    vga="virtio-vga"; disp="gtk"
  fi

  export PMOS_UI="$ui" PMOS_BASE="$BASE_DIR" PMOS_RAM="$ram" PMOS_SMP="$smp" \
         PMOS_ACCEL="$accel" PMOS_CPU="$cpu" PMOS_VGA="$vga" PMOS_DISP="$disp" \
         PMOS_DISK_MODE="${PMOS_DISK:-sata}" PMOS_AUDIO="${PMOS_AUDIO:-0}"

  # Script interno: roda DENTRO do container (distrobox compartilha $HOME, então
  # $PMOS_BASE é o mesmo caminho nos dois lados).
  mkdir -p "$BASE_DIR"
  cat > "$BASE_DIR/.pmos-run.sh" <<'INNER'
#!/usr/bin/env bash
set -euo pipefail
ui="$PMOS_UI"
cd "$PMOS_BASE/$ui"

# firmware UEFI (OVMF)
CODE=""; for p in /usr/share/edk2/x64/OVMF_CODE.4m.fd /usr/share/edk2/x64/OVMF_CODE.fd /usr/share/OVMF/OVMF_CODE.fd; do
  [ -f "$p" ] && CODE="$p" && break
done
VARS_SRC=""; for p in /usr/share/edk2/x64/OVMF_VARS.4m.fd /usr/share/edk2/x64/OVMF_VARS.fd /usr/share/OVMF/OVMF_VARS.fd; do
  [ -f "$p" ] && VARS_SRC="$p" && break
done
[ -n "$CODE" ] || { echo "ERRO: firmware OVMF não encontrado no container (instale edk2-ovmf)."; exit 1; }
[ -f OVMF_VARS.fd ] || cp "$VARS_SRC" OVMF_VARS.fd

IMG="$(ls -1 *.img 2>/dev/null | head -n1 || true)"
[ -n "$IMG" ] || { echo "ERRO: imagem .img não encontrada em $PWD. Rode: pmos-deck.sh setup $ui"; exit 1; }

# disco: SATA (padrão, mais compatível) ou virtio (mais rápido)
if [ "$PMOS_DISK_MODE" = "virtio" ]; then
  DISK_ARGS=(-drive "file=$IMG,format=raw,if=virtio")
else
  DISK_ARGS=(-drive "file=$IMG,format=raw,if=none,id=hd0" \
             -device ich9-ahci,id=ahci \
             -device "ide-hd,drive=hd0,bus=ahci.0")
fi

# áudio opcional (socket Pulse/PipeWire do Deck)
AUDIO_ARGS=()
if [ "$PMOS_AUDIO" = "1" ]; then
  PULSE="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/pulse/native"
  if [ -S "$PULSE" ]; then
    AUDIO_ARGS=(-audiodev "pa,id=snd0,server=unix:$PULSE" \
                -device ich9-intel-hda \
                -device hda-duplex,audiodev=snd0)
  else
    echo "AVISO: socket PulseAudio não encontrado; som desabilitado."
  fi
fi

echo ">> Iniciando pmos-$ui (accel=$PMOS_ACCEL, RAM=${PMOS_RAM}MB, smp=$PMOS_SMP, vga=$PMOS_VGA)"
echo ">> Dica: Ctrl+Alt+G solta o mouse | Ctrl+Alt+F tela cheia | desligue pelo menu do guest"
exec qemu-system-x86_64 \
  -name "pmos-$ui" \
  -machine "q35,accel=$PMOS_ACCEL" \
  -cpu "$PMOS_CPU" \
  -smp "$PMOS_SMP" \
  -m "$PMOS_RAM" \
  -drive "if=pflash,format=raw,readonly=on,file=$CODE" \
  -drive "if=pflash,format=raw,file=OVMF_VARS.fd" \
  "${DISK_ARGS[@]}" \
  -device "$PMOS_VGA" \
  -display "$PMOS_DISP" \
  -device qemu-xhci \
  -device usb-tablet \
  -nic user,model=virtio-net-pci \
  "${AUDIO_ARGS[@]}"
INNER
  chmod +x "$BASE_DIR/.pmos-run.sh"
  distrobox enter "$CONTAINER" -- bash "$BASE_DIR/.pmos-run.sh"
}

# ------------------------------------------------------------------ main
cmd="${1:-}"; shift || true
case "$cmd" in
  validate)  cmd_validate ;;
  fix-kvm)   cmd_fix_kvm ;;
  setup)     cmd_setup "$@" ;;
  run)       cmd_run "${1:-}" ;;
  ""|-h|--help|help) usage 0 ;;
  *)         die "Comando desconhecido: $cmd (use: validate | fix-kvm | setup | run)";;
esac
