Contributing to Blossom
==========================
Blossom has a very lenient policy towards PRs, but would prefer that you try and adhere to the following guidelines.

## Source code
You must first build the project to get the source code for Blossom. 

There are steps located in `README.md` on how to do this.

## Understanding Patches
Patches to Blossom are very simple, but centres around the directories 'Blossom-API' and 'Blossom-Server'

Assuming you already have forked the repository:

1. Pull the latest changes from the main repository
2. Type `./applyPatches.sh` in git bash to apply the changes from upstream
3. cd into `Blossom-Server` for server changes, and `Blossom-API` for api changes

These directories aren't git repositories in the traditional sense:

- Every single commit in Blossom-Server/API is a patch. 
- 'origin/master' points to a directory similar to Blossom-Server/API but for TacoSpigot
- Typing `git status` should show that we are 10 or 11 commits ahead of master, meaning we have 10 or 11 patches that upstream doesn't

## Adding Patches
Adding patches to Blossom is very simple:

1) Modify `Blossom-Server` and/or `Blossom-API` with the appropriate changes
2) Type `git add .` to add your changes
3) Run `git commit` with the desired patch message
4) Run `./rebuildPatches.sh` in the main directory to convert your commit into a new patch

Your commit will be converted into a patch

## Modifying Patches
Modifying previous patches is a bit more complex:

1) If you have changes you are working on type `git stash` to store them for later
  - Later you can type `git stash pop` to get them back
2) Type `git rebase -i`
  - It should show something like [this](http://hastebin.com/toxohutocu.hs)
3) Replace `pick` with `edit` for the commit/patch you want to modify, and "save" the changes
  - Only do this for one commit until you get more advanced and understand what `git rebase -i` does
4) Make the changes you want to make to the patch
5) Type `git add .` to add your changes
6) Type `git commit --amend` to commit
  - **MAKE SURE TO ADD `--amend`** or else a new patch will be created
  - You can also modify the commit message here
7) Type `git rebase --continue` to finish rebasing
8) Type `./rebuildPatches.sh` in the main directory
  - This will modify the appropriate patches based on your commits

## PR Policy
We'll accept changes that make sense. You should be able to justify their existence, along with any maintenance costs that come with them. 

Remember, these changes will affect everyone who runs Blossom, not just you and your server.

While we will fix minor formatting issues, you should stick to the guide below when making and submitting changes.


## Formatting
All modifications to non-Blossom files should be marked
- Multi line changes start with `// Blossom start` and end with `// Blossom end`
- You can put a messages with a change if it isn't obvious, like this: `// Blossom start - reason
  - Should generaly be about the reason the change was made, what it was before, or what the change is
  - Multi-line messages should start with `// Blossom start` and use `/* Multi line message here */` for the message itself
- Single line changes should have `// Blossom` or `// Blossom - reason`
- For example:
````java
entity.getWorld().dontbeStupid(); // Blossom - was beStupid() which is bad
entity.getFriends().forEach(Entity::explode());
entity.a();
entity.b();
// Blossom start - use plugin-set spawn
// entity.getWorld().explode(entity.getWorld().getSpawn());
Location spawnLocation = ((CraftWorld)entity.getWorld()).getSpawnLocation();
entity.getWorld().explode(new BlockPosition(spawnLocation.getX(), spawnLocation.getY(), spawnLocation.getZ()));
// Blossom end
````
- We generally follow usual java style, or what is programmed into most IDEs and formatters by default
  - This is also known as oracle style
  - It is fine to go over 80 lines as long as it doesn't hurt readability
