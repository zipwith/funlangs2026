# funlangs2026
Code samples for Functional Programming, Fall 2026

* Week 6

  - `game`: a folder containing various versions of the
    guess-a-number game that we developed interactively
    in class.  This includes the final version of the
    game (in `guess.lhs`) as well as an attempt to
    reconstruct some of the intermediate steps (also
    adding in some documentation in the process):

    - `guess0.lhs`: A simple function that compares a guess
       with a secret value.
    - `guess1.lhs`: Adding a function to ask the player to
      enter a guess.
    - `guess2.lhs`: Adding code to generate a secret number.
    - `guess3.lhs`: Adding a loop if the player's guess is
       incorrect.
    - `guess4.lhs`: Adding a counter to limit the number of
      guesses that players are allowed to make.
    - `guess5.lhs`: Refactoring to store all game state in a
      single data value.
    - `guess6.lhs`: Adding a "cheat" code for certain players :-)
    - `guess7.lhs`: Adding some type signatures to provide
      program documentation.

  - `IOActions-README.txt`: Some details explaining how to
    us the IOActions examples.

  - `IOActions.lhs`: A repackaging of some standard Haskell
    functions to be used "IO Actions".

  - `IOExercises.lhs`: A template for some exercises using
    IO Actions.

  - `WebActions.lhs`: A library of IO actions for downloading
    files and processing web pages.  (See `IOActions-README.txt`
    for further details about these files, including information
    on how to install the necessary packages to use
    `WebActions.lhs`.)

* Week 5

  - `Expr.lhs`: An example showing how to use the Treedot
    library with a simple data type of expressions.

* Week 4

  - `pathological.lhs`: An example illustrating pathological
    behavior of Haskell-style type inference.

  - `subtleties.lhs`: Some examples illustrating some subtle
    details of Haskell-style type inference.

  - `Treedot.lhs`: A library for generating GraphViz/dot files
    for tree-like data structures using a simple variant of the
    approach that was presented in lectures.

* Week 3

  - `datatypes.lhs`: Some examples of datatype definitions
    from the lecture.

  - `bst.lhs`: A literate version of the binary search tree
    example from the lecture.

* Week 2

  - `group.lhs`: Some examples demonstrating the use of
    function composition to build some interesting utility
    functions, as well as an example illustrating the use
    of literate files to include commentary and sample
    outputs.

  - `say.lhs`: A little program for printing short messages
    using big characters (formed out of little characters)!

  - `fibs.lhs`: Various ways to implement Fibonacci functions,
    (and to test that they produce the same results ...)

  - `pascal.lhs`: A demonstration program that can display
    versions of Pascal's triangle, built using standard list
    processing functions.

* Week 1

  - `composing-fractals.lhs`: a single file version of the
    fractals program

  - `fractals/`: a folder containing a more sophisticated
    version of the fractals program, spread over multiple
    "modules", including "literate" code, and using the
    GHC compiler.

