{ config, lib, ... }: with lib.j; {
    imports = flatten [
        (imprelib.list { dir = ./.; })
        (imprelib.list { dir = ../../config; })
    ];
    config.networking.hostId = "f0d4b25e";
}
