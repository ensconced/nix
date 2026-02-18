{ pkgs, pkgsUnstable, ... }:
[
  (pkgs.writeShellScriptBin "versions" ''
    # show location and version of each instance of an installed package. usage: `versions react`
    ${pkgs.findutils}/bin/find . -name package.json -regex ".*/node_modules/$1/package.json" -exec echo -n {} " " ';' -exec ${pkgs.jq}/bin/jq --raw-output .version {} ';'
  '')
  (pkgs.writeShellScriptBin "rmnm" ''
    ${pkgs.findutils}/bin/find . -type d -name node_modules -prune -exec rm -r '{}' \;
  '')
  (pkgs.writeShellScriptBin "repoconf" ''
    # find config files for this repo and add symlinks to them
    set -eu

    add_to_personal_gitignore() {
      gitignore_pattern="/$1"
      if grep -Fxq "$gitignore_pattern" .git/info/exclude; then
        echo "$gitignore_pattern" is already in .git/info/exclude
      else
        echo adding "$gitignore_pattern" to .git/info/exclude
        echo "$gitignore_pattern" >> .git/info/exclude
      fi
    }

    reponame=$(basename $(pwd))
    confdir=~/.repoconf/"$reponame"
    echo confdir is $confdir
    pushd "$confdir" > /dev/null

    nix_dir=~/repos/nix
    if ! [ -d "$nix_dir" ]; then
      echo "nix repo not present at $nix_dir"
      exit 1
    fi

    # get files without leading ./
    files=$(${pkgs.findutils}/bin/find . -type f -printf '%P\n')

    popd > /dev/null
    for file in $files; do
      if [ "$file" != "flake.nix" ] && [ "$file" != "flake.lock" ]; then
        symlink_dest="$confdir/$file"
        echo symlinking $file to $symlink_dest
        ln -sf "$symlink_dest" "$file"
        add_to_personal_gitignore "$file"
      fi
    done 

    repo_conf_dir="$nix_dir/home/joe/repoconf/$reponame"
    if [ -f "$repo_conf_dir/flake.nix" ]; then
      echo "use flake $repo_conf_dir" > .envrc
      add_to_personal_gitignore .envrc
      add_to_personal_gitignore .direnv
      direnv allow
    fi
  '')
  (pkgs.writeShellScriptBin "notes" ''
    set -eu
    mkdir -p ~/notes
    cd ~/notes
    vi . 
  '')
  (pkgs.writeShellScriptBin "todo" ''
    set -eu
    mkdir -p ~/notes
    cd ~/notes
    vi todos.md
  '')
  (pkgs.writeShellScriptBin "ecrpull" (builtins.readFile ./scripts/ecrpull))
]
