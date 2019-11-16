#!/bin/sh

# new profile (requires user interaction)
echo "Create a new Firefox profile. Remember the name!"
firefox -no-remote -ProfileManager 2>/dev/null

# ask user for profile name
echo -n "Enter name of new Firefox profile: "
read NAME

# exits if profile does not exist
[ ! -d ~/.mozilla/firefox/????????.$NAME ] && echo "Firefox profile $NAME does not exist" && exit 1

# creates directory var
DIR=$(find ~/.mozilla/firefox/ -name "????????.$NAME")

# clears profile
rm -rf ${DIR}/*

# get newest version of ghacks user.js file
wget https://raw.githubusercontent.com/ghacksuserjs/ghacks-user.js/master/user.js -O ${DIR}/user.js 2>/dev/null

# append custom overrides to user.js
cat << _EOF_ >> ${DIR}/user.js
/* 0402: disable binaries NOT in Safe Browsing local lists being checked
 * This is a real-time check with Google services
 * [SETUP-SECURITY] If you do not understand this, or if you want this protection, then override it ***/
user_pref("browser.safebrowsing.downloads.remote.enabled", true);

/* 0302a: disable auto-INSTALLING Firefox updates [NON-WINDOWS FF65+]
 * [NOTE] In FF65+ on Windows this SETTING (below) is now stored in a file and the pref was removed
 * [SETTING] General>Firefox Updates>Check for updates but let you choose... ***/
user_pref("app.update.auto", true);
_EOF_

exit 0