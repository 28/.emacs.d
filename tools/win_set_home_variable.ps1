# For Windows only. Must be run as an Administrator.
# Sets the 'HOME' path variable to current user's
# home directory which Emacs needs in order to find
# the .emacs.d directory.
setx /M HOME (Get-Item Env:USERPROFILE).Value
