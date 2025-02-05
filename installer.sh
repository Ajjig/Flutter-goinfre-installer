FLUTTER_HOME=/goinfre/$USER/flutter
ANDROID_STUDIO_HOME=/goinfre/$USER/android-studio
ANDROID_STUDIO_LINK=""


BLUE=$'\033[0;34m'
RED=$'\033[0;91m'
BOLD=$'\033[1;31m'
NC=$'\033[0;39m'

install_flutter="n"
install_android_studio="n"

############################# CREATING FOLDERS #############################

echo $BLUE "creating folders..." $NC
mkdir -p ~/goinfre/gradle
mkdir -p ~/goinfre/local
mkdir -p ~/goinfre/dart
mkdir -p ~/goinfre/dart-tool
mkdir -p ~/goinfre/dartServer
mkdir -p ~/goinfe/dot-android
mkdir -p ~/goinfre/android


# remove files if theyre not symlinks
for file in .gradle .local .dart-tool .dartServer .dart .android
do
    if [ -f ~/$file ] && [ ! -L ~/$file ]
    then
      rm -rf ~/$file
      echo "Removed ~/$file"
    else
      echo "Symlink already exists for ~/$file"
    fi

done

ln -s ~/goinfre/local .local 2> /dev/null
echo $BLUE ".local -> ~/goinfre/local"
ln -s ~/goinfre/gradle .gradle 2> /dev/null
echo ".gradle -> ~/goinfre/gradle"
ln -s ~/goinfre/dart-tool .dart-tool 2> /dev/null
echo ".dart-tool -> ~/goinfre/dart-tool"
ln -s ~/goinfre/dart .dartServer 2> /dev/null
echo ".dartServer -> ~/goinfre/dartServer"
ln -s ~/goinfre/dart .dart 2> /dev/null
echo ".dart -> ~/goinfre/dart"
ln -s ~/goinfre/dot-android .android 2> /dev/null
echo ".android -> ~/goinfre/dot-android" $NC



############################# INIT SCRIPT #################################


echo $BOLD $RED "Would you like to install flutter? (y/n)" $NC
read -n 1 install_flutter
echo $BOLD $RED "Would you like to install android studio? (y/n)" $NC
read -n 1 install_android_studio

if [ $install_flutter == "y" ]
then
	install_flutter="y"
fi

if [ $install_android_studio == "y" ]
then
	install_android_studio="y"
fi


############################# INSALLING FLUTTER #############################

if [ -f "$FLUTTER_HOME/bin/flutter" ]

then
	echo $RED "flutter already installed" $NC
else
	if [ $install_flutter == "y" ]
	then
		mkdir -p $FLUTTER_HOME
		echo $BLUE "\ninstalling flutter..."$NC
		# cloning flutter repo
		git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME &> /dev/null

		echo $BLUE "flutter precache..." $NC
		flutter precache &> /dev/null
	fi

fi


############################# INSALLING ANDROID STUDIO #############################

# get android studio link
get_android_studio_link()
{
	ANDROID_STUDIO_LINK=$(curl https://developer.android.com/studio/index.html | grep -o --regexp='https://redirector.*.com/edgedl/android/studio/install/.*android-studio-.*-mac.dmg')

	if [ -z "$ANDROID_STUDIO_LINK" ]
	then
		echo $RED "Android Studio link not found" $NC
		exit 1
	fi
}



if [ -d "$ANDROID_STUDIO_HOME/Android Studio.app" ]
then
	echo $RED "Android Studio already installed" $NC
else

	if [ $install_android_studio == "y" ]
	then
		echo $BLUE "Getting Android-Studio latest version..." $NC
		get_android_studio_link

		mkdir -p $ANDROID_STUDIO_HOME

		echo $BLUE "downloading android studio... (version: " $(echo $ANDROID_STUDIO_LINK | grep -o --regexp='android-studio-.*-mac.dmg' | cut -d "-" -f 3) ")" $NC
		# download android studio
		curl -L -o $ANDROID_STUDIO_HOME/android-studio.dmg --max-redirs 10 $ANDROID_STUDIO_LINK &> /dev/null

		echo $BLUE "mounting android studio..." $NC

		# mount dmg file in Android-Studio in $ANDROID_STUDIO_HOME
		hdiutil attach $ANDROID_STUDIO_HOME/android-studio.dmg -mountpoint $ANDROID_STUDIO_HOME/android-studio &> /dev/null

		echo $BLUE "copying android studio..." $NC

		# copy android studio to $ANDROID_STUDIO_HOME
		cp -r $ANDROID_STUDIO_HOME/android-studio/Android\ Studio.app $ANDROID_STUDIO_HOME &> /dev/null

		echo $BLUE "unmounting android studio..." $NC

		# unmount dmg file
		hdiutil detach $ANDROID_STUDIO_HOME/android-studio &> /dev/null

		# make shortcut in $HOME/Desktop
		ln -s $ANDROID_STUDIO_HOME/Android\ Studio.app $HOME/Desktop/Android\ Studio.app

		#remove dmg file
		rm -rf $ANDROID_STUDIO_HOME/android-studio.dmg &> /dev/null

		echo $BLUE "android studio installed" $NC
		# launch android studio
		open $ANDROID_STUDIO_HOME/Android\ Studio.app
	fi
fi

echo $BLUE "Adding paths to your .zshrc file..." $NC

if [ -f ~/.zshrc ] && [ $(grep -c "##-----> FLUTTER GOINFRE INSTALLER <-----##" ~/.zshrc) -gt 0 ]
	then
		echo $BLUE "Paths already added to .zshrc" $NC
	else
		echo '##-----> FLUTTER GOINFRE INSTALLER <-----##' >> ~/.zshrc
		echo 'export PATH="$PATH:$HOME/goinfre/flutter/bin"' >> ~/.zshrc
		echo 'export PATH="$PATH:/Users/$USER/android/platform-tools"' >> ~/.zshrc
		echo 'export PATH="$PATH:$HOME/goinfre/flutter/bin/cache/dart-sdk/bin"' >> ~/.zshrc
		echo 'export ANDROID_SDK_ROOT="/Users/$USER/goinfre/android"' >> ~/.zshrc
fi

echo $NC "DONE!"
echo "     - Open a new terminal or run 'source ~/.zshrc' to apply changes"
echo "     - When you open Android Studio, make sure to install android SDK in ~/goinfre/android"
echo "     - To accept android studio license run 'flutter doctor --android-licenses'"