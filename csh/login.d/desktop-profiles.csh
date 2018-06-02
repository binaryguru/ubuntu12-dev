#!/bin/csh

# This fixes the desktop-profiles corner-case where a graphical client is 
# started through an ssh -X session (in which the Xsession.d scripts aren't 
# run, so we need to make sure the profiles are activated according to the 
# specified settings at login).
set DESKTOP_PROFILES_SNIPPET="/usr/share/desktop-profiles/get_desktop-profiles_variables"
if (-e $DESKTOP_PROFILES_SNIPPET) then
  # initialization
  set TEMP_FILE=`tempfile`

  # use bash to write the required environment settings to a tempfile
  # this file has a VARIABLE=VALUE format
  bash $DESKTOP_PROFILES_SNIPPET $TEMP_FILE

  # convert to csh format and source to set the required environment variables
  sed -i 's/^\(.*\)=\(.*\)$/setenv \1 \2/' $TEMP_FILE
  source $TEMP_FILE

  # cleanup
  rm $TEMP_FILE
endif
