+++
date = '2026-10-09T11:27:05+02:00'
draft = false
title = 'Godot with Enet DTLS support on NixOS'
+++

If you're using Godot on NixOS, you might, like me, have come across this error while attemping to compile a project which uses DTLS:
```
ENet DTLS support not available in this build.`
<C++ Error>   Method/function failed. Returning: ERR_UNAVAILABLE
<C++ Source>  modules/enet/enet_connection.cpp:302 @ dtls_client_setup()
```

The reason is simple: By default, Godot from `nixpkgs` is compiled without enet support on Linux.

Now as it turns out, from quickly inspecting the [source file](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/tools/godot/common.nix),
it's quite simple to create an overlay to compile Godot _with_ this enet support enabled.
Simply override the `withBuiltins` argument as follows:
```nix
{
  home.packages = [
    (pkgs.godot.override {
      withBuiltins = true;
    })
  ];
}
```

Be warned that using an overlay like this will result in the binary being unavailable in the Nix cache, so you will have to rebuild Godot from source.
This can be quite a lengthy process, even on faster hardware, so I would avoid using unstable nixpkgs to keep the number of recompilations to a minimum.
