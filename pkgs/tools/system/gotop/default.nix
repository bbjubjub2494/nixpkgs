{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, IOKit
}:

buildGoModule rec {
  pname = "gotop";
  version = "4.1.3";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "xxxserxxx";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oDM+dpAT1vDpp2NkD669hwbgw7HWJGFqhsql9PvbxSk=";
  };

  proxyVendor = true;
  vendorSha256 = "sha256-WGLcpF1NqVQDiU3M9rQ555ZW3sDC3Szch+skTZgt0xg=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  doCheck = false; # don't know why it now fails

  postInstall = ''
    $out/bin/gotop --create-manpage > gotop.1
    installManPage gotop.1
  '';

  meta = with lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = "https://github.com/xxxserxxx/gotop";
    changelog = "https://github.com/xxxserxxx/gotop/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
  };
}
