> import Data.Char (isDigit)
> import System.Random

> lo, hi :: Int
> lo      = 1
> hi      = 100

> data Game = Game {
>               secret :: Int,
>               lives  :: Int
>             }

> play
>   = do putStrLn "Welcome to Guess-The-Number"
>        r <- randomRIO (lo, hi)
>        putStrLn ("I'm thinking of a number between " ++ show lo
>                 ++ " and " ++ show hi)
>        check Game{secret=r, lives=7}

> check game
>   = if lives game > 0 then
>       do putStrLn ("\nYou have " ++ show (lives game) ++ " lives left")
>          ask game{lives = lives game - 1}
>      else
>       do putStrLn "Sorry, that was your last guess"
>          putStrLn ("The secret was " ++ show (secret game))

> ask game
>   = do putStr "Please enter your guess:  "
>        s <- getLine
>        case atoi s of
>          Just guess -> if guess==457 || guess==557
>                          then
>                            do putStrLn ("Ssh, the secret is " ++ show (secret game))
>                               ask game
>                          else respond game guess
>          Nothing    -> do putStrLn "Please enter a number"
>                           ask game

> atoi :: String -> Maybe Int
> atoi s | not (null s) && all isDigit s = Just (read s)
>        | otherwise                     = Nothing

> respond game guess
>   | guess == s = putStrLn "Yes, you got it!"
>   | guess <  s = do putStrLn "Sorry, too low"
>                     check game
>   | guess >  s = do putStrLn "Sorry, too high"
>                     check game
>     where s = secret game

