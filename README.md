


what types of files are in the directory?

    find . -type f | xargs file -b | sort | uniq -c | sort -n
