#!/bin/bash

post_title=$1 # Post Title
echo $post_title

if [ -z "$post_title" ];
then
    echo Enter the post name:

    read post_title

fi

( cd blog; hugo new --kind post-bundle posts/$(date +%Y-%m-%d)-${post_title// /-} )