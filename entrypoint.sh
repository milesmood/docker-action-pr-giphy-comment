#!/bin/sh

GITHUB_TOKEN=$1
GIPHY_API_KEY=$2

pull_request_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
echo "PR Number - $pull_request_number"
echo "GITHUB_EVENT_PATH - $GITHUB_EVENT_PATH"

giphy_response=$(curl -s "https://api.giphy.com/v1/gifs/random?api_key=$GIPHY_API_KEY&tag=thank%20you&rating=g")
echo "Giphy Response - $giphy_response

gif_url=$(echo "$giphy_response" | jq --raw-output .data.images.downsized.url)
echo "gif_url - $gif_url"

# Create a comment with the GIF on the PR
comment_response=$(curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$pull_request_number/comments \
  -d "{\"body\": \"### PR - #$pull_request_number.\n### Thank you for this contribution!\n![GIF]($gif_url)\"}")