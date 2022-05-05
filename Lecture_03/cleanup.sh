#!/bin/bash
shopt -s extglob
echo "Cleaning up"
find . -not -name "*.v" -not -name "*.ucf" -not -name "*.xise" -not -name "*.bit" -not -name "*.sh" -not -type d -delete
