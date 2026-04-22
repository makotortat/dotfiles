# Quick Start

## Install
To manually install this dotfile, clone the repo to any directory.
   ```
   $ export WORKSPACE=~/work
   $ mkdir -p $WORKSPACE
   $ cd $WORKSPACE
   $ git clone ${target}
   ```
Run the following script.
   ```
   $ cd ${cloned_dir}
   $ ./setup_dotfile.sh
   ```

If powershell needed, run the following script.
   ```
   $ cd ${cloned_dir}
   $ pwsh -NoProfile -ExecutionPolicy Bypass -File "powershell\profile.ps1" -Install 
   ```
