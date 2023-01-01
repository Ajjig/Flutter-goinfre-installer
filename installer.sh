FLUTTER_HOME=/goinfre/$USER/flutter
ANDROID_STUDIO_HOME=/goinfre/$USER/android-studio
ANDROID_STUDIO_LINK=""


BLUE=$'\033[0;34m'
RED=$'\033[0;91m'
BOLD=$'\033[1;31m'
NC=$'\033[0;39m'


############################# INSALLING FLUTTER #############################

if [ -f "$FLUTTER_HOME/bin/flutter" ]

then
	echo $RED "flutter already installed" $NC

else
	printf "$BOLD Flutter isn't found. Do you want to install it ? (y/n) $NC"

	read -n 1 answer
	if [ $answer != "y" ]
	then
		exit 0
	fi

	mkdir -p $FLUTTER_HOME
	echo $BLUE "\ninstalling flutter..."$NC

	# cloning flutter repo
	git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME &> /dev/null

	echo $BLUE "flutter precache..." $NC
	flutter precache &> /dev/null


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



if [ -d "$ANDROID_STUDIO_HOME/Android\ Studio.app" ]
then
	echo $RED "\nandroid studio already installed" $NC

else
	printf "$BOLD Android-Studio isn't found. Do you want to install it ? (y/n) $NC"

	read -n 1 answer

	if [ $answer != "y" ]
	then
		exit 0
	fi

	get_android_studio_link

	mkdir -p $ANDROID_STUDIO_HOME

	echo $BLUE "downloading android studio..." $NC
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
