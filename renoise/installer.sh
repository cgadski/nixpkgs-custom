#!/bin/sh

echo "beginning modified renoise installer script!"

#echo "Fixing file permissions..."
# (woraround for regged version downloads which are tared with 777 on the server)
#find $SCRIPT_PATH -type d -exec chmod 755 {} \; && \
  #find $SCRIPT_PATH -type f -exec chmod 644 {} \; && \
  #find $SCRIPT_PATH -type f -name "*.sh" -exec chmod 755 {} \; && \
  #find $SCRIPT_PATH/Installer/xdg-utils -type f -name "xdg-*" -exec chmod 755 {} \; && \
  #chmod 755 $SCRIPT_PATH/renoise && \
  #chmod 755 $SCRIPT_PATH/Resources/AudioPluginServer_x86 && \
  #chmod 755 $SCRIPT_PATH/Resources/AudioPluginServer_x86_64 

