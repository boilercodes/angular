#!/usr/bin/env bash
while getopts a:d:n: flag
do
    # shellcheck disable=SC2220
    case "${flag}" in
        a) author=${OPTARG};;
        d) description=${OPTARG};;
        n) name=${OPTARG};;
    esac
done

TitleCaseConverter() {
    sed 's/.*/\L&/; s/[a-z]*/\u&/g' <<<"$1"
}

folder="${name,,}"
folder="${folder//-/_}"

title="${folder//_/ }"
title="$(TitleCaseConverter "$title")"

repo="$author/$name"

# Change package.json
sed -i "s/angular-website/$name/g" package.json

# Change angular.json
sed -i "s/angular-website/$name/g" angular.json

# Change karma.conf.js
sed -i "s/angular-website/$name/g" karma.conf.js

# Change src/app/app.component.ts
sed -i "s/angular-website/$name/g" src/app/app.component.ts

# Change src/app/app.component.spec.ts
sed -i "s/angular-website/$name/g" src/app/app.component.spec.ts

# Change src/index.html
sed -i "s/Angular Website/$title/g" src/index.html

# Change LICENSE
sed -i "s|boilercodes/angular|$name|g" LICENSE # Separator is |

# Change SECURITY.md
sed -i "s/rmenai/$author/g" SECURITY.md

# Change .github/pull_request_template.md
sed -i "s|boilercodes/angular|$repo|g" .github/pull_request_template.md

# Change README.md
cp -f .github/temp/README.md README.md # Override file
sed -i "s/{title}/$title/g" README.md
sed -i "s/{description}/$description/g" README.md
sed -i "s|{repo}|$repo|g" README.md # Separator is |
sed -i "s/{author}/$author/g" README.md
sed -i "s/{name}/$name/g" README.md
