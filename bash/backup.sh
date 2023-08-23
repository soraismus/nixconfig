# Examples:
#  0. `backup-theo --output-target /usb-toshiba-backup`
#  1. `backup-theo --dry-run --output-target /usb-toshiba-backup`
#  2. `backup-theo --quiet-errors --output-target /usb-toshiba-backup`
#  3. `backup-theo --verbose 1 --output-target /usb-toshiba-backup`

set -o errexit
set -o nounset
set -o pipefail

_backup () {
  backupDir="${1}"
  rsync                                          -av /home/polytope/dl/audio/        ${backupDir}/audio/
  rsync --exclude ebdisplay --exclude scratchpad -av /home/polytope/d/               ${backupDir}/Documents/
  rsync                                          -av /home/polytope/d/ebdisplay/     ${backupDir}/ebdisplay/
  rsync                                          -av /home/polytope/dl/fonts/        ${backupDir}/fonts/
  rsync                                          -av /home/polytope/dl/images/       ${backupDir}/images/
  rsync                                          -av /etc/nixos/                     ${backupDir}/nixos/
  rsync                                          -av /home/polytope/dl/PDFs/         ${backupDir}/PDFs/
  rsync                                          -av /home/polytope/dl/PSs/          ${backupDir}/PSs/
  rsync                                          -av /home/polytope/source-control/  ${backupDir}/source-control/
  rsync                                          -av /home/polytope/.ssh/            ${backupDir}/.ssh/
  rsync                                          -av /home/polytope/dl/videos/       ${backupDir}/videos/
}

die () {
  if [ "${2}" = "1" ]; then
    1>&2 echo "error: ${3}"
  fi
  finalize
  exit "${1}"
}

displayHelpMessage () {
  cat <<END_OF_HELP_MESSAGE

Explanation/Purpose
-------------------
This executable copies pre-selected directories onto the given mounted external drive.

General Options:
------------------
(-?) --help           for help
(-h) --help           for help
     --output-target  specify the path of the mounted storage device, onto which data will be copied

Examples of usage:
------------------
0. backup-theo --output-target /usb-toshiba-backup
1. backup-theo --dry-run --output-target /usb-toshiba-backup
2. backup-theo --quiet-errors --output-target /usb-toshiba-backup
3. backup-theo --verbose 1 --output-target /usb-toshiba-backup

Direct Dependencies:
-------------------
  Programs
  --------

  Functions and Scripts
  ---------------------

END_OF_HELP_MESSAGE
}

finalize () {
  unset _command
  unset backupArgs
  unset outputPath
  unset shouldExecute
  unset verboseErrors
  unset verboseInfo
}

declare -r originalCommand="$(basename $0) $@"
declare -r invalidCommandError=1
declare -r invalidInputPathError=2

declare shouldExecute=1
declare verboseErrors=1

declare _command
declare backupArgs
declare outputPath
declare verboseInfo

# NOTE: The bash option 'u' is unset temporarily
# b/c it doesn't work well with positional parameters.
set +u

while true; do
  case "$1" in
    -d | --dry-run )
      if [ "${shouldExecute}" = "0" ]; then
        die 8 "${verboseErrors}" "The --dry-run flag has already been set."
      fi
      shouldExecute=0
      shift 1
      ;;
    -h | -\? | --help )
      displayHelpMessage
      exit 0
      ;;
    --output-target )
      if [ -v outputPath ]; then
        die 3 "${verboseErrors}" "The --output-target option has already been set."
      fi
      outputPath="${2}"
      shift 2
      ;;
    --quiet-errors )
      if [ "${verboseErrors}x" = "0x" ]; then
        die 26 0 "The --quiet-errors flag has already been set."
      fi
      verboseErrors=0
      shift 1
      ;;
    -v | --verbose )
      if [ -v verboseInfo ]; then
        die 49 "${verboseErrors}" "The --verbose (-v) option has already been set."
      fi
      if [ "${2}x" != "0x" ] && [ "${2}x" != "1x" ] && [ "${2}x" != "2x" ]; then
        die 50 "${verboseErrors}" "The --verbose (-v) option requires an argument, and it must be either '0' (for 'false') or '1' (for 'true' with mininmal verbosity) or '2' (for 'true' with full verbosity)."
      fi
      verboseInfo="${2}"
      shift 2
      ;;
    -- )
      shift 1
      break
      ;;
    -* )
      die 51 "${verboseErrors}" "'""$1""' is an invalid option."
      ;;
    '' )
      break
      ;;
    * )
      die 52 "${verboseErrors}" "'""$1""' is an invalid argument."
      ;;
  esac
done

# NOTE: The following setting doesn't work well with use of '$1' and '$2'.
set -u

if [ ! -v verboseInfo ]; then
  verboseInfo=1
fi

_command="_backup"

if [ ! -v _command ]; then
  die "${invalidCommandError}" "${verboseErrors}" "No valid command has been set."
fi

if [ "${_command}x" = "_backupx" ]; then # {
  if [ ! -v outputPath ]; then # {
    die "${invalidInputPathError}" "${verboseErrors}" \
      "No output target path has been provided."
  elif [ ! -d "${outputPath}" ]; then
    die "${invalidInputPathError}" "${verboseErrors}" \
      "The provided output target path does not exist or is not otherwise valid."
    :
  fi # }
fi # }

if [ "${_command}x" = "_backupx" ]; then # {
  backupArgs=()
  backupArgs+=( "${outputPath}" )
fi # }

if [ "${verboseInfo}x" = "2x" ]; then # {
  die 69 "${verboseErrors}" "Verbosity level 2 is not yet supported."
elif [ "${verboseInfo}x" = "1x" ]; then # {
  if [ "${shouldExecute}x" = "0x" ]; then # {
    echo "DRY RUN: Command to be executed: '${originalCommand}'"
  else # } {
    echo "Command to be executed: '${originalCommand}'"
  fi # }
  echo
  echo "Explanation: This copies pre-selected directories onto the given mounted external drive."
  echo
  if [ "${_command}x" = "_backupx" ]; then # {
    echo "Steps:"
    echo "  (0)" _backup "${outputPath}"
  else # } {
    die 69 "${verboseErrors}" "'${_command}' is not a recognized valid command."
  fi # }
  echo
  if [ "${shouldExecute}x" = "1x" ]; then # {
    echo "Executing stages now..."
    echo
  fi # }
fi # }

if [ "${shouldExecute}x" = "1x" ]; then # {
  if [ "${_command}x" = "_backupx" ]; then # {
    if [ -v backupArgs ]; then # {
      _backup "${backupArgs[@]}"
    else # } {
      die 70 "${verboseErrors}" "The variable 'backupArgs' has not been set."
    fi # }
  fi # }
fi # }

finalize

############ %%%%%%%%%%%%%%%%%%%%% ^^^^^^^^^^^^^^^^^^^^


##sudo mount /dev/disk/by-id/usb-TOSHIBA_External_USB_3.0_20200906022029F-0\:0 /usb-toshiba-backup/



