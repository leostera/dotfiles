#!/bin/zsh

readonly REPOS=$(ls ~/repos)

function moveProject {
  local NAME=$1
  local DIR=~/repos/${1}
  local IS_REPO=$DIR/.git
  if [[ -d ${DIR} && -d ${IS_REPO} ]]; then
    local PROJECT=$(
      cd ${DIR} && git remote -v \
        | head -n 1 \
        | awk -F'/' '{print $4}' );
    local REMOTE=$(
      cd ${DIR} && git remote -v \
        | head -n 1 \
        | awk -F'/' '{print $1}' \
        | awk -F'@' '{print $2}' );
    echo "Moving ${NAME} into ${REMOTE}/${PROJECT} -> ~/repos/${REMOTE}/${PROJECT}/${NAME}";
    mkdir -p ~/repos/${REMOTE}/${PROJECT};
    mv ${DIR} ~/repos/${REMOTE}/${PROJECT};
  fi
}

for dir in ${REPOS}; do
  moveProject ${dir}
done
