{ denTest, ... }:
{
  flake.tests.bogus = {

    test-something = denTest (
      {
        den,
        lib,
        igloo,
        tuxHm,
        ...
      }:
      let
        nixClass =
          { class, aspect-chain }:
          den._.forward {
            each = [
              "nixos"
              "homeManager"
            ];
            fromClass = _: "nix";
            intoClass = lib.id;
            intoPath = _: [ "nix" ];
            fromAspect = _: lib.head aspect-chain;
            adaptArgs = lib.id;
          };
      in
      {
        den.hosts.x86_64-linux.igloo.users.tux = { };

        den.default.includes = [ den._.mutual-provider ];

        den.aspects.tux.provides.igloo = {
          includes = [ nixClass ];
          nix.settings.core = 64;
        };

        # NOTE: Uncomment this line below to fix the test:
        # den.default.includes = [ nixClass ];

        expr = [
          igloo.nix.settings.core or null
          tuxHm.nix.settings.core or null
        ];

        expected = [
          64
          64
        ];
      }
    );

  };
}
