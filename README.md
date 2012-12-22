# Dart Cookbook

This project contains the source and code for the `Dart Cookbook`

## Project Status on drone.io

![Alt drone.io status](https://drone.io/shailen/Cookbook/status.png)

## Project Structure

### book
`index.md` has the code snippets merged into the recipes. Use this to read the
book for now.

### lib
Directory containing much of the code contained in the recipes. Each recipe will
have a corresponding folder under lib/ or one of its descendant directories.

### src
`index.md` contains the text of the recipes and the `MERGE(...)` commands indicating
the source of the code snippets used in each recipe. This 'unmerged' file is
later converted to the merged `book/index.md` using `doc_code_merge`.  Read
about `doc_code_merge` at https://github.com/dart-lang/doc-code-merge.

### test
The test directory for code used in the cookbook. All the tests can be run by
running:

    dart test/test_runner.dart

### .gitignore
Symlinks created by running `pub install` in the development cycle should be ignored
by git.

### AUTHORS 
The names of the authors of the recipes.


### LICENSE
The license under which this project is made available.

### README.md:
This file.

### pubspec.yaml
pub is a package manager for Dart. Pub dependencies are listed in this file.

### pubspec.lock
pub dependencies with the specific versions used in the project

