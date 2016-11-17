{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax #-}

module Course.FileIO where

import Course.Core
import Course.Applicative
import Course.Monad
import Course.Functor
import Course.List

{-

Useful Functions --

  getArgs :: IO (List Chars)
  putStrLn :: Chars -> IO ()
  readFile :: Chars -> IO Chars
  lines :: Chars -> List Chars
  void :: IO a -> IO ()

Abstractions --
  Applicative, Monad:

    <$>, <*>, >>=, =<<, pure

Problem --
  Given a single argument of a file name, read that file,
  each line of that file contains the name of another file,
  read the referenced file and print out its name and contents.

Example --
Given file files.txt, containing:
  a.txt
  b.txt
  c.txt

And a.txt, containing:
  the contents of a

And b.txt, containing:
  the contents of b

And c.txt, containing:
  the contents of c

To test this module, load ghci in the root of the project directory, and do
    >> :main "share/files.txt"

Example output:

$ ghci
GHCi, version ... 
Loading package...
Loading ...
[ 1 of 28] Compiling (etc...
...
Ok, modules loaded: Course, etc...
>> :main "share/files.txt"
============ share/a.txt
the contents of a

============ share/b.txt
the contents of b

============ share/c.txt
the contents of c

-}

-- /Tip:/ use @getArgs@ and @run@
main ::
  IO ()
main =
  do a <- getArgs
     case a of
       x:._ -> run x
       _ -> putStrLn "please pass an argument"
--void ( run <$> (readFile <$> getArgs))

type FilePath =
  Chars

-- /Tip:/ Use @getFiles@ and @printFiles@.
run ::
  Chars
  -> IO ()
run input =
  readFile input >>= \r ->
  getFiles (lines r) >>= \s ->
  printFiles s
--  void (printFiles <$> (getFiles (lines input))) -- This will compile but isn't correct

getFiles ::
  List FilePath
  -> IO (List (FilePath, Chars))
getFiles filenames =
  sequence (getFile <$> filenames)

getFile ::
  FilePath
  -> IO (FilePath, Chars)
getFile filename = 
--  do
--    c <- readFile filename
--    pure (filename,c)
  (\c -> (filename,c)) <$> (readFile filename)
--getFile =  lift2 (<$>) (,) readFile

printFiles ::
  List (FilePath, Chars)
  -> IO ()
printFiles files =
--  void (sequence ((uncurry printFile) <$> files))
  (void . sequence) ((uncurry printFile) <$> files)
--  (void . sequence) ((<$>) (uncurry printFile) files)
--printFiles = (void . sequence) . ((<$>) (uncurry printFile))

printFile ::
  FilePath
  -> Chars
  -> IO ()
printFile filename contents =
  putStrLn ("=======" ++ filename) *> putStrLn contents
--  (\_ -> putStrLn contents) =<< putStrLn ("======" ++ filename)
--  do
--    putStrLn ((listh "=============") ++ filename)
--    putStrLn contents

