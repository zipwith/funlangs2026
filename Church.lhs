----------------------------------------------------------------------

> import Prelude hiding (succ)

The "Church numeral" for a natural number n is the function that takes
an argument f and returns the composition of f with itself a total of
n times.

  (church_numeral_of_0) f = id
  (church_numeral_of_1) f = f
  (church_numeral_of_2) f = f . f
  (church_numeral_of_3) f = f . f . f
  (church_numeral_of_4) f = f . f . f . f

We can think of Church numerals as having values of the following
type:

> type Church a = (a -> a) -> a -> a

For example, the church numerals for zero and one are just:

> zero, one  :: Church a
> zero        = \f z -> z
> one         = \f z -> f z

Given an arbitrary church numeral, we can construct a corresponding
Int value by applying the (1+) function the appropriate number of
times to 0:

> c2i        :: Church Int -> Int
> c2i n       = n (1+) 0

Given a Church numeral for n, the successor (i.e., 1 + n) is just
the function that takes an argument f and applies it (n+1) times.

> succ       :: Church a -> Church a
> succ n      = \f z -> n f (f z)

For example, we can define:

> two, three :: Church a
> two         = succ one
> three       = succ two

Addition can be described by repeated use of the successor:

> add        :: Church (Church a) -> Church a -> Church a
> add n m     = n succ m

Multiplication can be described by repeated use of addition:

> mul        :: Church (Church a) -> Church (Church a) -> Church a
> mul n m     = n (add m) zero

And exponentiation can be described by repeated multiplication:

> --pow      :: Church ? -> Church ? -> Church ?
> pow n m     = m (mul n) one

You might have noticed that the type of add is a little complicated,
the type for mul is worse, and there is actually no way to give a type
for pow that works in standard Haskell.  (Try evaluating pow two
three, for example.)  To push further with Church numerals in a typed
language, we really need a feature that allows us to define:

  type Church  =  forall a. (a -> a) -> a -> a

and then to pass Church numerals of this form around as polymorphic
values.  This can be done using the extension to "higher-ranked
types" in GHC and Hugs, but doing that is beyond the scope of this
course.

----------------------------------------------------------------------
