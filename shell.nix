{pkgs, ...}:
pkgs.mkShell {
  packages = with pkgs; [
    # use the Elixr/OTP versions defined above; will also install OTP, mix, hex, rebar3
    elixir

    # mix needs it for downloading dependencies
    git

    # probably needed for your Phoenix assets
    nodejs_20

    # IEx support
    inotify-tools
    libnotify
  ];

  shellHook = ''
    # allows mix to work on the local directory
    mkdir -p .nix-mix
    mkdir -p .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export ERL_LIBS=$HEX_HOME/lib/erlang/lib

    # concats PATH
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$MIX_HOME/escripts:$PATH
    export PATH=$HEX_HOME/bin:$PATH

    # enables history for IEx
    export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_path '\"$PWD/.erlang-history\"'"
  '';
}
# pkgs.devshell.mkShell {
#   name = "elixir dev env";
#   packages = with pkgs; [
#     # use the Elixr/OTP versions defined above; will also install OTP, mix, hex, rebar3
#     elixir
#     # mix needs it for downloading dependencies
#     git
#     # probably needed for your Phoenix assets
#     nodejs_20
#     # IEx support
#     inotify-tools
#     libnotify
#   ];
#   env = {
#   };
#   commands = [
#     {
#       name = "setup";
#       category = "project";
#       help = "good luck";
#       command = "podman compose up -d postgres && while ! pg_isready -h localhost -U postgres; do sleep 1; done && mix ecto.create";
#     }
#   ];
# }

