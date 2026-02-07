# Applying changes

On linux:
```
sudo nixos-rebuild switch --flake .#thinkpad
```

On macOS:
```
sudo darwin-rebuild switch --flake .#EL-J5TJLVJ6RK
```

# macOS notes
- setup is designed to be used with standard macOS GB keyboard

# repoconf

"repoconf" is a tool I have set up to allow adding extra config files within my work repos, while
keeping these files personal (i.e. not checked into the repo) but maintained within this nix repo.
The motivating use-case for this was my `.nvim.lua` configs.

To add a config file for a particular repo, you just have to:
- create the file under `./home/joe/repoconf/<repo name>/<file name>`
- build / switch the nix flake using `darwin-rebuild` as detailed above
- run `repoconf` in the relevant repo. This creates symlinks to the relevant files, and also adds them to the repo's `.git/info/exclude`  

# Bootstrapping a new machine

1. Obtain the SSH key from bitwarden and add as `~/.ssh/ed_id25519` & `~/.ssh/ed_id25519.pub`. This keypair is used for pulling from github and also for encrypting/decrypting the secrets in the repo using sops-nix.
2. Clone this repo: `nix-shell -p git --run "mkdir ~/repos && git clone git@github.com:ensconced/nix.git repos/nix && cd repos/nix"`
3. Run `sudo nixos-rebuild switch --flake .#thinkpad`

# SOPS secrets

Secrets are encrypted using age, with the public key defined in `.sops.yaml`.

## Setup

The SSH key at `~/.ssh/id_ed25519` is automatically used by sops-nix for decryption during `nixos-rebuild` / `darwin-rebuild`. No extra setup is needed for that.

To use the `sops` CLI directly (e.g. for editing secrets), you need to generate an age key file from your SSH key:

```
mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run 'ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt'
chmod 600 ~/.config/sops/age/keys.txt
```

## Editing secrets

```
sops home/joe/secrets/main.yaml
```

This opens the decrypted file in your editor. When you save and exit, it re-encrypts automatically.

