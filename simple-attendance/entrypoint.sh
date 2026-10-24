#!/bin/sh
set -eu

PORT="${PORT:-8080}"

case "$PORT" in
  ''|*[!0-9]*)
    echo "PORT must be a number between 1 and 65535; got: $PORT" >&2
    exit 1
    ;;
esac

if [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
  echo "PORT must be between 1 and 65535; got: $PORT" >&2
  exit 1
fi

SERVER_XML="${CATALINA_HOME:-/usr/local/tomcat}/conf/server.xml"

if [ ! -f "$SERVER_XML" ]; then
  echo "Tomcat server.xml not found: $SERVER_XML" >&2
  exit 1
fi

if ! grep -Eq '<Connector port="8080" protocol="HTTP/1\.1"' "$SERVER_XML"; then
  echo "Could not find Tomcat's default HTTP connector on port 8080 in $SERVER_XML" >&2
  exit 1
fi

sed -i -E "s#(<Connector port=\")8080(\" protocol=\"HTTP/1\.1\")#\1${PORT}\2#" "$SERVER_XML"

if ! grep -Eq "<Connector port=\"$PORT\" protocol=\"HTTP/1\.1\"" "$SERVER_XML"; then
  echo "Failed to configure Tomcat to listen on port $PORT" >&2
  exit 1
fi

exec "$@"
