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

```
git submodule add -b main https://github.com/Aidenwebb/aidenwebb.github.io.git public
```

After generating the site with ```hugo -t PaperMod``` 

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus accumsan et leo ullamcorper feugiat. Nam id ultricies nisl, ut porttitor eros. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ac bibendum enim, eu pretium ante. Nunc interdum vulputate urna, vitae tempor diam aliquet sed. Donec efficitur luctus sem vitae aliquet. Nullam tellus dui, feugiat at tortor ut, pellentesque semper nibh. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.

Maecenas vestibulum leo ipsum, eget viverra massa ullamcorper venenatis. Donec imperdiet turpis ultricies, condimentum tellus eget, ultricies ligula. Nullam sed quam et diam accumsan scelerisque nec ac ex. Aenean et arcu vitae justo interdum efficitur et sit amet odio. In efficitur sollicitudin metus nec dapibus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Integer blandit cursus quam eget sagittis. Donec sed arcu faucibus, rhoncus urna non, varius erat. Mauris tincidunt neque luctus, commodo augue sit amet, tempus purus. Phasellus aliquet vitae nisl imperdiet ultricies. Duis vel risus luctus, scelerisque erat id, feugiat nulla. Cras nunc ipsum, auctor ut dapibus varius, congue nec dui. Etiam vel ultrices ligula.

Integer gravida purus vel mollis sodales. Donec a elit accumsan, porttitor turpis et, faucibus leo. Praesent dignissim in lorem et tincidunt. Interdum et malesuada fames ac ante ipsum primis in faucibus. Aenean porttitor non sem eu sagittis. Maecenas vitae eros id metus laoreet mollis. Nunc quis tempus arcu.

Integer et lorem vel orci sollicitudin commodo vitae et elit. Pellentesque quis ultrices nisl. Maecenas non nisi dictum nulla fermentum lacinia. Nam placerat ultrices sapien, id dignissim libero euismod a. Duis sed tellus vitae sapien maximus vestibulum lobortis in nibh. Vestibulum purus nisi, sodales et ipsum nec, porta scelerisque eros. Aliquam at dictum nisl. Mauris non tellus at nunc pulvinar tincidunt. Vestibulum viverra tempor mi, sit amet auctor erat congue sit amet. Nullam dictum tempor nisl, in facilisis nisl venenatis sit amet. Mauris porta magna vitae libero ultrices sodales. Sed eu arcu consequat, condimentum urna imperdiet, dictum nisi. Pellentesque eget consectetur ex, quis euismod urna. Morbi eget rhoncus risus. Ut vitae metus at diam pharetra vehicula.

Integer ut nulla dignissim, auctor urna id, mollis libero. Maecenas aliquam pharetra mi et feugiat. Donec id malesuada massa, quis lobortis est. Etiam sed dolor at magna viverra mattis. Sed dictum libero vitae eros auctor, vitae accumsan sem interdum. Nunc facilisis sem a augue ornare, ac ultricies ligula fringilla. Curabitur eget commodo felis. Vivamus vitae blandit urna, bibendum eleifend mi. Nunc a risus accumsan, elementum felis sed, vestibulum risus. Sed sed turpis vehicula, malesuada lacus ac, porttitor dui. Nulla at ultrices metus. Mauris vitae consectetur neque. Nullam eget quam at mauris mattis cursus faucibus at tortor. Aliquam nec vestibulum nunc. Proin elementum porttitor mi id elementum. 