{
  description = "Basic Python flake for web2py app";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python3;

        pythonDeps = python.pkgs.buildPythonApplication {
          pname = "sprint_planner";
          version = "0.1.0";
          src = pkgs.lib.cleanSource ./.;

          format = "pyproject";

          nativeBuildInputs = with python.pkgs; [ setuptools wheel ];
          buildInputs = with python.pkgs; [
            pytest
            python-lorem
            google-cloud-firestore
            twisted
          ];

        };
      in {
        packages.default = pythonDeps;
        packages.web2py_server = pythonDeps;
    });
}

