> import Treedot

-- Let's define a tree datatype: ------------------------------

> data Expr = Add Expr Expr   -- addition
>           | Sub Expr Expr   -- subtraction
>           | Div Expr Expr   -- division of one expressions
>           | Mul Expr Expr   -- multiplication
>           | Val Integer     -- a single integer constant
>             deriving Show

Here are some simple examples to illustrate:

> onePlusTwo = Add (Val 1) (Val 2)        -- Represents (1+2)
> twoPlusOne = Add (Val 2) (Val 1)        -- Represents (2+1)
> oneTimes3  = Mul (Val 1) (Val 3)        -- Represents (1*3)
> fourTimes7 = Mul (Val 4) (Val 7)        -- Represents (4*7)
> onePlus2Plus3
>    = Add (Val 1) (Add (Val 2) (Val 3))  -- Represents 1 + (2 + 3)
> bigger     = Sub onePlusTwo twoPlusOne  -- Represents (1 + 2) - (2 + 1)

-- Now let's show that it has tree properties: ----------------

> instance Tree Expr where
>   subtrees (Add l r) = [l, r]
>   subtrees (Sub l r) = [l, r]
>   subtrees (Div l r) = [l, r]
>   subtrees (Mul l r) = [l, r]
>   subtrees (Val n)   = []

> instance LabeledTree Expr where
>   label (Add l r) = "+"
>   label (Sub l r) = "-"
>   label (Div l r) = "/"
>   label (Mul l r) = "*"
>   label (Val n)   = show n

-- And now we can use that to generate some output: -----------

> sample = writeFile "sample.dot" (toDot ex)
> ex     = (Add onePlus2Plus3
>                        (Mul bigger onePlus2Plus3))

---------------------------------------------------------------
