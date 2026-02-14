{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Seed ~/.aws/config with defaults but keep it mutable, since commands
  # like `aws sso login` expect to be able to write to the config file.
  home.activation.awsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "${config.home.homeDirectory}/.aws/config" ] || [ -L "${config.home.homeDirectory}/.aws/config" ]; then
      mkdir -p "${config.home.homeDirectory}/.aws"
      rm -f "${config.home.homeDirectory}/.aws/config"
      cp "${./aws-config}" "${config.home.homeDirectory}/.aws/config"
      chmod u+w "${config.home.homeDirectory}/.aws/config"
    fi
  '';
}
