.RECIPEPREFIX := |

init:
|-git clone --recurse-submodule https://github.com/shadowrylander/shadowrylander ~/shadowrylander/home/shadowrylander
.DEFAULT_GOAL := init

rebuild:
|chmod +x ./wheee
|./wheee --use-hash ${HASH} -H make

switch:
|chmod +x ./wheee
|./wheee --use-hash ${HMASH} -H make --home-manager
|./wheee --use-hash ${RMASH} -H make --home-manager

doom-set:
|rsync -avvczz --delete ~/shadowrylander/home/.doom.d/ ~/.doom.d/
|chmod +x ~/.doom.d/org-tangle
|~/.doom.d/org-tangle ~/shadowrylander/doom.aiern.org
|rsync -avvczz --delete ~/shadowrylander/home/.doom.d/ ~/.doom.d/

doom-sync:
|~/.emacs.d/bin/doom sync

doom-check:
|-~/.emacs.d/bin/doom doctor

doom-test:
|emacs ~/shadowrylander/doom.aiern.org

doom: doom-set doom-sync doom-check doom-test

doom-upgrade:
|printf "n\ny\n" | ~/.emacs.d/bin/doom upgrade

doom-super: doom-set doom-sync doom-check doom-upgrade doom-sync doom-check doom-test

tangle-all: doom-set
# Adapted From:
# Answer: https://askubuntu.com/a/338860/1058868
# User: https://askubuntu.com/users/1366/lesmana
# From:
# Answer: https://askubuntu.com/a/446480/1058868
# User: https://askubuntu.com/users/267867/peter-w-osel
|yes yes | ~/.doom.d/org-tangle ~/shadowrylander/*.aiern.org
|yes yes | ~/.doom.d/org-tangle ~/shadowrylander/README.org

push:
|git -C ~/shadowrylander add .
|git -C ~/shadowrylander commit --allow-empty-message -am ""
|git -C ~/shadowrylander push
