#!/usr/bin/env bash
set -e

RED="0;31m"
GREEN="0;33m"

function _setup {
    # setup file to store bookmarks
    if [ ! -n "$SDIRS" ]; then
        SDIRS=~/.sdirs
    fi
    touch $SDIRS
}

function _l {
    source $SDIRS
    env | grep "^DIR_" | cut -c5- | sort | grep "^.*=" | cut -f1 -d "=" 
}

# completion command
function _comp {
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '`_l`' -- $curw))
    return 0
}

# ZSH completion command
function _compzsh {
    reply=($(_l))
}


function _custom_comp {
    # bind completion command for g,p,d to _comp
    if [ $ZSH_VERSION ]; then
        compctl -K _compzsh g
        compctl -K _compzsh p
        compctl -K _compzsh d
    else
        shopt -s progcomp
        complete -F _comp jump
        complete -F _comp print
        complete -F _comp delete
    fi
}


# validate bookmark name
function _bookmark_name_valid {
    exit_message=""
    if [ -z $1 ]; then
        exit_message="bookmark name required"
        echo $exit_message
    elif [ "$1" != "$(echo $1 | sed 's/[^A-Za-z0-9_]//g')" ]; then
        exit_message="bookmark name is not valid"
        echo $exit_message
    fi
}

# safe delete line from sdirs
function _purge_line {
    if [ -s "$1" ]; then
        # safely create a temp file
        t=$(mktemp -t bashmarks.XXXXXX) || exit 1
        trap "rm -f -- '$t'" EXIT

        # purge line
        sed "/$2/d" "$1" > "$t"
        mv "$t" "$1"

        # cleanup temp file
        rm -f -- "$t"
        trap - EXIT
    fi
}
