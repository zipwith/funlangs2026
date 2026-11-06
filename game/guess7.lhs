This version adds some type signatures to each of the
functions that we use.  Under normal circumstances, I
would have written these during program development.
But they are still potentially useful now as program
documentation.

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

Instead of passing multiple parameters around to capture
the current secret and number of lives, we'll package these
together in a "game state" value.  This will also give us
more flexibility if we want to add additional game details
at a later point, such as adding a player name, etc.

> data Game = Game {
>               secret :: Int,
>               lives  :: Int
>             }

Here is the entry point to our program.  It welcomes the
player, picks a secret number and then starts the main
loop in which the player tries to guess what number was
picked.

> play :: IO ()
> play
>   = do putStrLn "Welcome to Guess-The-Number"
>        r <- randomRIO (lo, hi)
>        putStrLn ("I'm thinking of a number between "
>                  ++ show lo ++ " and " ++ show hi)
>        check Game{secret=r, lives=7}

We introduce a new function for checking that the player
still has some lives left.  If they do, then we take one
of those lives away as "payment" for entering a new guess.
If all the lives have been used, then it's game over, but
we will at least tell the player what the secret was:

> check :: Game -> IO ()
> check game
>   = if lives game > 0 then
>       do putStrLn ("\nYou have " ++ show (lives game)
>                    ++ " lives left")
>          ask game{lives = lives game - 1}
>      else
>       do putStrLn "Sorry, that was your last guess"
>          putStrLn ("The secret was " ++ show (secret game))

We can use the following function to ask our player to enter
a guess.  If the text they enter is not valid, then we just
loop and ask them again:

> ask :: Game -> IO ()
> ask game
>   = do putStr "Please enter your guess:  "
>        s <- getLine
>        case atoi s of
>          Just guess ->
>            if guess==457 || guess==557
>              then do putStrLn ("Ssh, the secret is "
>                                ++ show (secret game))
>                      ask game
>              else respond game guess
>          Nothing    -> do putStrLn "Please enter a number"
>                           ask game

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

> respond :: Game -> Int -> IO ()
> respond game guess
>   | guess == s = putStrLn "Yes, you got it!"
>   | guess <  s = do putStrLn "Sorry, too low"
>                     check game
>   | guess >  s = do putStrLn "Sorry, too high"
>                     check game
>     where s = secret game
