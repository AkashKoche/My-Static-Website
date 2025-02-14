#!/bin/bash

set -e

echo "Starting static website tests..."

echo "Validating HTML files..."
html_files=$(find . -name "*.html")
for file in $html_files; do
    echo "Validating $file..."
    curl --silent --show-error --header "Content-Type: text/html; charset=utf-8" \
         --data-binary "@$file" https://validator.w3.org/nu/?out=json > /dev/null
    if [ $? -ne 0 ]; then
        echo "HTML validation failed for $file"
        exit 1
    fi
done
echo "HTML validation passed."

echo "Validating CSS files..."
css_files=$(find ./css -name "*.css")
for file in $css_files; do
    echo "Validating $file..."
    curl --silent --show-error --header "Content-Type: text/css; charset=utf-8" \
         --data-binary "@$file" https://jigsaw.w3.org/css-validator/validator?profile=css3svg&output=json > /dev/null
    if [ $? -ne 0 ]; then
        echo "CSS validation failed for $file"
        exit 1
    fi
done
echo "CSS validation passed."

# Step 3: Lint JavaScript files using ESLint
echo "Linting JavaScript files..."
if ! npx eslint ./js/*.js; then
    echo "JavaScript linting failed."
    exit 1
fi
echo "JavaScript linting passed."

# Step 4: Check for broken links using `linkchecker` (install it first: `sudo apt install linkchecker`)
echo "Checking for broken links..."
if ! linkchecker http://localhost:8080; then
    echo "Broken links found."
    exit 1
fi
echo "No broken links found."

# Step 5: Accessibility Testing using `pa11y` (install it first: `npm install -g pa11y`)
echo "Running accessibility tests..."
if ! pa11y http://localhost:8080; then
    echo "Accessibility tests failed."
    exit 1
fi
echo "Accessibility tests passed."

echo "All tests passed successfully!"
