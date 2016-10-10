#!/bin/zsh

readonly REPOS=$(ls ~/repos)

function printProject {
  local NAME=$1
  local DIR=~/repos/${1}
  local IS_REPO=$DIR/.git
  if [[ -d ${DIR} && -d ${IS_REPO} ]]; then
    local PROJECT=$(cd ${DIR} && git remote -v | head -n 1 | awk -F'/' '{print $4}');
    echo "Moving ${NAME} into ${PROJECT} -> ~/repos/${PROJECT}/${NAME}";
    mkdir -p ~/repos/${PROJECT};
    mv ${DIR} ~/repos/${PROJECT};
  fi
}

for dir in ${REPOS}; do
  printProject ${dir}
done
