# 🌎

![Last Commit Badge](https://img.shields.io/github/last-commit/aidenwebb/aidenwebb.github.io) ![Website Up](https://img.shields.io/website?up_color=green&url=https%3A%2F%2Faidenwebb.com)

Source Code for [aidenwebb.com](https://aidenwebb.com).

Built using GoLang on Hugo. Deploys on GitHub Pages.

For Open Source versions go to [gohugo.io](https://gohugo.io/).

To set up:

```bash
git clone git@github.com:Aidenwebb/aidenwebb.github.io.git
cd aidenwebb.github.io/blog/themes/PaperMod
git submodule init
git submodule update
cd ../../../bin

curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest \
 grep  browser_download_url \
 | grep linux-amd64.deb \
 | grep -v extended \
 | cut -d '"' -f 4 \
 | wget -i -

sudo dpkg -i hugo*.deb

sudo apt update -y
sudo apt install hugo -y
```

---
(c) Aiden Arnkels-Webb. All Rights Reserved.