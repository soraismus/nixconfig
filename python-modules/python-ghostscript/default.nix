{ lib
, buildPythonPackage
, ghostscript
, isPy3k
, substituteAll
}:

buildPythonPackage rec {
  pname = "ghostscript";
  version = "0.7";
  disabled = !isPy3k;

  src = fetchGit {
    url = https://bitbucket.org/ebdisplay_dev0/modified-python-ghostscript.git;
    rev = "9657da6244b019e3936fc6069b77b91c8eaa7f55";
  };

  buildInputs = [ ghostscript ];

  patches = [
    (substituteAll {
      src = ./_gsprint.py.patch;
      libgs = "${ghostscript.out}/lib/libgs.so";
    })
  ];

  doCheck = false;

  meta = with lib; {
    description = "Python interface to the GhostScript C-API";
    homepage = https://gitlab.com/pdftools/python-ghostscript;
    license = licenses.mit;
    maintainers = with maintainers; [ "Hartmut_Goebel" ];
  };
}
