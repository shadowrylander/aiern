{ config, lib, pkgs, system, ... }: with builtins; with lib; with j; {
    environment.etc = let
        kata-containers = {
            default-runtime = "kata-runtime";
            # runtimes.kata-runtime.path = "${getBin pkgs.kata-containers}/bin/kata-runtime";
            runtimes.kata-runtime.path = "${getBin pkgs.kata-containers.runtime}/bin/kata-runtime";
        };
        kc = toJSON kata-containers;
    in {
        "nix/nix.conf".text = attrs.configs.nix;
        ${myIf.knull (!elem system [ "aarch64-linux" ]) "containers/storage.conf"}.text = kc + ''
            [storage]
            driver = "zfs"
            rootless_storage_path = "/var/lib/podman/$USER"

            [storage.options]
            additionalimagestores = [
                "/var/lib/docker",
            ]

            # [storage.options.zfs]
        '';
        ${myIf.knull (!elem system [ "aarch64-linux" ]) "containers/libpod.conf"}.text = kc;
        ${myIf.knull (!elem system [ "aarch64-linux" ]) "docker/daemon.json"}.text = kc;
    };
}
