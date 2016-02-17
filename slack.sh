#!/bin/bash

#: Title        : Slack Integration
#: Date         : 31-06-2015
#: Author       : Francesco de Guytenaere <guytenaere.fe@gmail.com>
#: Version      : 1.0
#: Description  : Simple wrapper for messaging through slack-integration 
#: Options      : -h help, -u url , -c channel, -n username, -i image, -t text

# Show help
usage="$(basename "$0") [-h] -- Simple tool to send messages to slack-integration using curl

usage:
    -h  Show this help text\n
    -u  Integration URL\n
    -c  Channel to send it to. Default is whatever you linked the integration to.\n
    -n  Username to send it as. Integration-Bot is default.\n
    -i  Image used as Avatar of the user. Default is :ghost:\n
    -t  Text to send
"

# Exit
die () {
    echo >&2 "$@"
    exit 1
}

# Check commandline arguments
while getopts 'u:c:n:i:t:h' opt; do
    case "$opt" in
        h)  die "$usage"
            ;;
        u)  URL=$OPTARG
            ;;
        c)  CHANNEL=$OPTARG
            ;;
        n)  USERNAME=$OPTARG
            ;;
        i)  IMAGE=$OPTARG
            ;;
        t)  TEXT=$OPTARG
            ;;
        \?) printf "illegal option: -%s\n" "$OPTARG" >&2
            die "$usage"
            ;;   
    esac
done
shift $((OPTIND - 1))

# Check
if [[ -z $URL  ]]; then 
    echo "$usage"
    die "No integration url has been supplied."
fi 
if [[ -z $USERNAME  ]]; then 
   USERNAME=Integration-Bot
fi 
if [[ -z $IMAGE  ]]; then 
   IMAGE=:ghost:
fi 
if [[ -z $TEXT ]]; then 
    echo "$usage"
    die "No text has been supplied."
fi 

# Send
curl \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data '
    {
        "channel": "'"$CHANNEL"'", 
        "username": "'"$USERNAME"'", 
        "text": "'"$TEXT"'", 
        "icon_emoji": "'"$IMAGE"'"
    }' $URL
echo
