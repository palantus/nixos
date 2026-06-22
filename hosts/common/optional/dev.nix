{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rustc
    clippy #linter
    gcc
    rustfmt
    cargo
    gh # Github cli
  ];
}
