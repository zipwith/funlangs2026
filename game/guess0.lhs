Here is a program that responds when we attempt
to guess the value of a secret number:

> respond secret guess
>   | guess == secret = putStrLn "Yes, you got it!"
>   | guess <  secret = putStrLn "Sorry, too low"
>   | guess >  secret = putStrLn "Sorry, too high"

