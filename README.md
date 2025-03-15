# SL-CHECK
A shell script that takes a directory (potentially the root of the filesystem) as a parameter and checks for broken symbolic links—links that reference non-existent files. The script should work recursively, inspecting the entire hierarchy of files and directories starting from the given directory.

By default, when encountering a symbolic link to a directory, the script should not follow it (i.e., it should not recursively analyze the referenced directory). However, if the script is executed with the --follow-symlinks flag, it should continue the recursive analysis into the referenced directory.
