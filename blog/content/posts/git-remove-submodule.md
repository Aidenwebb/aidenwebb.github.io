---
title: "Git Remove Submodule"
date: 2022-07-26T09:51:58+01:00
draft: false
tags: ["Git", "Troubleshooting"]
---

Submodules aren't removed using ```git rm submodule-dir```, they need to be removed in a far more thorough and annoying fashion.
There are a number of unclear explainations at various sources so I decided to write my own findings.

1. Delete the relevant parts from the ```.gitmodules``` file.
EG:
```
[submodule "blog/themes/PaperMod"]
	path = blog/themes/PaperMod
	url = https://github.com/adityatelange/hugo-PaperMod.git
```

2. Stage .gitmodules via ```git add .gitmodules```
3. Remove the relevant parts from ```.git/config```
EG:
```
[submodule "blog/themes/PaperMod"]
	url = https://github.com/adityatelange/hugo-PaperMod.git
```

4. Clear the cache with ```git rm --cached /path/to/submodule``` - with no trailing slash. Including the trailing slash will throw an error
5. Remove the .git modules submodule data by running ```rm -rf .git/modules/submodule_name``` or ```rm -rf .git/modules/submodulefoldername```
6. Commit the changes
7. Delete the submodule files ```rm -rf path/to/submodule```