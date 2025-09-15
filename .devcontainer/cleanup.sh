#!/bin/bash
echo "Destroying Firefox profile and browser history..."
rm -rf /home/vscode/.mozilla
rm -rf /home/vscode/.cache/mozilla
echo "Removing shell history..."
rm -f /home/vscode/.bash_history
history -c
echo "Cleanup complete. All traces of the browser session have been removed."