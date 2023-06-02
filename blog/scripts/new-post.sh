#!/bin/bash

echo $1 # Post Name

hugo new --kind post-bundle posts/$(date +%Y-%m-%d)-${1// /-}