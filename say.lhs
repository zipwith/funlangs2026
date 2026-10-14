> import Data.List
> import Data.Char

-------------------

> say  :: String -> String
> say   = ('\n':)
>       . unlines
>       . map (foldr1 (\xs ys->xs++"  "++ys))
>       . transpose
>       . map picChar

-------------------

The following walk through shows how the say function works,
building up to the final result in steps, each of which adds
one more part of the function composition in the definition of
say.  For clarity, I have reformatted both the expressions and
the outputs at each stage so that it is easier to see what is
going on.

We will start with a specific input string:

  Main> "Hello!"
  "Hello!"

The string is just a list of six characters, so we can use map
picChar to replace each character with the appropriate data
for each character (see the definition of picChar below):

  Main> map picChar
     $ "Hello!"

  [["H   H","H   H","HHHHH","H   H","H   H"],
   ["EEEEE","E    ","EEEEE","E    ","EEEEE"],
   ["L    ","L    ","L    ","L    ","LLLLL"],
   ["L    ","L    ","L    ","L    ","LLLLL"],
   [" OOO ","O   O","O   O","O   O"," OOO "],
   [" !!  "," !!  "," !!  ","     "," !!  "]]

This list has six elements (one for each character), each of
which is a list with five elements (one for each row in the
character).  What we need now is a list of five rows, with one
column for each character.  In short, this is an application
for transpose!

  Main> transpose
      $ map picChar
      $ "Hello!"

  [["H   H","EEEEE","L    ","L    "," OOO "," !!  "],
   ["H   H","E    ","L    ","L    ","O   O"," !!  "],
   ["HHHHH","EEEEE","L    ","L    ","O   O"," !!  "],
   ["H   H","E    ","L    ","L    ","O   O","     "],
   ["H   H","EEEEE","LLLLL","LLLLL"," OOO "," !!  "]]

Now we have the five rows that we expect to see in the output,
but each of those rows contains a list of separate strings
that need to be joined together.  We can use foldr1 to insert
a couple of spaces between each of the strings:

  Main> map (foldr1 (\xs ys->xs++"  "++ys))
      $ transpose
      $ map picChar
      $ "Hello!"

  ["H   H  EEEEE  L      L       OOO    !!  ",
   "H   H  E      L      L      O   O   !!  ",
   "HHHHH  EEEEE  L      L      O   O   !!  ",
   "H   H  E      L      L      O   O       ",
   "H   H  EEEEE  LLLLL  LLLLL   OOO    !!  "]

Now we have just five strings in the list, one for each row in
the output.  The next step is to insert newlines between each
of these items to join them into a single string:

  Main> unlines
      $ map (foldr1 (\xs ys->xs++"  "++ys))
      $ transpose
      $ map picChar
      $ "Hello!"

  "H   H  EEEEE  L      L       OOO    !!  \n\
  \H   H  E      L      L      O   O   !!  \n\
  \HHHHH  EEEEE  L      L      O   O   !!  \n\
  \H   H  E      L      L      O   O       \n\
  \H   H  EEEEE  LLLLL  LLLLL   OOO    !!  \n"

(The output here is a single string.  I've added backslashes
at the end of each line and one backslash at the beginning of
the next line: all of the characters between those pairs of
backslashes are deleted.  This syntax, known as "gap
notation", is actually supported directly in Haskell!)

All that is required to complete our program is to use the
putStrLn function, which, as we'll see in more detail later,
turns a string into program that prints the string.

  Main> putStrLn
      $ unlines
      $ map (foldr1 (\xs ys->xs++"  "++ys))
      $ transpose
      $ map picChar
      $ "Hello!"

  H   H  EEEEE  L      L       OOO    !!  
  H   H  E      L      L      O   O   !!  
  HHHHH  EEEEE  L      L      O   O   !!  
  H   H  E      L      L      O   O       
  H   H  EEEEE  LLLLL  LLLLL   OOO    !!  
  
  Main> 

Hello indeed, that completes our run through of this example!


-------------------
Here is the specific character data that we are using; this
particular encoding uses a five by five grid for each character,
but it would be possible to use bigger (or, perhaps, smaller)
grids.  In fact, we could even use different widths for different
charactes, so long as all the strings for a given character have
the same length.

> picChar    :: Char -> [String]
> picChar 'a' = [ "  A  ", " A A ", "AAAAA", "A   A", "A   A" ]
> picChar 'b' = [ "BBBB ", "B   B", "BBBB ", "B   B", "BBBB " ]
> picChar 'c' = [ " CCCC", "C    ", "C    ", "C    ", " CCCC" ]
> picChar 'd' = [ "DDDD ", "D   D", "D   D", "D   D", "DDDD " ]
> picChar 'e' = [ "EEEEE", "E    ", "EEEEE", "E    ", "EEEEE" ]
> picChar 'f' = [ "FFFFF", "F    ", "FFFF ", "F    ", "F    " ]
> picChar 'g' = [ " GGGG", "G    ", "G  GG", "G   G", " GGG " ]
> picChar 'h' = [ "H   H", "H   H", "HHHHH", "H   H", "H   H" ]
> picChar 'i' = [ "IIIII", "  I  ", "  I  ", "  I  ", "IIIII" ]
> picChar 'j' = [ "JJJJJ", "   J ", "   J ", "J  J ", " JJ  " ]
> picChar 'k' = [ "K   K", "K  K ", "KKK  ", "K  K ", "K   K" ]
> picChar 'l' = [ "L    ", "L    ", "L    ", "L    ", "LLLLL" ]
> picChar 'm' = [ "M   M", "MM MM", "M M M", "M   M", "M   M" ]
> picChar 'n' = [ "N   N", "NN  N", "N N N", "N  NN", "N   N" ]
> picChar 'o' = [ " OOO ", "O   O", "O   O", "O   O", " OOO " ]
> picChar 'p' = [ "PPPP ", "P   P", "PPPP ", "P    ", "P    " ]
> picChar 'q' = [ " QQQ ", "Q   Q", "Q   Q", "Q  Q ", " QQ Q" ]
> picChar 'r' = [ "RRRR ", "R   R", "RRR  ", "R  R ", "R   R" ]
> picChar 's' = [ " SSSS", "S    ", " SSS ", "    S", "SSSS " ]
> picChar 't' = [ "TTTTT", "  T  ", "  T  ", "  T  ", "  T  " ]
> picChar 'u' = [ "U   U", "U   U", "U   U", "U   U", " UUU " ]
> picChar 'v' = [ "V   V", "V   V", "V   V", " V V ", "  V  " ]
> picChar 'w' = [ "W   W", "W   W", "W W W", "WW WW", "W   W" ]
> picChar 'x' = [ "X   X", " X X ", "  X  ", " X X ", "X   X" ]
> picChar 'y' = [ "Y   Y", " Y Y ", "  Y  ", "  Y  ", "  Y  " ]
> picChar 'z' = [ "ZZZZZ", "   Z ", "  Z  ", " Z   ", "ZZZZZ" ]
> picChar '.' = [ "     ", "     ", "     ", " ..  ", " ..  " ]
> picChar ',' = [ "     ", "     ", "     ", " ,,  ", "  ,  " ]
> picChar '!' = [ " !!  ", " !!  ", " !!  ", "     ", " !!  " ]
> picChar ' ' = [ "     ", "     ", "     ", "     ", "     " ]
> picChar '?' = [ " ??? ", "?   ?", "   ? ", "  ?  ", "  .  " ]
> picChar '(' = [ "   ( ", "  (  ", "  (  ", "  (  ", "   ( " ]
> picChar ')' = [ " )   ", "  )  ", "  )  ", "  )  ", " )   " ]
> picChar ':' = [ "     ", "  :: ", "     ", "  :: ", "     " ]
> picChar '-' = [ "     ", "     ", "-----", "     ", "     " ]
> picChar c
>  |isUpper c = picChar (toLower c)
> picChar c   = picChar '?'

Making bigger banners:

> bigSay  :: String -> String
> bigSay   = concat . map say . lines . say

Making crazy large banners:

> hugeSay :: String -> String
> hugeSay  = concat . map say . lines . bigSay

> sayHuge :: String -> String
> sayHuge  = concat . map bigSay . lines . say

Do you think that hugeSay and sayHuge are the same?
Do you think that you could prove they are the same?

Making multiple line banners:

> sayMulti :: [String] -> String
> sayMulti  = concat . map say 

