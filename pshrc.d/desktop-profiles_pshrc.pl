#!/usr/bin/perl

# This fixes the desktop-profiles corner-case where a graphical client is 
# started through an 'ssh -X' session in which the Xsession.d scripts are 
# not run, so we need to make sure the profiles are activated according to
# the specified settings at login).
$DESKTOP_PROFILES_SNIPPET = '/usr/share/desktop-profiles/get_desktop-profiles_variables';

if ( -e $DESKTOP_PROFILES_SNIPPET ) {
  $TEMP_FILE = `tempfile`;

  # get rid of extranous newline, which messed things up later
  { $TEMP_FILE =~ s/\n// }

  # use bash to write the required environment settings to a tempfile
  # this file has a 'VARIABLE=VALUE' format
  `bash $DESKTOP_PROFILES_SNIPPET $TEMP_FILE`;

  # source to set the required environment variables
  # needs to become: $ENV{'VARIABLE'} = 'VALUE'; 
  {
    open(input, $TEMP_FILE);
    while($env_var = <input>) {
      # needs to become: $ENV{'VARIABLE'} = 'VALUE'; 
      $env_var =~ s/^(.*)=(.*)$/\\\\$ENV{'\1'} = '\2'/ ;
      eval $env_var;
    }
  }
  
  # cleanup
  `rm $TEMP_FILE`;
}
