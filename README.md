# Flutter-goinfre-installer
A script to set up Flutter framework and latest version of Android Studio for 42 students in the goinfre directory.

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
4. Restart your terminal or run 👇
```bash
source ~/.zshrc
```
5. Don't forget to change SDK location in Android Studio to goinfre 👇👇
<img width="799" alt="ScreenShot" src="https://user-images.githubusercontent.com/74059327/213250792-3a9af0eb-fbe0-4d82-aa9b-072ddda55c3e.png">

## For lazy people
```bash
git clone git@github.com:Ajjig/Flutter-goinfre-installer.git && cd Flutter-goinfre-installer && bash ./installer.sh && echo "export PATH=\"\$PATH:\$HOME/goinfre/flutter/bin\"" >> ~/.zshrc && echo "export PATH=\"\$PATH:\$HOME/goinfre/flutter/bin/cache/dart-sdk/bin\"" >> ~/.zshrc && cd .. && source ~/.zshrc
```
