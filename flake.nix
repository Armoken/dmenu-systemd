{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      dmenu-systemd = pkgs.python3Packages.buildPythonApplication {
        pname = "dmenu-systemd";
        version = "1.0";

        propagatedBuildInputs = with pkgs.python3Packages; [
          pystemd
          dbus-python
        ];

        src = ./.;
      };
      python-with-packages = ((pkgs.python3Full.withPackages(ps: [
        ps.ipython # IPython: Productive Interactive Computing.

        ps.pystemd
        ps.dbus-python
      ])).overrideAttrs (args: { ignoreCollisions = true; doCheck = false; }));
    in {
      defaultPackage = dmenu-systemd;
      devShell       = pkgs.mkShell {
        nativeBuildInputs = [
          python-with-packages

          pkgs.pyright                 # Type checker for the Python language.
          pkgs.fish
        ];
        shellHook = ''
        PYTHONPATH=${python-with-packages}/${python-with-packages.sitePackages}
        # maybe set more env-vars
        '';

        runScript = "fish";
      };
    }
  );
}
