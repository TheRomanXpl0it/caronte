#!/bin/sh

set -e

# Edit
VM_IP=$1

mkdir -p /tmp/vm_pcaps/ || true
cd /tmp/vm_pcaps/

while true
do
    echo Starting
    date

    scp -r root@$VM_IP:/root/pcaps /tmp/vm_pcaps
    for pcap in pcaps/service*/*.pcap
    do
        echo Uploading $pcap
        curl -X POST "http://localhost:3333/api/pcap/upload" \
            -H "Content-Type: multipart/form-data" \
            -F "file=@$pcap" \
            -F "flush_all=false" && echo '' && \
        ssh root@$VM_IP rm -f /root/$pcap
    done
    rm -f pcaps/service*/*.pcap
    echo Sleeping
    sleep 60
done
