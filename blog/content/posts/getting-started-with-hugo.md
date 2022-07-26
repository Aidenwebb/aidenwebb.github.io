---
title: "Getting started with Hugo"
date: 2022-07-25T22:01:11+01:00
draft: false
---

I recently came to the conclusion that I wasn't posting on my blog nearly as much as I'd like to. My blog runs on wordpress, and I've felt for a while that the process of logging in, creating a post, fixing formatting in a WSYWGI editor and eventually posting was too much resistance when I commonly just write notes in plain text. So, why not just write posts in plain text and have something else do the work of turning that in to a post?

In comes [Hugo](https://gohugo.io/), a static site generator written in Go.

First off, I used Chocolatey to install Hugo:
```
choco install hugo
```

I liked the look of the [PaperMod](https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-installation/) theme, simple yet effective. I initially installed using Method 1 - cloning the PaperMod theme directly in to my own code. This caused a bit of faff with git however so I scrapped that and installed via Method 2 - pulling PaperMod in as a submodule.

```
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
git submodule update --init --recursive # needed when you reclone your repo (submodules may not get cloned automatically)
```

I spent a bit of time tinkering with the config and a test Lipsum post (which I then updated to this post).

I'm not yet ready to scrap my existing Wordpress install, I want to get more familiar with the workings of Hugo first, integrate comments, search etc. So I decided to host Hugo off of Github Pages as an intermediary step. Github Pages doesn't support Hugo out of the box though. However, Github Pages does support just serving raw static HTML/CSS/JS so if we create a [separate repository](https://github.com/Aidenwebb/aidenwebb.github.io) and import this as a submodule in the /public/ folder that Hugo uses to publish, we should be able to publish the generated static site directly in to the GitHub Pages repository

It's worth noting you cannot clone an empty repository - you must commit something to the repo before cloning it. I committed a quick readme.md.

```
git submodule add -b main https://github.com/Aidenwebb/aidenwebb.github.io.git public
```

After generating the site with ```hugo -t PaperMod```:
Navigate to your public directory and run:
```
cd public
git add .
git commit -m "init commit"
git push origin main
```
and the submodule remote repo will be updated, and built by Github Pages.

When hosting on Github pages, something breaks the integrity of CSS files, so I've opted to disable fingerprinting ([`config.yml:params:assets:disablefingerprinting:true`](https://github.com/Aidenwebb/aidenwebb-com-blog-code/blob/main/blog/config.yml)) for the time being with the intention of investigating further another time.


