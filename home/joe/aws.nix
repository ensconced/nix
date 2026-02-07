{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.file.".aws/config" = {
    text = ''
      [default]
      region = eu-west-1
      output = json
    '';
  };
}
