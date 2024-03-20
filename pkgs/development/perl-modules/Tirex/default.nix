{ lib
, buildPerlPackage
, fetchFromGitHub
, fetchpatch
, GD
, IPCShareLite
, JSON
, LWP
, mapnik
}:

buildPerlPackage rec {
  pname = "Tirex";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "tirex";
    rev = "v${version}";
    hash = "sha256-0QbPfCPBdNBbUiZ8Ppg2zao98+Ddl3l+yX6y1/J50rg=";
  };

  patches = [
    # https://github.com/openstreetmap/tirex/pull/54
    (fetchpatch {
      url = "https://github.com/openstreetmap/tirex/commit/da0c5db926bc0939c53dd902a969b689ccf9edde.patch";
      hash = "sha256-bnL1ZGy8ZNSZuCRbZn59qRVLg3TL0GjFYnhRKroeVO0=";
    })
  ];

  buildInputs = [
    GD
    IPCShareLite
    JSON
    LWP
    mapnik
  ] ++ mapnik.buildInputs;

  installPhase = ''
    install -m 755 -d $out/usr/libexec
    make install DESTDIR=$out INSTALLOPTS=""
    mv $out/$out/lib $out/$out/share $out
    rmdir $out/$out $out/nix/store $out/nix
  '';

  meta = {
    description = "Tools for running a map tile server";
    homepage = "https://wiki.openstreetmap.org/wiki/Tirex";
    maintainers = with lib.maintainers; [ jglukasik ];
    license = with lib.licenses; [ gpl2Only ];
  };
}
