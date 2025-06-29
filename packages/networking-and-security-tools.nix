{ pkgs }:

with pkgs; [
  age           # file encryption tool
  gnupg         # gnu privacy guard, a gpl openpgp implementation
  hashcat       # password cracker
  hashcat-utils # utilities for advanced password cracking
  macchanger    # utility for manipulating MAC addresses
  nmap          # utitlity for network discovery and security auditing
  openssh       # implementation of the SSH protocol
  openssl       # cryptographic library that implements tsl protocol
  pass          # password-store manages passwords securely
  sops          # secret manager
  tcpdump       # network sniffer
  wget          # tool for retrieving files using http, https, and ftp [cf. curl]
  wireshark-cli # network-protocol analyzer
  xh            # curl alternative for sending http packets

  # Consider
  # --------
  # burpsuite   # integrated platform for performing security testing
]
