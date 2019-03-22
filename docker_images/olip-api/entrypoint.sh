#!/bin/sh

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

. /opt/api/venv/bin/activate

flask db upgrade

exec "$@"
