Now we're extending the game to limit the number of
guesses that players are allowed to make.

> import Data.Char (isDigit)

We're adding the System.Random library, which provides
functions for generating random numbers.  (Of course,
this requires an IO action because you can't get a random
number from a pure function that always returns the same
result.)

> import System.Random

We're going to ask the player to pick a number between
some given lo and hi values.  We'll capture those
numbers here to avoid hard-wiring "magic" numbers in to
our code:

> lo, hi :: Int
> lo      = 1
> hi      = 100

Here is the entry point to our program.  It welcomes the
player, picks a secret number and then starts the main
loop in which the player tries to guess what number was
picked.

> play
>   = do putStrLn "Welcome to Guess-The-Number"
>        secret <- randomRIO (lo, hi)
>        putStrLn ("I'm thinking of a number between " ++ show lo
>                 ++ " and " ++ show hi)
>        check secret 7

We introduce a new function for checking that the player
still has some lives left.  If they do, then we take one
of those lives away as "payment" for entering a new guess.
If all the lives have been used, then it's game over, but
we will at least tell the player what the secret was:

> check secret lives
>   = if lives > 0 then
>       do putStrLn ("\nYou have " ++ show lives ++ " lives left")
>          ask secret (lives - 1)
>      else
>       do putStrLn "Sorry, that was your last guess"
>          putStrLn ("The secret was " ++ show secret)

We can use the following function to ask our player to enter
a guess.  If the text they enter is not valid, then we just
loop and ask them again:

> ask secret lives
>   = do putStr "Please enter your guess:  "
>        s <- getLine
>        case atoi s of
>          Just guess -> respond secret lives guess
>          Nothing    -> do putStrLn "Please enter a number"
>                           ask secret lives

This function converts a string into an integer, but checks
first to make sure the conversion (which uses the builtin
read function) will be successful:

> atoi :: String -> Maybe Int
> atoi s | not (null s) && all isDigit s = Just (read s)
>        | otherwise                     = Nothing

Here is a function that responds when we attempt
to guess the value of a secret number.  Now this code
has been modified so that it loops back to ask the
player for another guess if their answer was not
correct.

> respond secret lives guess
>   | guess == secret = putStrLn "Yes, you got it!"
>   | guess <  secret = do putStrLn "Sorry, too low"
>                          check secret lives
>   | guess >  secret = do putStrLn "Sorry, too high"
>                          check secret lives

