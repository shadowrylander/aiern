{ config, lib, pkgs, ... }: with builtins; with lib; with j; {
    specialisation = let
        specialisation_base =
            {
                patches = {
                    dir = rec {
                        base = lib.j.paths.patches;
                        "57" = "${base.surface}/5.7";
                        "58" = "${base.surface}/5.8";
                    };
                    get = dir: with r; list {
                        suffix = ".patch";
                        dir = (/. + d);
                        func = (file: v: { patch = file; name = name { inherit suffix file; }; });
                    };
                };
                base = {
                    settings = { inheritParentConfig = true; };
                    kernel.extraConfig = ''
                        SERIAL_DEV_BUS y
                        SERIAL_DEV_CTRL_TTYPORT y
                        SURFACE_SAM m
                        SURFACE_SAM_SSH m
                        SURFACE_SAM_SAN m
                        SURFACE_SAM_DTX m
                        INPUT_SOC_BUTTON_ARRAY m
                        SURFACE_3_POWER_OPREGION m
                        SURFACE_3_BUTTON m
                        SURFACE_3_POWER_OPREGION m
                        SURFACE_PRO3_BUTTON m
                    '';
                    patches = [
                        { patch = /. + "${patches.dir.base._}/export_kernel_fpu_functions_5_3.patch"; name = "export_kernel_fpu_functions_5_3"; }
                        { patch = /. + "${patches.dir.base._}/set_power_mgmt.patch"; name = "set_power_mgmt"; }
                    ];
                    iabg = [{ patch = /. + "${patches.dir.base._}/0110-initialize-ata-before-graphics.patch"; name = "0110-initialize-ata-before-graphics"; }];
                };
            };
        inherit (lib.j.paths.patches) _;
        base = {
            specialisation = { inheritParentConfig = true; };
            kernel = {
                kernelPatches = specialisation_base.base.iabg;
            };
        };
    in {
        clear = base.specialisation // {
            configuration = {
                config = {
                    boot = base.kernel // { kernelPackages = pkgs.linuxPackages_latest; };
                };
            };
        };
        zen = base.specialisation // {
            configuration = {
                config = {
                    boot = base.kernel // { kernelPackages = pkgs.linuxPackages_zen; };
                };
            };
        };
        bcachefs = base.specialisation // {
            configuration = {
                config = {
                    boot = base.kernel // {
                        kernelModules = [ "bcachefs" ];
                        initrd = {
                            kernelModules = [ "bcachefs" ];
                            availableKernelModules = [ "bcachefs" ];
                            supportedFilesystems = [ "bcachefs" ];
                        };
                        supportedFilesystems = [ "bcachefs" ];
                    };
                };
            };
        };
        clear_xen = base.specialisation // {
            inheritParentConfig = true;
            configuration = {
                config = {
                    boot = base.kernel // { kernelPackages = pkgs.linuxPackages_latest_xen_dom0; };
                };
            };
        };
    };
}
