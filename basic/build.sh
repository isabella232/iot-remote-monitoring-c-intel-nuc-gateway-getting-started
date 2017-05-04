#!/bin/sh
build_root=$(cd "$(dirname "$0")" && pwd)
build_dir="$build_root"/build
output_name=sensor2remotemonitoring 

rm -f "$build_dir"/"$output_name"
mkdir -p "$build_dir"

# Check for Azure IoT Gateway SDK headers
if [ ! -f /usr/include/azureiot/gateway.h ]; then
    echo Gateway SDK headers not found. Please make sure that the azure-iot-gateway-sdk-dev package is installed.
    exit 1
fi

echo ---------- Building the $output_name Gateway SDK module ----------
gcc -c -fPIC -std=c99 src/remote_monitoring.c -I/usr/include/azureiot -I/usr/include/azureiot/modules/common -Iinc -o "$build_dir"/remote_monitoring.o
[ $? -eq 0 ] || exit $?
gcc -shared -Wl,-soname,lib"$output_name".so -o "$build_dir"/lib"$output_name".so "$build_dir"/remote_monitoring.o -lgateway -laziotsharedutil
[ $? -eq 0 ] || exit $?

rm -f "$build_dir"/remote_monitoring.o

echo Finished Successfully

echo Output can be found in "$build_dir"

sleep 1 # wait for everything finishing