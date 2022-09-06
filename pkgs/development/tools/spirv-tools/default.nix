{ lib, stdenv, fetchFromGitHub, cmake, python3, spirv-headers }:

stdenv.mkDerivation rec {
  pname = "spirv-tools";
  version = "1.3.224.1";

  src = (assert version == spirv-headers.version;
    fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "SPIRV-Tools";
      rev = "sdk-${version}";
      hash = "sha256-jpVvjrNrTAKUY4sjUT/gCUElLtW4BrznH1DbStojGB8=";
    }
  );

  nativeBuildInputs = [ cmake python3 ];

  cmakeFlags = [ "-DSPIRV-Headers_SOURCE_DIR=${spirv-headers.src}" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "The SPIR-V Tools project provides an API and commands for processing SPIR-V modules";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.ralith ];
  };
}
