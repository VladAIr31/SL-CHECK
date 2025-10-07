# SL-CHECK: Symbolic Link Checker

**SL-CHECK** is a  shell script designed to recursively scan a directory tree and identify broken symbolic links. It also includes a feature to detect circular references (cycles) when following symbolic links to directories..

***

## The Problem: Dangling and Circular Symlinks

Symbolic links (or symlinks) are a fundamental feature of Unix-like operating systems, allowing for file system flexibility. However, they can lead to two common problems:

1.  **Broken Links:** A symlink becomes "broken" or "dangling" when the file or directory it points to is moved, renamed, or deleted. These broken links can cause errors in scripts and applications.
2.  **Circular Links (Cycles):** If a symlink points to a directory that is an ancestor of the link itself, it can create an infinite loop or "cycle." A program that recursively traverses the directory tree could get trapped in this loop, consuming excessive system resources.

**SL-CHECK** is designed to efficiently find and report both of these issues.

***

## How It Works: The Logic Behind SL-CHECK

The script's core logic is built around a recursive function that intelligently navigates the file system. Here's a breakdown of the approach:

### 1. Recursive Traversal

The script uses a function, `check_links`, to perform a depth-first traversal of the directory structure starting from the user-provided path. For each item in a directory, it determines if it's a regular directory, a symbolic link, or another file type. If it's a directory, the script calls itself on that directory to continue the scan.

### 2. Identifying Broken Links

For each symbolic link encountered, the script checks if the target of the link actually exists using `[[ ! -e "$entry" ]]`. If the target doesn't exist, the link is flagged as broken, and its path is printed to the console.

### 3. Optional Symlink Following

By default, for safety and to avoid unintentional deep dives into other parts of the filesystem, the script does not follow symlinks that point to other directories. However, when the `--follow-symlinks` flag is provided, this behavior changes.

### 4. Cycle Detection

The most complex part of the script is preventing infinite loops when following directory symlinks. The script solves this with the following logic:

* **Tracking Visited Directories:** An array named `visited_dirs` is maintained, which stores the absolute, canonical path of every directory the script enters.
* **Checking for Ancestors:** Before entering a directory that is the target of a symlink, the script resolves its real path. It then checks if this new path is a parent or an ancestor of any directory already in the `visited_dirs` list.
* **Prefix Matching:** The check is done by seeing if the new, real path is a prefix of any of the already visited paths. If it is, this indicates a circular reference, a "cycle," has been found. The script reports the cycle and stops traversing that path to prevent an infinite loop.

***

## Features

* **Broken Link Detection:** Recursively finds and reports all symbolic links that point to non-existent files or directories.
* **Cycle Detection:** When following directory symlinks, it intelligently detects and reports circular references to prevent infinite loops.
* **Symlink Following Control:** By default, it inspects symlinks without following them into other directories. The `--follow-symlinks` option enables deep scanning of linked directories.
* **Safe and Efficient:** Written in pure Bash, making it portable and efficient. It avoids common pitfalls of directory traversal.

***

## Usage

The script is straightforward to use from the command line.

```bash
./proiect.sh [--follow-symlinks] <directory>
