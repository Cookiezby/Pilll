#!/bin/bash
set -e
set -o pipefail


export ANDROID_KEYSTORE_PASSWORD=$BITRISEIO_ANDROID_KEYSTORE_PASSWORD
export ANDROID_KEYSTORE_PRIVATE_KEY_PASSWORD=$BITRISEIO_ANDROID_KEYSTORE_PRIVATE_KEY_PASSWORD
export ANDROID_KEYSTORE_ALIAS=$BITRISEIO_ANDROID_KEYSTORE_ALIAS
export ANDROID_KEYSTORE_PATH=$BITRISEIO_ANDROID_KEYSTORE_PATH
