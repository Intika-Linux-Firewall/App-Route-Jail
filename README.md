# force_so_mark
Tweaks to force application-specific routing on linux

Full usage pattern to change default route and name servers for a specific program, is the following:

```
ip rule add fwmark 10 table 100
ip route add default gw 192.168.2.1 table 100
echo "nameserver 192.168.2.1" > /tmp/resolv.conf.2
newns sh -c "mount -n --bind /tmp/resolv.conf.2 /etc/resolv.conf; MARK=10 LD_PRELOAD=mark.so /bin/wget http://example.com"
```

this will launch wget with default gateway set to `192.168.2.1` and default nameserver set to `192.168.2.1`
