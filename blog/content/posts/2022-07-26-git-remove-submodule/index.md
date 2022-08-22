---
title: "Git Remove Submodule"
date: 2022-07-26T09:51:58+01:00
#url: ./git-remove-submodule/
draft: false
tags: ["Git", "Troubleshooting", "IT & Tech"]
cover:
    image: "cover.jpg" # image path/url
    alt: "Groot and Octocat reading a newspaper" # alt text
    caption: "<text>" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---

Submodules aren't removed using `git rm submodule-dir`, they need to be removed in a far more thorough and annoying fashion.
There are a number of unclear explanations at various sources so I decided to write my own findings.

1. Delete the relevant parts from the `.gitmodules` file.

    EG:

    ```text
    [submodule "blog/themes/PaperMod"]
        path = blog/themes/PaperMod
        url = https://github.com/adityatelange/hugo-PaperMod.git
    ```

2. Stage .gitmodules via `git add .gitmodules`
3. Remove the relevant parts from `.git/config`

    EG:

    ```text
    [submodule "blog/themes/PaperMod"]
        url = https://github.com/adityatelange/hugo-PaperMod.git
    ```

4. Clear the cache with `git rm --cached /path/to/submodule` - with no trailing slash. Including the trailing slash will throw an error
5. Remove the .git modules submodule data by running `rm -rf .git/modules/submodule_name` or `rm -rf .git/modules/submodulefoldername`
6. Commit the changes
7. Delete the submodule files `rm -rf path/to/submodule`
