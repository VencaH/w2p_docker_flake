{
  description = "Basic Python flake for web2py app";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
  let
    mkWeb2pyInterpreter = {system, python, packages}: 
      python.withPackages (
        ps: with python.pkgs; [
          google-cloud-firestore
          twisted
        ] ++ packages
      );
  in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python3;

        pythonDeps = python.pkgs.buildPythonPackage {
          pname = "web2py_server";
          version = "0.1.0";
          src = pkgs.lib.cleanSourceWith {
            src = ./.;
            filter = path: type: true;
          };

          format = "pyproject";

          nativeBuildInputs = with python.pkgs; [ 
            setuptools 
            wheel
          ];

            preBuild = ''
              echo "DEBUG: Listing contents of build dir"
              find . | sed 's/^/>> /'
            '';


          postInstall = ''
            chmod +x $out/bin/web2py
            chmod +x $out/bin/anyserver
          '';
          buildInputs = with python.pkgs; [
            google-cloud-firestore
            twisted
          ];
        };

      in {
        packages.default = pythonDeps;
        packages.web2py_server = pythonDeps;
        # apps.web2py_server = 
        # let
        #   web2pyInterpreter = mkWeb2pyInterpreter {
        #     inherit system;
        #     python = pkgs.python3; 
        #     packages = [];
        #   };
        # in { 
        #   type = "app";
        #   program =  "${pkgs.writeShellScriptBin "web2py-server" ''
        #     exec ${web2pyInterpreter}/bin/python ${pythonDeps}/${python.sitePackages}/anyserver.py \
        #       -s twisted "$@"
        #   ''}/bin/web2py-server";
        # };
        devShells.default = pkgs.mkShell {
            buildInputs  = [
                self.packages.${system}.web2py_server
            ];
        };
      }
  ) // {
    lib.web2pyInterpreter = mkWeb2pyInterpreter;
  };
}

