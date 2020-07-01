# ==============================================
#     RETURN IF NOT INTERACTIVE: use
#     if you override builtin commands
# ==============================================
[ -z "$PS1" ] && return



# ==============================================
#     PLUGINS
# ==============================================
plugins=(
  brew
  git
  mvn
  node
  npm
  osx
  svn
  z
  wd
  chucknorris
)


# ==============================================
#     POWERLINE PROMPT
# ==============================================
ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_PROMPT_ON_NEWLINE=false
POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  root_indicator
  dir
  vcs
)

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
 status
 time
)

POWERLEVEL9K_VCS_GIT_ICON=''
POWERLEVEL9K_VCS_STAGED_ICON='\u00b1'

POWERLEVEL9K_VCS_UNSTAGED_ICON='\u00b1'
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='\u2193'
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='\u2191'

POWERLEVEL9K_TIME_FORMAT="%D{\uf017 %I:%M \uf073 %m/%d}"


# ==============================================
#     OH-MY-ZSH
# ==============================================
ZSH_DISABLE_COMPFIX=true
export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh


# ==============================================
#     LOAD SCRIPTS
# ==============================================
#WORK_COMPUTER=LIBP45P-18293WL
#HOME_COMPUTER=Home-MBP.local

# java 7/8/9 toggle
if [ -f ~/zshConfig/.javatoggle ]; then
  source ~/zshConfig/.javatoggle
else
  print "Java toggle not loaded!"
fi

# aliases
if [ -f ~/zshConfig/.aliasconfig ]; then
  source ~/zshConfig/.aliasconfig
else
  print "Aliases not loaded!"
fi

# functions
if [ -f ~/zshConfig/.functions ]; then
	source ~/zshConfig/.functions
else
	print "Functions not loaded!"
fi

# mavenconfig
#if [ -f ~/zshConfig/.mavenconfig ]; then
 # source ~/zshConfig/.mavenconfig
#else
 # print "Mavenconfig not loaded! Loading from bash profile"
 # source ~/.bash_profile
#fi

COMPLETION_WAITING_DOTS="true"  # Display red dots while waiting for completion.


# ==============================================
#     HOOK FUNCTIONS
# ==============================================
chpwd() { ls }

# ==============================================
#     PATH VARIABLES & OTHER SETTINGS
# ==============================================
export SPRING PROFILES_ACTIVE=local
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home/
export PATH=$PATH:/Users/rumsw3/config/apache-maven-3.6.2/bin



# Local proxy address defined in SquidMan
LOCAL_PROXY_ADDR=http://localhost:8585
# --- ProxyOff ----
# Turn off proxy settings for Squidman.
proxyOff() {
  echo 'Setting up proxyless env...'
  git config --global --unset http.proxy
  git config --global --unset https.proxy
  npm config rm proxy
  npm config rm https-proxy
  unset HTTP_PROXY
  unset HTTPS_PROXY
  unset ALL_PROXY
  unset http_proxy
  unset https_proxy
  unset all_proxy
  echo '' > ~/.curlrc
  echo '' > ~/.wgetrc
  sudo networksetup -setautoproxystate "Wi-Fi" off
  # Quit SquidMan
  osascript -e 'quit app "SquidMan"'
 
 
  # Detects all network hardware & creates services for all installed network hardware
  /usr/sbin/networksetup -detectnewhardware
 
  IFS=$'\n'
 
  #Loops through the list of network services
  for i in $(/usr/sbin/networksetup -listallnetworkservices | tail +2 );
 
    do 
       
      # Turn off auto proxy
      /usr/sbin/networksetup -setautoproxystate "$i" off
      echo "Turned off auto proxy for interface $i"
     
    done
 
  unset IFS
 
  echo "Auto proxy for all interfaces turned off"
}
 
# --- ProxyOn ---
# Turn on proxy settings for Squidman.
 
proxyOn() {
  # HARDCODED VALUES ARE SET HERE
  autoProxyURL="http://pac.lfg.com/pac"
 
  echo 'Setting up proxy env...'
  sudo networksetup -setautoproxyurl "Wi-Fi" $autoProxyURL
  export HTTP_PROXY=$LOCAL_PROXY_ADDR
  export HTTPS_PROXY=$LOCAL_PROXY_ADDR
  export ALL_PROXY=$LOCAL_PROXY_ADDR
  export http_proxy=$LOCAL_PROXY_ADDR
  export https_proxy=$LOCAL_PROXY_ADDR
  export all_proxy=$LOCAL_PROXY_ADDR
  echo 'proxy='$LOCAL_PROXY_ADDR > ~/.curlrc
  echo 'use_proxy=yes' > ~/.wgetrc
  echo 'http_proxy='$LOCAL_PROXY_ADDR >> ~/.wgetrc
  echo 'https_proxy='$LOCAL_PROXY_ADDR >> ~/.wgetrc
  git config --global http.proxy $LOCAL_PROXY_ADDR
  git config --global https.proxy $LOCAL_PROXY_ADDR
  npm config set proxy $LOCAL_PROXY_ADDR
  npm config set https-proxy $LOCAL_PROXY_ADDR
  sudo networksetup -setautoproxystate "Wi-Fi" on
  # Open SquidMan
  open -a SquidMan
 
 
  # CHECK TO SEE IF A VALUE WAS PASSED FOR $4, AND IF SO, ASSIGN IT
  if [ "$4" != "" ] && [ "$autoProxyURL" == "" ]; then
  autoProxyURL=$4
  fi
 
  # Detects all network hardware & creates services for all installed network hardware
  /usr/sbin/networksetup -detectnewhardware
 
  IFS=$'\n'
 
          #Loops through the list of network services
          for i in $(networksetup -listallnetworkservices | tail +2 );
          do
           
                  # Get a list of all services
                  autoProxyURLLocal=`/usr/sbin/networksetup -getautoproxyurl "$i" | head -1 | cut -c 6-`
                   
                  # Echo's the name of any matching services & the autoproxyURL's set
                  echo "$i Proxy set to $autoProxyURLLocal"
           
                  # If the value returned of $autoProxyURLLocal does not match the value of $autoProxyURL for the interface $i, change it.
                  if [[ $autoProxyURLLocal != $autoProxyURL ]]; then
                          /usr/sbin/networksetup -setautoproxyurl $i $autoProxyURL
                          echo "Set auto proxy for $i to $autoProxyURL"
                  fi
                   
                  # Enable auto proxy once set
                  /usr/sbin/networksetup -setautoproxystate "$i" on
                  echo "Turned on auto proxy for $i"
           
          done
 
  unset IFS
 
  # Echo that we're done
  echo "Auto proxy present, correct & enabled for all interfaces"
 
}


export EDITOR='vim'
  export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
