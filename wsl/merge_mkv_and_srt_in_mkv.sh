#!/usr/bin/env bash

declare -a args

for mkv in *.mkv ; do
    base="${mkv%mkv}"
    output="${base// /_}"
    args=(-o "output/${output}mkv" "${mkv}")

    if [[ -f "${base}srt" ]]; then
        args=("${args[@]}" --language 0:eng --track-name 0:English "${base}srt")
    fi

    echo "[INFO] Processing [$mkv]"

    mkvmerge.exe "${args[@]}"

    echo "[INFO] Completed [$mkv]"
done
