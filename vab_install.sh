#!/data/data/com.termux/files/usr/bin/bash
echo '================ cantrol architecture and android version ==================='
case $(uname -m) in
    aarch64)   echo 'aarch64 is allow, continue' ;;
    arm)  dpkg --print-architecture | grep -q "arm64" && \
          echo ' aarch64 is allow, continue' || \
          echo 'unfortunately arm is not allow, only suported is aarch64  it must exist' && exit 1  ;;
    *) echo 'unfortunately not allow, only suported is aarch64 it must exist' && exit 1   ;;
esac
s_version=$(termux-info | grep -A1 "Android version" | grep -Po "\\d+")
version=$(($s_version+0))
if (version < 9) then
	echo 'unfortunately anroid must be 9 or above'
	exit 1
fi
echo '================================================================'
echo '                     install dependencies'
echo '================================================================'
pkg update && pkg upgrade && pkg install aapt apksigner dx ecj openjdk-17 git wget

echo '================================================================'
echo '                     download sdk.zip'
echo '================================================================'
cd ~ && wget https://github.com/Lzhiyong/termux-ndk/releases/download/android-sdk/android-sdk-aarch64.zip
echo '================================================================'
echo '                               unzip sdk.zip'
echo '================================================================'
cd ~ && unzip -qq android-sdk-aarch64.zip
echo '================================================================'
echo '                              tidy sdk.zip'
echo '================================================================'
cd ~ && rm android-sdk-aarch64.zip

echo '================================================================'
echo '                     download ndk.zip'
echo '================================================================'
cd ~ && wget https://github.com/lzhiyong/termux-ndk/releases/download/android-ndk/android-ndk-r26b-aarch64.zip
echo '================================================================'
echo '                               unzip ndk.zip'
echo '================================================================'
cd ~ && unzip -qq android-ndk-r26b-aarch64.zip
echo '================================================================'
echo '                               tidy ndk.zip'
echo '================================================================'
cd ~ && rm android-ndk-r26b-aarch64.zip


echo '================================================================'
echo '                               set env variables'
echo '================================================================'
echo 'export ANDROID_HOME=/data/data/com.termux/files/home/android-sdk/' >> ~/../usr/etc/profile
echo 'export ANDROID_NDK_HOME=/data/data/com.termux/files/home/android-ndk-r26b/' >> ~/../usr/etc/profile
echo 'export ANDROID_NDK_ROOT=$ANDROID_NDK_HOME' >> ~/../usr/etc/profile
source ~/../usr/etc/profile


echo '================================================================'
echo '                               resolving versions'
echo '================================================================'
/data/data/com.termux/files/home/android-sdk/tools/bin/sdkmanager --sdk_root=/data/data/com.termux/files/home/android-sdk/ --uninstall "platforms;android-33"
/data/data/com.termux/files/home/android-sdk/tools/bin/sdkmanager --sdk_root=/data/data/com.termux/files/home/android-sdk/ --uninstall "platforms;android-32"


echo '================================================================'
echo '                               install vlang'
echo '================================================================'
pkg install clang libexecinfo libgc libgc-static make cmake
cd ~ && git clone https://github.com/vlang/v
cd ~ && cd v && make && ./v symlink

echo '================================================================'
echo '                               install vab'
echo '================================================================'
v install vab
v ~/.vmodules/vab
ln -s /data/data/com.termux/files/home/.vmodules/vab/vab /data/data/com.termux/files/usr/bin/


echo '================================================================'
echo '                                 complete'
echo '================================================================'
echo ''
echo 'put "source ~/../usr/etc/profile"'
echo 'and try "vab ./v/examples/2048"'
