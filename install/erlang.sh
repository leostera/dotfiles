#!/bin/sh

rm -rf ~/.kerl
git clone https://github.com/yrashk/kerl ~/.kerl

~/.kerl/kerl update releases

for rel in '18.1 18' '17.5 17' 'R16B03 16'; do
  tmp=(${(s. .)rel});
  release=${tmp[1]};
  build=${tmp[2]};
  echo "Installing Erlang ${release} into ~/.kerl/erlangs/r${build}...";
  echo "This may take a while!";
  ~/.kerl/kerl build ${release} ${build};
  ~/.kerl/kerl install ${build} ~/.kerl/erlangs/r${build};
done

~/.kerl/kerl cleanup

git clone git@github.com:erlang/otp.git ~/repos/otp
pushd ~/repos/otp
  vim +ErlangTags +qall
  sed -i 's@\.\/@'"$HOME"'\/repos\/otp\/.\/@' tags
popd
