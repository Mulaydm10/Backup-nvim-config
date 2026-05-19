<div align="center">

<img src="https://capsule-render.vercel.app/api?type=soft&color=0:1a1b26,100:24283b&height=160&text=nvim-config&fontSize=52&fontColor=c0caf5&fontAlignY=55&animation=fadeIn" width="100%"/>

<br/>

[![Neovim](https://img.shields.io/badge/Neovim-0.9+-57A143?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io/)
[![Arch Linux](https://img.shields.io/badge/Arch-Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![Lua](https://img.shields.io/badge/Config-Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)
[![One Command](https://img.shields.io/badge/Restore-One%20Command-7aa2f7?style=for-the-badge)](#restore)

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=13&pause=2000&color=7AA2F7&center=true&vCenter=true&width=400&height=30&lines=git+clone+%26%26+bash+restore_nvim_arch.sh" alt="restore command" />

</div>

---

My personal Neovim configuration for Arch Linux. Stored here so I can restore my full setup on any machine in a single command.

## Restore

```bash
git clone https://github.com/Mulaydm10/nvim-config.git
cd nvim-config
bash restore_nvim_arch.sh
```

The script:
1. Installs `neovim`, `git`, `unzip`, `curl` via `pacman`
2. Creates `~/.config/nvim`, `~/.local/share/nvim`, `~/.cache/nvim`
3. Copies config files into place

## Layout

```
nvim-config/
├── nvim/                  ← Neovim config (copied to ~/.config/nvim/)
└── restore_nvim_arch.sh   ← One-command restore script
```

## Requirements

- Arch Linux (or any Arch-based distro — Manjaro, EndeavourOS, etc.)
- `pacman` package manager
- Internet connection for package installation

---

<div align="center">
<sub><a href="https://github.com/Mulaydm10">Mulaydm10</a> · Neovim · Arch Linux · Lua</sub>
</div>
