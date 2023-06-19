{ lib
, buildPythonPackage
, chardet
, click
, ghostscript
, isPy3k
, cv2
, numpy
, openpyxl
, pandas
, pdfminer_six
, pypdf2
, python-ghostscript
, tabulate
, tkinter
}:

buildPythonPackage rec {
  pname = "camelot";
  version = "0.10.1";
  disabled = !isPy3k;

  src = fetchGit {
    url = https://bitbucket.org/ebdisplay_dev0/modified-camelot.git;
    rev = "937cb2db551df3f807b231a963ff6dd6a89a3324";
  };

  buildInputs = [ ghostscript ];

  patches = [ ./ghostscript_backend.py.patch ];

  propagatedBuildInputs =
    [
      chardet
      click
      cv2
      numpy
      openpyxl
      pandas
      pdfminer_six
      pypdf2
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
