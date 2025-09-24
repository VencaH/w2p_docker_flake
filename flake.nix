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
          pname = "web2py_server";
          version = "0.1.0";
          src = pkgs.lib.cleanSource ./.;

          format = "pyproject";

          nativeBuildInputs = with python.pkgs; [ 
            setuptools 
            wheel
            pytest
          ];
          propagatedBuildInputs = with python.pkgs; [
            python-lorem
            google-cloud-firestore
            twisted
          ];

        };
      in {
        packages.default = pythonDeps;
        packages.web2py_server = pythonDeps;
        apps.web2py_server = 
        let
          web2pyInterpreter = pkgs.python3.withPackages (
            ps: self.packages.${system}.web2py_server.propagatedBuildInputs
          );
        in { 
          type = "app";
          program =  "${pkgs.writeShellScriptBin "web2py-server" ''
            exec ${web2pyInterpreter}/bin/python ${pythonDeps}/${python.sitePackages}/anyserver.py \
              -s twisted "$@"
          ''}/bin/web2py-server";
        };
      }
  );
}

