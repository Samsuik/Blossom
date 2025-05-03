#!/bin/bash

PS1="$"
basedir=`pwd`
workdir=$basedir/work
gpgsign=$(git config commit.gpgsign)
echo "Rebuilding Forked projects.... "

function applyPatch {
    what=$1
    target=$2
    patches=$3
    branch=$4
    cd "$what"
    git fetch
    git branch -f upstream "$branch" >/dev/null

    cd "$basedir"
    if [ ! -d  "$target" ]; then
        git clone "$what" "$target"
    fi
    cd "$target"
    echo "Resetting $target to $what..."
    git remote add -f upstream "$what" >/dev/null 2>&1
    git checkout master >/dev/null 2>&1
    git fetch upstream >/dev/null 2>&1
    git reset --hard upstream/upstream

    echo "  Applying patches to $target..."
    if [ "$(ls -A "$patches")" ]; then
        git am --abort >/dev/null 2>&1
        git am --3way --ignore-whitespace "$patches/"*.patch
    else
        echo "  Could not find any patches to apply to $target."
    fi

    if [ "$?" != "0" ]; then
        echo "  Something did not apply cleanly to $target."
        echo "  Please review above details and finish the apply then"
        echo "  save the changes with rebuildPatches.sh"
        enableCommitSigningIfNeeded
        exit 1
    else
        echo "  Patches applied cleanly to $target"
    fi
}

function enableCommitSigningIfNeeded {
    if [[ "$gpgsign" == "true" ]]; then
        echo "Re-enabling GPG Signing"
        # Yes, this has to be global
        git config --global commit.gpgsign true
    fi
}

# Disable GPG signing before AM, slows things down and doesn't play nicely.
# There is also zero rational or logical reason to do so for these sub-repo AMs.
# Calm down kids, it's re-enabled (if needed) immediately after, pass or fail.
if [[ "$gpgsign" == "true" ]]; then
    echo "_Temporarily_ disabling GPG signing"
    git config --global commit.gpgsign false
fi

#if [ ! -d "$workdir/Backported-Server" ]; then
    # bukkit -> spigot
    applyPatch "$workdir"/Bukkit "$workdir"/Spigot-API "$workdir"/Bukkit-Patches HEAD
    applyPatch "$workdir"/CraftBukkit "$workdir"/Spigot-Server "$workdir"/CraftBukkit-Patches patched

    # spigot -> paper
    applyPatch "$workdir"/Spigot-API "$workdir"/PaperSpigot-API "$workdir"/Spigot-API-Patches HEAD
    applyPatch "$workdir"/Spigot-Server "$workdir"/PaperSpigot-Server "$workdir"/Spigot-Server-Patches HEAD

    # paper -> taco
    applyPatch "$workdir"/PaperSpigot-API "$workdir"/TacoSpigot-API "$workdir"/PaperSpigot-API-Patches HEAD
    applyPatch "$workdir"/PaperSpigot-Server "$workdir"/TacoSpigot-Server "$workdir"/PaperSpigot-Server-Patches HEAD

    # taco -> haha paper again but more modern...
    applyPatch "$workdir"/TacoSpigot-API "$workdir"/Backported-API "$workdir"/Backported-API-Patches HEAD
    applyPatch "$workdir"/TacoSpigot-Server "$workdir"/Backported-Server "$workdir"/Backported-Server-Patches HEAD
#fi

# modern paper backport -> blossom
applyPatch "$workdir"/Backported-API "$basedir"/Blossom-API "$basedir"/patches/api HEAD
applyPatch "$workdir"/Backported-Server "$basedir"/Blossom-Server "$basedir"/patches/server HEAD

# ignore
#applyPatch $workdir/TacoSpigot-API $basedir/Blossom-API $workdir/Backported-API-Patches HEAD
#applyPatch $workdir/TacoSpigot-Server $basedir/Blossom-Server $workdir/Backported-Server-Patches HEAD

enableCommitSigningIfNeeded
