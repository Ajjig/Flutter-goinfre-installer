FLUTTER_HOME=/goinfre/$USER/flutter
ANDROID_STUDIO_HOME=/goinfre/$USER/android-studio
ANDROID_STUDIO_LINK=""
EMULATOR_DOWNLOAD_LINK="https://dl.google.com/android/repository/emulator-darwin_x64-7140946.zip"


BLUE=$'\033[0;34m'
RED=$'\033[0;91m'
BOLD=$'\033[1;31m'
GREEN=$'\033[0;32m'
NC=$'\033[0;39m'

install_flutter="n"
install_android_studio="n"
setup_emulator_to_run="n"

############################# CREATING FOLDERS #############################

echo $BLUE "creating folders..." $NC
mkdir -p ~/goinfre/.gradle
mkdir -p ~/goinfre/.local
mkdir -p ~/goinfre/.dart
mkdir -p ~/goinfre/.dart-tool
mkdir -p ~/goinfre/.dartServer
mkdir -p ~/goinfre/.android
mkdir -p ~/goinfre/android


# remove files if theyre not symlinks
for file in ~/.gradle ~/.local ~/.dart-tool ~/.dartServer ~/.dart ~/.android
do
    if [ -f ~/$file ] && [ ! -L ~/$file ]
    then
      rm -rf ~/$file
			ln -s "~/goinfre/$file" $file
			echo "Symlink created for $file"
    else
      echo "Symlink already exists for $file"
    fi

done




############################# INIT SCRIPT #################################


echo $BOLD $RED "Would you like to install flutter? (y/n)" $NC
read -n 1 install_flutter
echo
echo $BOLD $RED "Would you like to install android studio? (y/n)" $NC
read -n 1 install_android_studio
echo
echo $BOLD $RED "Would you touch your SDK files so emulator can run? (y/n)" $NC
read -n 1 setup_emulator_to_run

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
		echo
		echo $BLUE "Installing flutter..."$NC
		# cloning flutter repo
		git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME &> /dev/null

		echo $BLUE "flutter precache..." $NC
		flutter precache &> /dev/null
		echo $GREEN "flutter installed" $NC
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
	echo $GREEN "Android Studio already installed" $NC
else

	if [ $install_android_studio == "y" ]
	then
		echo
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

		echo $GREEN "android studio installed" $NC
		# launch android studio
		open $ANDROID_STUDIO_HOME/Android\ Studio.app
	fi
fi

############################# SETUP EMULATOR #############################

if [ $setup_emulator_to_run == "y" ]
	then
		if [ -f "~/goinfre/android/emulator/emulator" ]
			then
				echo $RED "To setup emulator, run android studio and install android SDK" $NC
			else
				echo
				rm -rf ~/goinfre/tmp
				mkdir -p ~/goinfre/tmp/
				echo $BLUE "Setting up emulator..." $NC
				echo $BLUE "Downloading emulator..." $NC
				curl -L -o ~/goinfre/tmp/emulator.zip $EMULATOR_DOWNLOAD_LINK
				echo $BLUE "Unzipping emulator..." $NC
				unzip ~/goinfre/tmp/emulator.zip -d ~/goinfre/tmp/emulator &> /dev/null
				echo $BLUE "Copying emulator..." $NC
				cp -r ~/goinfre/tmp/emulator/emulator/* ~/goinfre/android/emulator/ &> /dev/null
				rm -rf ~/goinfre/tmp
				echo $GREEN "Emulator setup complete" $NC
		fi
fi

############################# ADDING PATHS TO .ZSHRC #################################

echo $BLUE "Adding paths to your .zshrc file..." $NC

if [ -f ~/.zshrc ] && [ $(grep -c "##-----> FLUTTER GOINFRE INSTALLER <-----##" ~/.zshrc) -gt 0 ]
	then
		echo $GREEN "Paths already added to .zshrc" $NC
	else
		echo '##-----> FLUTTER GOINFRE INSTALLER <-----##' >> ~/.zshrc
		echo 'export PATH="$PATH:$HOME/goinfre/flutter/bin"' >> ~/.zshrc
		echo 'export PATH="$PATH:/Users/$USER/android/platform-tools"' >> ~/.zshrc
		echo 'export PATH="$PATH:$HOME/goinfre/flutter/bin/cache/dart-sdk/bin"' >> ~/.zshrc
		echo 'export ANDROID_SDK_ROOT="/Users/$USER/goinfre/android"' >> ~/.zshrc
		echo $GREEN "Paths added to .zshrc" $NC
fi

echo $GREEN "DONE!" $NC
echo $BOLD "     - Open a new terminal or run 'source ~/.zshrc' to apply changes"
echo "     - When you open Android Studio, make sure to install android SDK in ~/goinfre/android"
echo "     - To accept android studio license run 'flutter doctor --android-licenses'"
echo "     - It is recommended to you use a physical device since emulator might not work" $NC