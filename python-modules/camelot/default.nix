{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, ghostscript
, isPy3k
, cv2
, numpy
, pandas
, pdfminer_six
, pypdf2
, tabulate
, tkinter
}:

buildPythonPackage rec {
  pname = "camelot";
  version = "0.10.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "camelot-dev";
    repo = "camelot";
    rev = "644bbe7c6d57b95aefa2f049a9aacdbc061cc04f";
    sha256 = "1ilydr0cbc39z4nqkyyiq6skig09k9jz16s5a902v4ajg2s1nz7v";
  };

  propagatedBuildInputs =
    [
      click
      ghostscript
      cv2
      pandas
      pdfminer_six
      pypdf2
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
