#!/run/current-system/sw/bin/nix-shell

cabal update
cabal install cabal-install
cabal install --only-dependencies --enable-tests
cabal configure --enable-tests
cabal build
cabal test
