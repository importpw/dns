# dns

DNS resolution functions for shell scripting.


## API

### `dns_lookup $hostname`

Performs a DNS lookup for `$hostname`. The difference between this function and
`dns_resolve` is that this version uses the operating system native DNS resolution
mechanism, so hostnames like `localhost` resolve as expected.

```bash
#!/usr/bin/env import
import dns

# Resolve `localhost` to an IP address
dns_lookup localhost
```

### `dns_resolve $hostname [$record_type = "A"]`

Performs a DNS lookup for `$hostname`. This function performs a DNS query,
so an actual DNS record needs to exist. `$record_type` may be specified for the
type of DNS record to query for.

```bash
#!/usr/bin/env import
import dns

# Query the `A` records
dns_resolve import.pw

# Query the `MX` records
dns_resolve import.pw MX
```

### `dns_reverse $ip`

Performs a reverse DNS lookup on IP address `$ip`.

```bash
#!/usr/bin/env import
import dns

dns_reverse 8.8.8.8
```
