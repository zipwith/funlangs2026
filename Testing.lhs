-------------------------------------------------------------------
This file contains examples to demonstrate tools and techniques for
advanced testing in Haskell development.

To load in ghci:  ghci -package QuickCheck Testing.lhs
To load in Hugs:  hugs Testing.lhs

> module Testing where

> import Test.QuickCheck

Binary Arithmetic Examples ----------------------------------------

> newtype BinNum = BN [Bit]
> data Bit       = O | I deriving (Eq, Ord, Show)

> instance Arbitrary BinNum where
>   arbitrary = fmap BN arbitrary

> instance Arbitrary Bit where
>   arbitrary = oneof [return O, return I]

> posInteger :: Gen Integer
> posInteger  = do n <- arbitrary
>                  return (if n<0 then (-2*n)
>                                 else (2*n+1))

Conversion --------------------------------------------------------

> toBinNum   :: Integer -> BinNum 
> toBinNum 0  = BN [O]
> toBinNum n  = BN
>             $ map (\n -> if n then O else I) -- calculate individual bits
>             $ map even                       -- test for odd/even number
>             $ takeWhile (0/=)                -- stop once we get to zero
>             $ iterate (`div` 2) n            -- repeated division by two

> fromBinNum        :: BinNum -> Integer
> fromBinNum (BN ds) = foldr cons 0 ds
>  where cons O n = 2 * n
>        cons I n = 2 * n + 1

> prop_Convert n = n>=0 ==> fromBinNum (toBinNum n) == n

Increment ---------------------------------------------------------

> inc        :: BinNum -> BinNum
> inc (BN ds) = BN (inc' ds)

> inc'       :: [Bit] -> [Bit]
> inc' (O:xs) = I : xs
> inc' (I:xs) = O : inc' xs
> inc' []     = [I]

> prop_Inc n  = n>=0 ==> (inc . toBinNum) n == (toBinNum . (1+)) n

> prop_Inc2 n
>    = collect (signum n)
>       (n<0 ||
>        (inc . toBinNum) n == (toBinNum . (1+)) n)

> prop_Inc3 n
>     = classify (n>0) "positive"
>     $ classify (n<0) "negative"
>     $ (n<0 ||
>        (inc . toBinNum) n == (toBinNum . (1+)) n)

> prop_Inc4 = forAll posInteger (\n ->
>               classify (n>=0) "positive" $
>               inc (toBinNum n) == toBinNum (1+n))

Addition ----------------------------------------------------------

> add                :: BinNum -> BinNum -> BinNum
> add (BN xs) (BN ys) = BN (add' xs ys)

> add'               :: [Bit] -> [Bit] -> [Bit]
> add' (O:xs) (O:ys)  = O : add' xs ys
> add' (I:xs) (O:ys)  = I : add' xs ys
> add' (O:xs) (I:ys)  = I : add' xs ys
> add' (I:xs) (I:ys)  = O : addc xs ys
> add' []     ys      = ys
> add' xs     []      = xs

> addc               :: [Bit] -> [Bit] -> [Bit]
> addc (O:xs) (O:ys)  = I : add' xs ys
> addc (I:xs) (O:ys)  = O : addc xs ys
> addc (O:xs) (I:ys)  = O : addc xs ys
> addc (I:xs) (I:ys)  = I : addc xs ys
> addc []     ys      = inc' ys
> addc xs     []      = inc' xs

> prop_IncAndAdd bn   =  inc bn == add (BN [I]) bn

> prop_Add = forAll posInteger $ \n ->
>            forAll posInteger $ \m ->
>              -- collect (n+m) $
>              add (toBinNum n) (toBinNum m)
>              == toBinNum (n+m)

Multiplication ----------------------------------------------------

> mul :: BinNum -> BinNum -> BinNum
> mul (BN ns) (BN ms)
>   = BN (foldr add' [] (zipWith bmul ms (iterate (O:) ns)))
>     where bmul O ds = []
>           bmul I ds = ds

> prop_Mul = forAll posInteger $ \n ->
>            forAll posInteger $ \m ->
>              -- collect (m*n) $
>              mul (toBinNum n) (toBinNum m)
>              == toBinNum (n*m)

Useful Class Instances --------------------------------------------

> instance Eq BinNum where
>   BN xs == BN ys  = eq xs ys
>    where eq              :: [Bit] -> [Bit] -> Bool
>          eq (O:xs) (O:ys) = eq xs ys
>          eq (I:xs) (I:ys) = eq xs ys
>          eq []     ys     = all (O==) ys
>          eq xs     []     = all (O==) xs
>          eq xs     ys     = False

> instance Ord BinNum where
>   compare (BN xs) (BN ys) = comp xs ys
>    where comp []     ys     = if all (O==) ys then EQ else LT
>          comp xs     []     = if all (O==) xs then EQ else GT
>          comp (x:xs) (y:ys) = case comp xs ys of
>                                 EQ -> compare x y
>                                 r  -> r

> instance Show BinNum where
>   showsPrec _ (BN ds)
>     = foldl (\a d -> showsBit d . a) (showChar 'b') ds
>       where showsBit O = showChar '0'
>             showsBit I = showChar '1'

Trees ----------------------------------------------------------------

> data Tree = Leaf Int | Branch Tree Tree
>             deriving (Eq, Show)

> instance Arbitrary Tree where
>   arbitrary
>     = do b <- arbitrary
>          if b then do x <- arbitrary
>                       return (Leaf x)
>               else do l <- arbitrary
>                       r <- arbitrary
>                       return (Branch l r)

> size                :: Tree -> Int
> size (Leaf n)        = 1
> size (Branch l r)    = 1 + size l + size r

> reflect             :: Tree -> Tree
> reflect (Leaf n)     = Leaf n
> reflect (Branch l r) = Branch (reflect r) (reflect l)

> prop_reflect t = collect (size t)
>                $ reflect (reflect t) == t

----------------------------------------------------------------------
