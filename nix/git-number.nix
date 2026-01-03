{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "git-number";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "holygeek";
    repo = pname;
    rev = version;
    sha256 = "01jjx5264apf2zvxyxshmijavygyzsappa5j6h28xxpvy9k75l36";
  };
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/git-* $out/bin
  '';
}
