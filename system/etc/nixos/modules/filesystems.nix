{ config, lib, host, ... }: with builtins; with lib; with j; mkIf (config.vars.zfs) { fileSystems = let
    inherit (attrs.fileSystems) base;
    fileSystems' = import ./config/datasets.nix host;
in mapAttrs' (dataset: mountpoint: nameValuePair mountpoint (
    mkForce (base // { device = dataset; ${
        myIf.knull (hasInfix "persist" dataset) "neededForBoot"
    } = true; })
)) fileSystems'; }
