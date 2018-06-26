# https://unix.stackexchange.com/a/20793/102771
dns_lookup() {
  local result
  if hash dscacheutil 2>/dev/null; then
    # MacOS
    result="$(dscacheutil -q host -a name "$1" | grep ip_address | head -n1 | awk '{printf $2}')"
  elif hash getent 2>/dev/null; then
    # Linux
    result="$(getent ahostsv4 "$1" | grep STREAM | awk '{print $1}')"
  else
    echo "dns_lookup: no program to lookup hostnames detected (getent, dscacheutil)" >&2
    return 1
  fi
  if [ -z "${result}" ]; then
    return 1
  else
    echo "${result}"
  fi
}

dns_resolve() {
  local lookup
  local result
  local server
  local hostname="$1"
  shift
  local rrtype="A"
  local has_dig="$(hash dig 2>/dev/null; echo $?)"
  if [ $# -gt 0 ]; then
    rrtype="$1"
    shift
  fi
  if [ "${has_dig}" -ne 0 ] && [ "$rrtype" = "A" ]; then
    # IPv4
    if hash nslookup 2>/dev/null; then
      # Alpine BusyBox
      result="$(nslookup "${hostname}" 2>&1 | grep Address | awk '{print $3}' | grep '\.' | head -n1)"
    fi
  elif [ "${has_dig}" -ne 0 ] && [ "$rrtype" = "AAAA" ]; then
    # IPv6
    if hash nslookup 2>/dev/null; then
      # Alpine BusyBox
      result="$(nslookup "${hostname}" 2>&1 | grep Address | awk '{print $3}' | grep ':' | head -n1)"
    fi
  elif [ "${has_dig}" -eq 0 ]; then
    result="$(dig +short "$rrtype" "${hostname}" | head -n1)"
  else
    echo "dns_resolve: no program to resolve DNS records detected (dig, nslookup)" >&2
    return 1
  fi
  if [ -z "${result}" ]; then
    return 1
  else
    echo "${result}"
  fi
}

# https://superuser.com/a/649561/41354
dns_reverse() {
  dig +noall +answer -x "$1" | awk '{print $(NF)}' | sed 's/\.$//'
}

dns_resolve_4() {
  dns_resolve "$1" A
}

dns_resolve_6() {
  dns_resolve "$1" AAAA
}

dns_resolve_cname() {
  dns_resolve "$1" CNAME
}

dns_resolve_mx() {
  dns_resolve "$1" MX
}

dns_resolve_naptr() {
  dns_resolve "$1" NAPTR
}

dns_resolve_ns() {
  dns_resolve "$1" NS
}

dns_resolve_ptr() {
  dns_resolve "$1" PTR
}

dns_resolve_soa() {
  dns_resolve "$1" SOA
}

dns_resolve_srv() {
  dns_resolve "$1" SRV
}

dns_resolve_txt() {
  dns_resolve "$1" TXT
}
