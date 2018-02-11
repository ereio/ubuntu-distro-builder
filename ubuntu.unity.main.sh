#!/bin/bash
echo "List of those that came before you:"
echo "9) mahi (XPS 15) x10"
echo "8) arya (MSI Ghost)"
echo "7) Eura (MSI Desktop)"
echo "6) Cleo (MSI Ghost)"
echo "5) Turi (Bad Arch USB)"
echo "4) Libo (temp)"
echo "3) Ayla (Ubuntu)"
echo "2) Rhea (Macbook)"
echo "1) Eve  (Macbook)"
echo
echo "## PRE INSTALL TEMP CONFIGS ##"
gsettings set org.gnome.desktop.session idle-delay 0

file_type=".png"
background="/home/$USER/Dropbox/pictures/wallpapers/titan-souls$file_type"

echo "## LIBRARY UPDATES ##"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get install -y nvidia-current
sudo apt-get -y update
sudo apt-get -y upgrade

echo "## CONFIGURING DROPBOX ##"
sudo wget -O /tmp/dropbox.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb"
sudo apt install -y /tmp/dropbox.deb
nautilus -q
dropbox start -i &

sleep 20;
nautilus -q
echo "## WAITING FOR DROPBOX PICTURE FOLDER ##"
until dropbox filestatus /home/$USER/Dropbox | grep -c "syncing" | grep -m 1 "1"; do sleep 1; done
sleep 60;
cd ~/Dropbox
#all_dropbox_assets=$(dropbox filestatus -l)
all_dropbox_assets=".AndroidStudio2.3  .gitconfig info .atom .netrc  keepass .bashrc .profile applications os-images .config development pictures documents public emulation"
dropbox exclude add $all_dropbox_assets
dropbox exclude remove pictures
until (test -f $background; echo $?) | grep -m 1 "0"; do sleep 5; done
nautilus -q

echo "## ADD PPAs ##"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
echo | sudo apt-add-repository ppa:tista/adapta
echo | sudo add-apt-repository ppa:webupd8team/nemo
echo | sudo apt-add-repository ppa:noobslab/icons
echo | sudo apt-add-repository ppa:noobslab/themes
echo | sudo apt-add-repository ppa:webupd8team/java
echo | sudo apt-add-repository ppa:jtaylor/keepass
echo | sudo apt-add-repository ppa:webupd8team/atom
sudo apt-get update

echo "###### STYLING ######"
# CHANGE DESKTOP NAME IN UNITY
sudo echo "msgid \"Ubuntu Desktop\"" > /tmp/desktop_name.po
sudo echo "msgstr \"$HOSTNAME\"" >> /tmp/desktop_name.po
cd /usr/share/locale/en/LC_MESSAGES
sudo msgfmt -o unity.mo /tmp/desktop_name.po

sudo apt install -y numix-gtk-theme
sudo apt install -y arc-theme
sudo apt install -y arc-icons
sudo apt install -y adapta-gtk-theme

sudo cp $background /usr/share/backgrounds/background$file_type
sudo cp $background /usr/share/backgrounds/warty-final-ubuntu$file_type

gsettings set com.canonical.unity-greeter draw-user-backgrounds true
gsettings set org.gnome.desktop.background show-desktop-icons true
gsettings set com.canonical.unity-greeter background $background
gsettings set org.gnome.desktop.background picture-uri file://$background

gsettings set org.gnome.desktop.wm.preferences theme 'Arc-Darker'
gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Darker'
gsettings set org.gnome.desktop.interface icon-theme 'Arc-Icons'

gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ panel-opacity 0
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-opacity 0.5
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-hide-mode 1
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ icon-size 26

gsettings set org.compiz.grid:/org/compiz/profiles/unity/plugins/grid/ animation-duration 125
gsettings set org.compiz.grid:/org/compiz/profiles/unity/plugins/grid/ fill-color '#34e2e24f'
gsettings set org.compiz.grid:/org/compiz/profiles/unity/plugins/grid/ outline-color '#34e2e24f'
gsettings set org.compiz.expo:/org/compiz/profiles/unity/plugins/expo/ selected-color '#34e2e24f'

gsettings set org.gnome.desktop.interface document-font-name 'Sans 9'
gsettings set org.gnome.desktop.interface font-name 'Ubuntu Regular 9'
gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 10'
gsettings set org.gnome.nautilus.desktop font 'Ubuntu Medium 10'

gsettings set com.canonical.unity-greeter logo ''

# GNOME TERMINAL
# https://askubuntu.com/questions/731774/how-to-change-gnome-terminal-profile-preferences-using-dconf-or-gsettings
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false

default_profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
default_profile=${default_profile#"'"} # remove leading and trailing single quotes
default_profile=${default_profile%"'"} # remove leading and trailing single quotes
default_profile_path="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$default_profile/"
PALETTE="['rgb(46,52,54)', 'rgb(204,0,0)', 'rgb(78,154,6)', 'rgb(196,160,0)', 'rgb(52,101,164)', 'rgb(117,80,123)', 'rgb(6,152,154)', 'rgb(211,215,207)', 'rgb(85,87,83)', 'rgb(239,41,41)', 'rgb(138,226,52)', 'rgb(252,233,79)', 'rgb(114,159,207)', 'rgb(173,127,168)', 'rgb(52,226,226)', 'rgb(238,238,236)']"

gsettings set $default_profile_path visible-name 'Default-Generated'
gsettings set $default_profile_path background-color 'rgb(0,43,54)'
gsettings set $default_profile_path foreground-color 'rgb(52,226,226)'
gsettings set $default_profile_path use-transparent-background true
gsettings set $default_profile_path background-transparency-percent 18
gsettings set $default_profile_path palette "$PALETTE"
gsettings set $default_profile_path use-theme-colors false
gsettings set $default_profile_path use-theme-transparency false

echo "## REFRESHING UNITY ##"
until dropbox filestatus /home/$USER/Dropbox | grep -c "syncing" | grep -m 1 "0"; do sleep 1; done
sleep 5;
nautilus -q
nautilus
#nohup unity &> /dev/null & disown

echo "## PRESET DEBCONFS ##"
echo macchanger	macchanger/automatically_run	boolean	false | sudo debconf-set-selections
echo wireshark-common	wireshark-common/install-setuid	boolean	true | sudo debconf-set-selections
echo oracle-java8-installer	shared/accepted-oracle-license-v1-1	boolean	true | sudo debconf-set-selections
echo postfix	postfix/main_mailer_type	select	No configuration | sudo debconf-set-selections

echo "## MAIN INSTALLS (NO CONF) ##"
sudo apt-get install -y debconf-utils
sudo apt-get install -y vim
sudo apt-get install -y fortune
sudo apt-get install -y chromium-browser
sudo apt-get install -y nemo nemo-fileroller
sudo apt-get install -y deluge
sudo apt-get install -y gimp
sudo apt-get install -y steam
sudo apt-get install -y vlc
sudo apt-get install -y android-tools-adb
sudo apt-get install -y lm-sensors
sudo apt-get install -y tlp
sudo apt-get install -y inkscape
sudo apt-get install -y virtualbox
sudo apt-get install -y zipalign
sudo apt-get install -y redshift
sudo apt-get install -y gtk-redshift
sudo apt-get install -y grubcustomizer
sudo apt-get install -y unzip
sudo apt-get install -y wireshark
sudo apt-get install -y macchanger
sudo apt-get install -y git

echo "## LIBRARY INSTALLS (CONF REQ) ##"
# set debconf
sudo apt install -y oracle-java8-installer
sudo apt install -y oracle-java8-set-default
sudo apt install -y keepass2
sudo apt install -y spotify-client
sudo apt install -y atom

echo "## ATOM EXTENSIONS ##"
apm install Sublime-Style-Column-Selection
apm install activate-power-mode
apm install atom-beautify
apm install minimap
apm install atom-typescript
apm install busy-signal
apm install file-icons
apm install git-plus
apm install linter
apm install linter-ui-default
apm install pigments
apm install react
apm install todo-show
apm install atom-ide-ui
apm install ide-typescript

echo "## NODE AND NPM ##"
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt install -y nodejs

echo "## NPM GLOBAL INSTALLS ##"
sudo npm install -g bower
sudo npm install -g create-react-app
sudo npm install -g create-react-native-app
sudo npm install -g electron
sudo npm install -g react-native-cli
sudo npm install -y npm@latest -g
sudo npm install -g electron-packager
sudo apt install -y nodejs-legacy

echo "## ANDROID STUDIO DEPENDENCIES ##"
sudo apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386

echo "## DEB INSTALLS AND DOWNLOADS ##"
sudo mkdir /tmp/debs

#chrome dependencies
sudo apt-get install -y libxss1 libappindicator1 libindicator7
sudo wget -O /tmp/debs/chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo dpkg -i /tmp/debs/chrome.deb

sudo wget -O /tmp/debs/slack.deb "https://downloads.slack-edge.com/linux_releases/slack-desktop-2.7.1-amd64.deb"
sudo apt install -y /tmp/debs/slack.deb

wget https://dl.pstmn.io/download/latest/linux64 -O /tmp/debs/postman.tar.gz
sudo tar -xzf /tmp/debs/postman.tar.gz -C /opt
sudo ln -s /opt/Postman/Postman /usr/bin/postman
cat > ~/.local/share/applications/postman.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=postman
Icon=/opt/Postman/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL

sudo wget https://installers.privateinternetaccess.com/download/pia-v72-installer-linux.tar.gz -O /tmp/debs/pia.tar.gz
sudo tar -xzf /tmp/debs/pia.tar.gz -C /home/$USER/Downloads
echo | rm /home/$USER/Downloads/pia-v72-installer-linux.sh

sudo wget -O /tmp/debs/firefox-dev.tar.bz2 "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
sudo tar -xvf /tmp/debs/firefox-dev.tar.bz2 -C /opt/firefox
sudo ln -s /opt/firefox/firefox-bin /usr/bin/firefox

sudo wget -O /tmp/debs/syncthing.tar.gz "https://github.com/syncthing/syncthing/releases/download/v0.14.40/syncthing-linux-amd64-v0.14.40.tar.gz"
sudo tar -xvf /tmp/debs/syncthing.tar.gz -C /opt/syncthing
sudo ln -s /opt/syncthing/syncthing /usr/bin/syncthing

curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
sudo apt update && sudo apt install signal-desktop

cat > ~/.local/share/applications/firefox.desktop <<EOL
[Desktop Entry]
Name=Firefox Developer
GenericName=Firefox Developer Edition
Exec=/opt/firefox/firefox
Terminal=false
Icon=/opt/firefox/browser/icons/mozicon128.png
Type=Application
Categories=Application;Network;X-Developer;
Comment=Firefox Developer Edition Web Browser.
EOL

cat > ~/.local/share/applications/signal.desktop <<EOL
[Desktop Entry]
Name=Signal
GenericName=Signal
Exec=NODE_ENV=production ~/apps/Sign
Terminal=false
Icon=/opt/firefox/browser/icons/mozicon128.png
Type=Application
Categories=Application;Network;X-Developer;
Comment=Firefox Developer Edition Web Browser.
EOL

sudo wget -O /tmp/debs/android-studio.zip "https://dl.google.com/dl/android/studio/ide-zips/3.0.0.18/android-studio-ide-171.4408382-linux.zip"
sudo unzip /tmp/debs/android-studio.zip -d /opt
sudo ln -s /opt/android-studio/bin/studio.sh /usr/bin/android-studio

sudo wget -O /tmp/debs/unity-editor.deb "http://beta.unity3d.com/download/2b451a7da81d/./unity-editor_amd64-2017.2.0xb6Linux.deb"
sudo apt install -y /tmp/debs/unity-editor.deb
sudo rm -r /tmp/debs

echo "##### POST INSTALL THEMING #####"
gsettings set com.canonical.Unity.Launcher favorites "['application://nemo.desktop', 'application://org.gnome.Terminal.desktop', 'application://gnome-system-monitor.desktop', 'application://google-chrome.desktop', 'application://chromium-browser.desktop', 'application://spotify.desktop', 'application://atom.desktop', 'application://tools_jar.desktop', 'application://chrome-fhbjgbiflinjbdggehcddcbncdddomop-Default.desktop', 'application://unity-editor.desktop', 'application://deluge.desktop', 'application://gimp.desktop', 'application://inkscape.desktop',  'application://virtualbox.desktop', 'application://slack.desktop', 'application://wireshark.desktop', 'application://steam.desktop', 'application://keepass2.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices'] "

echo "## SETTINGS ##"
gsettings set org.gnome.gnome-screenshot last-save-directory 'file:///home/$USER/Downloads'

gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 1
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2

gsettings set org.gnome.desktop.media-handling automount-open false
gsettings set org.gnome.desktop.media-handling automount false
gsettings set com.canonical.unity-greeter background-color '#34E2E2'

gsettings set org.cinnamon.desktop.keybindings.wm push-snap-up "['<Control><Super>Up']"
gsettings set org.cinnamon.desktop.keybindings.wm push-snap-down "['<Control><Super>Down']"
gsettings set org.cinnamon.desktop.keybindings.wm push-snap-left "['<Control><Super>Left']"
gsettings set org.cinnamon.desktop.keybindings.wm push-snap-right "['<Control><Super>Right']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift><Super>space']"

gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.nemo.preferences default-folder-viewer 'list-view'

xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion'

echo "## REINIT DROPBOX EXCLUDED FOLDERS ##"
cd ~/Dropbox
dropbox exclude remove $all_dropbox_assets
until dropbox filestatus /home/$USER/Dropbox | grep -c "syncing" | grep -m 1 "1"; do sleep 1; done

echo "## WAITING FOR DROPBOX TO FINISH SYNCING ##"
until dropbox filestatus /home/$USER/Dropbox | grep -c "syncing" | grep -m 1 "0"; do sleep 5; done

echo "## HOME FOLDER SETUP ##"
#rm -r /home/$USER/Documents
#rm -r /home/$USER/Music
#rm -r /home/$USER/Pictures
##rm -r /home/$USER/Videos
#rm -r /home/$USER/.atom
#rm -r /home/$USER/.AndroidStudio2.3

#ln -s /home/$USER/Dropbox/Documents /home/$USER/
#ln -s /home/$USER/Dropbox/Music /home/$USER/
#ln -s /home/$USER/Dropbox/Pictures /home/$USER/
#ln -s /home/$USER/Dropbox/Videos /home/$USER/#

#ln -s /home/$USER/Dropbox/Keepass /home/$USER/
#ln -s /home/$USER/Dropbox/Development /home/$USER/
#ln -s /home/$USER/Dropbox/Info /home/$USER/
#ln -s /home/$USER/Dropbox/Public /home/$USER/

#ln -s /home/$USER/Dropbox/.atom /home/$USER/
#ln -s /home/$USER/Dropbox/.AndroidStudio2.3 /home/$USER/

#cp /home/$USER/Dropbox/.* /home/$USER

echo "## SYSTEM SETTINGS ##"
sudo touch /etc/rc.local
cat > /etc/rc.local <<EOL
sudo iptables -t mangle -A POSTROUTING -j TTL --ttl-set 65
sudo prime-select intel
sudo tlp start
exit 0
EOL

sudo apt autoremove
sudo update-initramfs -u
echo "IT'S COMPLETED!!!! :)"

echo "PLZ REBOOT NOW"
echo "SET HOTKEYS FOR SWAPING WORKSPACES / FIND COMMAND"
echo "GO UPDATE UNITY EDITOR https://forum.unity3d.com/threads/unity-on-linux-release-notes-and-known-issues.350256/"
sudo shutdown -r +5 "Linux will restart in 5 minutes. Please save your work."

# ------------------------------------- END AUTO ------------------------------------------

#------ Security Tools ------
# sudo apt install proxychains
# sudo apt install macchanger

#-------- Mongo -------------
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
# echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
# sudo apt-get update
# sudo apt-get install -y mongodb-org

# sudo cp ~/eclipse/java-neon/eclipse/icon.xpm /usr/share/pixmaps/eclipse.xpm
