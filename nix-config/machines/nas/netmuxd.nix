{ lib, rustPlatform, fetchFromGitHub, cmake }:

rustPlatform.buildRustPackage rec {
  pname = "netmuxd";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "jkcoxson";
    repo = "netmuxd";
    rev = "v${version}";
    hash = "sha256-XXw9a1m9EvhukeE2sZOu3pAiQ5hwWiDs7eOVjQE3BD4=";
  };

  cargoHash = "sha256-QSdhjjAZon+G8QbVamZArTjbOD21rZC41/fJOtjp8OU=";

  # aws-lc-sys
  nativeBuildInputs = [ cmake ];
  dontUseCmakeConfigure = true;

  meta = {
    description = "usbmuxd replacement with Wi-Fi device support";
    homepage = "https://github.com/jkcoxson/netmuxd";
    license = lib.licenses.lgpl21Only;
    mainProgram = "netmuxd";
  };
}
