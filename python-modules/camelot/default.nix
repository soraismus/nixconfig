{ lib
, buildPythonPackage
, chardet
, click
, cv2
, fetchFromBitbucket
, ghostscript
, isPy3k
, numpy
, openpyxl
, pandas
, pdfminer_six
, pypdf
, python-ghostscript
, tabulate
, tkinter
}:

buildPythonPackage rec {
  pname = "camelot";
  version = "0.11.0";
  disabled = !isPy3k;

  src = fetchFromBitbucket {
    owner = "ebdisplay_dev0";
    repo = "modified-camelot";
    rev = "07a9dae000a8357b81a55b1ea2d86441e791df52";
    sha256 = "0mb49i87c6yn95sinsx79m5hf78vc8gi84hjcwlybi8gi48mnr0m";
  };

  buildInputs = [ ghostscript ];

  propagatedBuildInputs =
    [
      chardet
      click
      cv2
      numpy
      openpyxl
      pandas
      pdfminer_six
      pypdf
      python-ghostscript
      tabulate
      tkinter
    ];

  doCheck = false;

  pythonImportsCheck = [ "cv2" ];

  meta = with lib; {
    description = "PDF Table Extraction";
    homepage = "https://camelot-py.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ "Vinayak_Mehta" ];
  };
}
