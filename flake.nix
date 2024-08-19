{
  description = "A Nix-flake-based Elixir development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    devshell.url = "github:numtide/devshell";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    supportedSystems = ["x86_64-linux" "aarch64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default # define elixir packages
              inputs.devshell.overlays.default # add devshell
            ];
          };
        });
  in {
    overlays.default = final: prev: rec {
      # documentation
      # https://nixos.org/manual/nixpkgs/stable/#sec-beam

      # ==== ERLANG ====

      # use latest version of Erlang 27
      erlang = final.beam.interpreters.erlang_27;

      # ==== BEAM packages ====

      # all BEAM packages will be compile with your preferred erlang version
      pkgs-beam = final.beam.packagesWith erlang;

      # ==== Elixir ====

      # use latest version of Elixir 1.17
      elixir = pkgs-beam.elixir_1_17;
    };

    devShells = forEachSupportedSystem ({pkgs}: {
      default = import ./shell.nix {inherit pkgs;};
    });
  };
}
