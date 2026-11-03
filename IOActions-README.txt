Some of the files in this directory provide an (ad hoc) packaging
of Haskell prelude and standard library functions as "IO Actions".
These files are intended to be used as part of an introduction to
the use of Haskell's IO type.  For other applications, it would
likely make more sense just to use to original prelude functions
and or libraries directly.

The main files are as follows:

IOActions.lhs:
  A collection of standard IO Actions from the Haskell prelude.
  This file should load and be usable in both Hugs and ghci
  without any special treatment.  (Do not be concerned if you load
  this file in ghci and see a warning indicating that "Module
  'System.Cmd' is deprecated'; this allows the same source file to
  be loaded in both ghci and Hugs.  If you only plan to use this
  file in ghci, you can edit the source code to use System.Process
  instead, as described by comments in the file.)  Note that, even
  after you have made the edits above, you will need to use the
  following command to load IOActions.lhs in ghci:

    ghci -package directory -package process IOActions.lhs

IOExercises.lhs:
  A template with some simple IO actions exercises for you to try
  filling out ... I will likely share my solutions at some point,
  but I encourage you to try to recreate them for yourself before
  that!  A suitable command line for running IOExercises with ghci
  (to ensure that the code has access to required libraries) is
  as follows:

    ghci -package directory -package process IOExercises.lhs

WebActions.lhs:
  This file packages up some simple IO Actions downloading and
  manipulating pages and files from the web; it is intended
  primarily for demonstration purposes.  Again, if you wanted to
  use functions like this in a real application, it would likely
  make more sense to import the items that you need directly from
  the libraries where they are defined rather than using this
  module.

  The WebActions file relies on libraries that (I think) are only
  available for ghc/ghci.  So sorry, you probably won't be able to
  use it with Hugs.  Before you can load this file in ghci, you
  will need to install some libraries that it depends on.  The
  following sequence of commands can be used to accomplish this
  (note that this may take some time to complete, especially the
  last line):

    cabal update
    cabal install uri --user
    cabal install tagsoup --user
    cabal install http-conduit --user

  I have tested this on a recent macOS release and on the
  departmental Linux machines.  The same commands, or something
  very similar, should also work on other Unix-based (and perhaps
  Windows-based) machines.  The "--user" flag indicates that the
  libraries should be installed in a subfolder of your home
  directory, so you do not require special system write access.

  Note that you will need to use the following command to load
  WebActions.lhs in ghci:

    ghci -package directory -package process \
         -package tagsoup -package http-conduit \
         -package bytestring -package text -package uri \
         WebActions.lhs

