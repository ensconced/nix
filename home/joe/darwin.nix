{
  pkgs,
  lib,
  config,
  ...
}:
let
  homeDirectory = "/Users/joe.barnett";
in
{
  imports = [ ./common-packages.nix ];
  home.packages = [
    pkgs.kubectl
  ];
  home.username = "joe.barnett";
  home.homeDirectory = homeDirectory;
  home.file.ghostty-config = {
    text = import ./ghostty.nix { inherit pkgs; };
    target = "./.config/ghostty/config";
  };
  home.file.karabiner-config = {
    source = ./karabiner-elements;
    target = "./.config/karabiner";
  };
  home.file.fnm-completions = {
    source = ./fnm-completions.fish;
    target = "./.config/fish/completions/fnm.fish";
  };
  home.file.fnm-config = {
    text = "fnm env --use-on-cd --version-file-strategy=recursive --shell fish | source";
    target = "./.config/fish/conf.d/fnm.fish";
  };
  home.file.ssh-config = {
    source = ./ssh-config;
    target = "./.ssh/config";
  };
  home.file.nvim-config = {
    source = ./neovim/init.lua;
    target = "./.config/nvim/init.lua";
  };
  home.file.git-ignore = {
    source = ./git-ignore;
    target = "./.config/git/ignore";
  };
  home.file.git-config = {
    source = ./git-config;
    target = "./.config/git/config";
  };
  home.file.spotify-player-config = {
    source = ./spotify-player-config.toml;
    target = "./.config/spotify-player/app.toml";
  };
  home.sessionVariables = {
    HUSKY_SKIP_HOOKS = "1";
    HUSKY = "0";
    TEAM_ID = "148ff854-7a28-460e-808a-b79a95ff7564";
    PROD_ACTOR_ID = "96528bab-ca2c-485c-bf9d-acdfa91168e8";
    DEV_ACTOR_ID = "e5ccf91e-e5d8-4929-8510-ea9bf56aa69a";
    # Here we merge two config files. The first one is NOT managed by nix, and will be written to by kubeconfig when e.g. changing contexts.
    # The second one is managed by nix and will be readonly.
    KUBECONFIG = "${homeDirectory}/.kube/config:/Users/joe.barnett/.kube/base-config";
    PGSSLROOTCERT = "${homeDirectory}/.postgres-root-certs.crl";
  };
  sops = {
    age.sshKeyPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];
    defaultSopsFile = ./secrets/main.yaml;
    secrets.example-env = {
      path = "${homeDirectory}/.config/fish/conf.d/example-env.fish";
    };
  };
  home.file.repoconf = {
    source = ./repoconf;
    target = "./.repoconf";
    force = true;
  };
  home.file.postgres-root-certs = {
    text = "${builtins.readFile ./eu-west-1-bundle.pem}";
    target = "./.postgres-root-certs.crl";
  };
  home.file.kubeconfig-base = {
    source = ./kubeconfig-base.yml;
    target = "./.kube/base-config";
  };
  home.activation.ensureWritableKubeConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="$HOME/.kube/config"
    dir="$(dirname "$target")"
    mkdir -p "$dir"

    if [ ! -f "$target" ]; then
      {
        printf '# kubeconfig created by Home Manager\n'
        printf '# Note that the KUBECONFIG environment variable is set up\n'
        printf '# such that this config file will be merged into the base ~/.kube/base-config.\n'
        printf '# The difference is, this config file is writable so kubeconfig can use it for setting\n'
        printf '# the current context etc.\n'
      } >"$target"
      chmod 600 "$target"
    fi
  '';
}
