module Pipes.Lift.Either where

import Pipes (Proxy, MFunctor, hoist, lift)
import Pipes.Lift (distribute)
import Pipes.Internal (unsafeHoist)
import Control.Monad.Trans.Either (EitherT(..), runEitherT)

instance MFunctor (EitherT e) where
    hoist nat m = EitherT (nat (runEitherT m))

eitherP :: Monad m => Proxy a' a b' b m (Either e r) -> Proxy a' a b' b (EitherT e m) r
eitherP p = do
    x <- unsafeHoist lift p
    lift $ EitherT (return x)
{-# INLINABLE eitherP #-}

runEitherP :: Monad m => Proxy a' a b' b (EitherT e m) r -> Proxy a' a b' b m (Either e r)
runEitherP = runEitherT . distribute
{-# INLINABLE runEitherP #-}
