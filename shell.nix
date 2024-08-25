{ pkgs ? import <nixpkgs>{} }:
with import <nixpkgs>{};
let
  python-with-packages = ((pkgs.python312Full.withPackages(ps: [
    ps.ipython     # IPython: Productive Interactive Computing.
    ps.pystemd     # Thin Cython-based wrapper on top of libsystemd, focused on exposing the dbus API via sd-bus in an automated and easy to consume way.

    ps.dbus-python # A zero-dependency DBus library for Python with asyncio support.
  ])).overrideAttrs (args: { ignoreCollisions = true; doCheck = false; }));
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    python-with-packages

    nodePackages.pyright                 # Type checker for the Python language.
    vscode-extensions.ms-pyright.pyright # VS Code static type checking for Python.

    fish
  ];
  shellHook = ''
  PYTHONPATH=${python-with-packages}/${python-with-packages.sitePackages}
  # maybe set more env-vars
  '';

  runScript = "fish";
}
