#!/bin/sh
eval "`curl -sfLS import.pw`"
import "import.pw/assert@2.1.1"
source ./dns.sh


# dns_lookup
assert_exit 0 dns_lookup 127.0.0.1
assert_equal "$(dns_lookup 8.8.8.8)" 8.8.8.8
assert_equal "$(dns_lookup 127.0.0.1)" 127.0.0.1

assert_exit 0 dns_lookup 8.8.8.8
assert_exit 1 dns_lookup thisisadomainnamethatdefinitelydoesnotexitwhattt.com

echo Looking up www.google.com
dns_lookup www.google.com


# dns_resolve
assert_exit 0 dns_resolve www.google.com

echo Resolving www.google.com
dns_resolve www.google.com
dns_resolve AAAA www.google.com
