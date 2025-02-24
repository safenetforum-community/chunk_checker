#!/bin/bash

# Temporary files for accumulating totals
tmp_nodes=$(mktemp)
tmp_records=$(mktemp)
echo 0 > "$tmp_nodes"
echo 0 > "$tmp_records"

# Display menu
echo "Please select a search option:"
echo "1) Launchpad"
echo "2) Antnode Manager (antctl)"
echo "3) Formicaio"
echo "4) NTracking(anm)"
read -p "Enter your choice (1-4): " choice

# Determine search path based on selection
case $choice in
    1|2)
        search_root="$HOME/.local/share/autonomi/"
        search_cmd="find \"$search_root\" -type d -name \"record_store\" -print0 2>/dev/null"
        ;;
    3)
        search_cmd="find / -type d -iname \"formicaio\" -print0 2>/dev/null | \
                    while IFS= read -r -d '' fdir; do \
                        find \"\$fdir\" -type d -name \"record_store\" -print0 2>/dev/null; \
                    done"
        ;;
    4)
        search_root="/var/antctl/services/"
        search_cmd="find \"$search_root\" -type d -name \"record_store\" -print0 2>/dev/null"
        ;;
    *)
        echo "Invalid option"
        rm "$tmp_nodes" "$tmp_records"
        exit 1
        ;;
esac

# Execute the search and processing
eval "$search_cmd" | while IFS= read -r -d '' dir; do
    # Update total nodes count
    current_nodes=$(<"$tmp_nodes")
    echo $((current_nodes + 1)) > "$tmp_nodes"

    # Count files in this record_store
    count=$(find "$dir" -maxdepth 1 -type f -printf '.' 2>/dev/null | wc -c)
    
    # Update records total if files exist
    if [ "$count" -gt 0 ]; then
        current_records=$(<"$tmp_records")
        echo $((current_records + count)) > "$tmp_records"
        echo "${dir}: ${count}"
    fi
done

# Read final totals
total_nodes=$(<"$tmp_nodes")
total_records=$(<"$tmp_records")

# Cleanup temp files
rm "$tmp_nodes" "$tmp_records"

# Display results
echo "Total number of nodes: $total_nodes"
echo "Total number of records stored: $total_records"
