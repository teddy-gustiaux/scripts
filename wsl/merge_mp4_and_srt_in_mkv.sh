#!/usr/bin/env bash

declare -a args

for directory in */ ; do
    echo "[INFO] Going into [$directory]"
    cd "$directory" || exit 1

    for mp4 in *.mp4 ; do
        base="${mp4%mp4}"
        output="${base// /_}"
        args=(-o "output/${output}mkv" "${mp4}")

        if [[ -f "${base}srt" ]]; then
            args=("${args[@]}" "${base}srt")
        fi

        echo "[INFO] Processing [$mp4]"

        mkvmerge.exe "${args[@]}"

        echo "[INFO] Completed [$mp4]"
    done
    cd ..
done
