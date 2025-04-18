#!/usr/bin/env bash
#
# Copyright (C) 2023 Salvo Giangreco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# shellcheck disable=SC2001

set -Ee

# [
GET_LATEST_FIRMWARE()
{
    curl -s --retry 5 --retry-delay 5 "https://fota-cloud-dn.ospserver.net/firmware/$REGION/$MODEL/version.xml" \
        | grep latest | sed 's/^[^>]*>//' | sed 's/<.*//'
}
#]

if [ "$#" != 1 ]; then
    echo "Usage: update_prebuilt_blobs <path>"
    exit 1
fi

case "$1" in
    "unica/patches/vndk/30")
        MODULE="$1"
        FW="SM-A736B/XME/352828291234563"
        BLOBS="system/system/system_ext/apex/com.android.vndk.v30.apex"
        ;;
    "unica/patches/vndk/31")
        MODULE="$1"
        FW="SM-S901E/INS/350999641234561"
        BLOBS="system_ext/apex/com.android.vndk.v31.apex"
        ;;
    "unica/patches/vndk/33")
        MODULE="$1"
        FW="SM-S911B/EUX/352404911234563"
        BLOBS="system_ext/apex/com.android.vndk.v33.apex"
        ;;
    "unica/mods/china")
        MODULE="$1"
        FW="SM-S9380/CHC/355534491000674"
        BLOBS="$(find "$SRC_DIR/unica/mods/china/system" -type f | sed "s.$SRC_DIR/unica/mods/china.system.")"
        ;;
    *)
        echo "Unsupported path: $1"
        exit 1
        ;;
esac

MODEL=$(echo -n "$FW" | cut -d "/" -f 1)
REGION=$(echo -n "$FW" | cut -d "/" -f 2)

[ -z "$(GET_LATEST_FIRMWARE)" ] && exit 1
if [[ "$(GET_LATEST_FIRMWARE)" == "$(cat "$SRC_DIR/$MODULE/.current")" ]]; then
    echo "Nothing to do."
    exit 0
fi

echo -e "Updating $MODULE blobs\n"

export SOURCE_FIRMWARE="$FW"
export TARGET_FIRMWARE="$FW"
export SOURCE_EXTRA_FIRMWARES=""
export TARGET_EXTRA_FIRMWARES=""
bash "$SRC_DIR/scripts/download_fw.sh"
bash "$SRC_DIR/scripts/extract_fw.sh"

for i in $BLOBS; do
    if [[ "$i" == *"system_ext/apex/com.android.vndk.v"* ]]; then
        if [[ "$i" == *"com.android.vndk.v30.apex" ]]; then
            rm -rf "$SRC_DIR/unica/patches/vndk/30/com.android.vndk.v30.apex."*
            split -db 52428800 "$FW_DIR/${MODEL}_${REGION}/$i" \
                "$SRC_DIR/unica/patches/vndk/30/com.android.vndk.v30.apex."
        else
            cp -a --preserve=all "$FW_DIR/${MODEL}_${REGION}/$i" \
                "$SRC_DIR/$MODULE/$(basename "$i")"
        fi

        continue
    fi

    if [[ "$i" == "system/system/system_ext/"* ]]; then
        cp -a --preserve=all "$FW_DIR/${MODEL}_${REGION}/$i" \
            "$SRC_DIR/$MODULE/$(echo "$i" | sed "s.system/system/system_ext/.system_ext/.")" || true
    elif [[ "$i" == "system/system/"* ]]; then
        cp -a --preserve=all "$FW_DIR/${MODEL}_${REGION}/$i" \
            "$SRC_DIR/$MODULE/$(echo "$i" | sed "s.system/system/.system/.")" || true
    elif [[ "$i" == "product/"* ]] || [[ "$i" == "vendor/"* ]] || [[ "$i" == "system_ext/"* ]]; then
        cp -a --preserve=all "$FW_DIR/${MODEL}_${REGION}/$i" \
            "$SRC_DIR/$MODULE/$i" || true
    fi
done

cp --preserve=all "$FW_DIR/${MODEL}_${REGION}/.extracted" "$SRC_DIR/$MODULE/.current"

exit 0
