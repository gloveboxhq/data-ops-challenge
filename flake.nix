{
  description = "data-ops-challenge";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self, nixpkgs, flake-utils
  }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };
  in {

    packages.default = pkgs.stdenvNoCC.mkDerivation {
      name = "data-ops-challenge";

      nativeBuildInputs = (with pkgs; [
        xsv
        jq
      ]);

      src = ./.;

      buildPhase = ''
        mkdir -p $out
        mkdir workdir
        # Copy files without preserving permissions
        cp -r --no-preserve=mode $src/* workdir/
        cd workdir
        mkdir build
        # Now chmod should work
        chmod +x transform.bash
        # Run using bash explicitly
        BUILD_DIR=$PWD/build bash transform.bash
        cp -r build/* $out/
      '';

      doCheck = true;
      checkPhase = ''
        diff -q $src/tests/output.csv $out/user-policies.csv
      '';
    };
  });
}
