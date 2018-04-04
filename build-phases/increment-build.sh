#/bin/sh
APP="*/App-Dev-Info.plist"
for plist in $APP
do
 if((${#APP[@]} == 1)); then
 	echo "Found the one to unite them all...."
 	buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${PROJECT_DIR}/$plist")
        echo "start build number:" $buildNumber 
	version=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${PROJECT_DIR}/$plist")
 	echo "+++cardinal build number:" $buildNumber 
        echo "+++cardinal version:" $version
        buildNumber=$((buildNumber + 1 )) 
	echo "incr build:" $buildNumber 
	/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${PROJECT_DIR}/${plist}"
 else
 	echo "More than one plist found.....aborting"
	exit 2
 fi
done

#Changing the other plists
FILES="*/Development-Info.plist"
for plist in $FILES
do
	/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $version" "${PROJECT_DIR}/${plist}"
	/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${PROJECT_DIR}/${plist}"
done

