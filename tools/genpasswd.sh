cat /dev/urandom | tr -dc 'a-zA-Z0-9-_' | fold -w 12 | head -n 1
