# Flutter-goinfre-installer
A script to set up Flutter framework and Android Studio for 42 students in the goinfre directory.

## How to use
1. Clone the repository
2. Run the script with
```bash
bash ./installer.sh
```
3. Add the following lines to your .zshrc/.bashrc file
```bash
export PATH="$PATH:$HOME/goinfre/flutter/bin"
export PATH="$PATH:$HOME/goinfre/flutter/bin/cache/dart-sdk/bin"
```
4. Restart your terminal

## For lazy people
```bash
git clone git@github.com:Ajjig/Flutter-goinfre-installer.git && cd Flutter-goinfre-installer && bash ./installer.sh && echo "export PATH=\"\$PATH:\$HOME/goinfre/flutter/bin\"" >> ~/.zshrc && echo "export PATH=\"\$PATH:\$HOME/goinfre/flutter/bin/cache/dart-sdk/bin\"" >> ~/.zshrc && cd .. && source ~/.zshrc
```
