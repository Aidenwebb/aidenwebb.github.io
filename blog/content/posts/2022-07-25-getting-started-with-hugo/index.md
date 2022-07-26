---
title: "Moving my blog to Hugo - Getting started with Hugo"
date: 2022-07-25T22:01:11+01:00
#url: /posts/getting-started-with-hugo/
draft: false
tags: ["Hugo", "Static Site Generator", "Projects", "IT & Tech"]
cover:
    image: "cover.svg" # image path/url
    alt: "Picture of an ice cream fallen on the floor" # alt text
    caption: "<text>" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page  
---

## Introduction

I recently came to the conclusion that I wasn't posting on my blog nearly as much as I'd like to. My blog runs on WordPress, and I've felt for a while that the process of logging in, creating a post, fixing formatting in a WSYWGI editor and eventually posting was too much resistance when I commonly just write notes in plain text. So, why not just write posts in plain text and have something else do the work of turning that in to a post or a blog?

In comes [Hugo](https://gohugo.io/), a static site generator written in Go.

## Getting Started

### Installing Hugo

First off, I used Chocolatey to install Hugo:

```bash
choco install hugo
```

### Adding a theme

I liked the look of the [PaperMod](https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-installation/) theme, simple yet effective. I initially installed using Method 1 - cloning the PaperMod theme directly in to my own code. This caused a bit of faff with git that I didn't want to troubleshoot so I scrapped that and installed via Method 2 - pulling PaperMod in as a submodule.

```bash
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
git submodule update --init --recursive # needed when you reclone your repo (submodules may not get cloned automatically)
```

I then spent a bit of time tinkering with the config and a test Lipsum post (which I then updated to this post).

I'm not yet ready to scrap my existing WordPress install, I want to get more familiar with the workings of Hugo first, integrate comments, search etc. So I decided to host Hugo off of GitHub Pages as an intermediary step. GitHub Pages doesn't support Hugo out of the box though. However, GitHub Pages does support just serving raw static HTML/CSS/JS so I created a separate repository (now deleted as I now serve from a gh-pages branch) and imported this as a submodule in the /public/ folder that Hugo uses to publish, we should be able to publish the generated static site directly in to the GitHub Pages repository

### Publishing the site in a roundabout way

It's worth noting you cannot clone an empty repository - you must commit something to the repo before cloning it. I committed a quick readme.md.

```bash
git submodule add -b main https://github.com/Aidenwebb/aidenwebb.github.io.git public
```

After generating the site with ```hugo -t PaperMod```:
Navigate to your public directory and run:

```bash
cd public
git add .
git commit -m "init commit"
git push origin main
```

and the submodule remote repo will be updated, and built by GitHub Pages.

### CSS broke, I'll fix that later

When hosting on GitHub pages, something breaks the integrity of CSS files, so I've opted to disable fingerprinting ([`config.yml:params:assets:disablefingerprinting:true`](https://github.com/Aidenwebb/aidenwebb-com-blog-code/blob/main/blog/config.yml)) for the time being with the intention of investigating further another time.

### Git and empty folders = a confusing folder structure

Moving to another workstation, I noted after pulling my repository that much of the folder structure was missing. Hugo generates a lot of empty folders when it creates a new site, and git does not store empty folders.
I regenerated the site with Hugo, and added a .gitkeep file to each empty folder, committing this to the repository.

### Back to theming, and Publishing the site through Github Actions instead of maintaining two repos

I populated the config.yml with settings from Papermod's example, tweaking them to suit my needs, then added search and tags.
The process of committing to two repositories for code updates and then building and publishing the site from my local system was getting tedious quickly, and after a quick search I was pleased to find that [the Hugo documentation](https://gohugo.io/hosting-and-deployment/hosting-on-github/) included [instructions for a gh-pages workflow](https://gohugo.io/hosting-and-deployment/hosting-on-github/#build-hugo-with-github-action). After some minor modifications and messing with removing my existing submodule and related cache, I had Hugo publishing through CI/CD to GitHub pages. I then deleted my "publishing" repository and renamed my code repository to become my Personal GitHub Pages.

### Sorting out syntax highlighting

I work a lot with Powershell, and after enabling Syntax highlighting, it was clear that PaperMod's included highlight.js did not include support for Powershell. It was also 2 years out of date, running version 10.2.1. I [forked the repository](https://github.com/Aidenwebb/hugo-PaperMod), downloaded [highlight.js version 11.6.0](https://highlightjs.org/download/) with Powershell support and dropped it in place.
I updated `.gitmodules` to point to my own fork of PaperMod, and forced an update of the submodule by running `git submodule update --remote --merge`

Syntax highlighting is now working!

### Now time for comments

My WordPress blog has comments, and while I don't think they're strictly necessary for a blog of this nature, it is nice to receive feedback from those who've been helped by what I've written, or indeed those who need a bit more help.
I signed up for disqus, and integrated the comment HTML provided in to `layouts\partials\comments.html` in my PaperMod fork. I then enabled comments in the config.yml. I do have some reservations about Disqus, so perhaps may move to another platform in the future. Sadly at this stage I've not found a means to preserve the existing comments on my blog. Perhaps I'll copy them in to the end of each article.

### Migrating content

[SchumacherFM has made a WordPress to Hugo exporter](https://github.com/SchumacherFM/wordpress-to-hugo-exporter). I installed this on my WordPress instance and exported my posts. Expectedly, it doesn't do a perfect job of pulling posts and converting them to Markdown, but it certainly does a good enough job to ease the process. Each post will need to be reviewed and edited in order to remove stray html tags, fix Unicode conversions and generally tidy up, but I'm very happy with the result.

### Back to comments, lets migrate those

[Disqus supports importing comments from WordPress](https://help.disqus.com/en/articles/1717131-importing-comments-from-wordpress). Excellent! I don't have to forsake them after all.
Unfortunately, importing via the WordPress plugin failed, so I exported my WordPress content to XML before going to [import.disqus.com](https://import.disqus.com) to import there. This worked.
I am however moving the canonical URL of posts. My WordPress site used to have everything at the top level. EG: <https://aidenwebb.com/how-to-fix-qnap-nas-web-gui-interface-timing-out-or-never-loading/>. Under Hugo, I'm still going to have this URL as an alias, but it will direct to <https://aidenwebb.com/posts/how-to-fix-qnap-nas-web-gui-interface-timing-out-or-never-loading/>.

To map the URL changes, I've gone to my Disqus page, under the Moderation header, in the left-hand menu, I go to Migration tools.
Here, I started the URL Mapper and downloaded a list of current posts, and created an equivalent redirected URL in the CSV before uploading it to the mapper.
