#!usr/bin/bash
# VX2Ace.sh
#
function cleanup 
{
  echo performing cleanup ;
}

function vx2hash
{
  ruby ./nix-main.rb -v
}

function hash2ace
{
  ruby ./nix-main.rb -a
}

cleanup();
vx2hash();
hash2ace();
