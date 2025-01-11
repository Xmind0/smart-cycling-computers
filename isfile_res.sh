#!/bin/bash

# 读取res.qrc文件中的所有文件路径
while IFS= read -r line; do
    if [[ $line =~ \<file\>(.*)\</file\> ]]; then
        file="${BASH_REMATCH[1]}"
        if [ -f "$file" ]; then
            echo "✅ Found: $file"
        else
            echo "❌ Missing: $file"
        fi
    fi
done < res.qrc
