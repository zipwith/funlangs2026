> import Data.Char (isDigit)

We can use the following function to ask our player to enter
a guess.  If the text they enter is not valid, then we just
loop and ask them again:

> ask secret
>   = do putStr "Please enter your guess:  "
>        s <- getLine
>        case atoi s of
>          Just guess -> respond secret guess
>          Nothing    -> do putStrLn "Please enter a number"
>                           ask secret

This function converts a string into an integer, but checks
first to make sure the conversion (which uses the builtin
read function) will be successful:

> atoi :: String -> Maybe Int
> atoi s | not (null s) && all isDigit s = Just (read s)
>        | otherwise                     = Nothing

Here is a function that responds when we attempt
to guess the value of a secret number:

> respond secret guess
>   | guess == secret = putStrLn "Yes, you got it!"
>   | guess <  secret = putStrLn "Sorry, too low"
>   | guess >  secret = putStrLn "Sorry, too high"

