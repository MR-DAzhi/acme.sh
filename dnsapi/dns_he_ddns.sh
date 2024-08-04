#!/usr/bin/env sh
dns_he_ddns_info='Hurricane Electric HE.net DDNS
Site: dns.he.net
Docs: github.com/acmesh-official/acme.sh/wiki/dnsapi#dns_he_ddns
Options:
 HE_DDNS_KEY The DDNS key for updating the TXT record
Author: Markku Leiniö
'

HE_DDNS_URL="https://dyn.dns.he.net/nic/update"

########  Public functions #####################

#Usage: dns_he_ddns_add   _acme-challenge.www.domain.com   "XKrxpRBosdIKFzxW_CT3KLZNf6q0HG9i01zxXp5CPBs"
dns_he_ddns_add() {
  fulldomain=$1
  txtvalue=$2
  HE_DDNS_KEY="${HE_DDNS_KEY:-$(_readaccountconf_mutable HE_DDNS_KEY)}"
  if [ -z "$HE_DDNS_KEY" ]; then
    HE_DDNS_KEY=""
    _err "You didn't specify a DDNS key for accessing the TXT record in HE API."
    return 1
  fi
  #Save the DDNS key to the account conf file.
  _saveaccountconf_mutable HE_DDNS_KEY "$HE_DDNS_KEY"

  _info "Using Hurricane Electric DDNS API"
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"

  response="$(_post "hostname=$fulldomain&password=$HE_DDNS_KEY&txt=$txtvalue" "$HE_DDNS_URL")"
  _info "Response: $response"
  _contains "$response" "good" && return 0 || return 1
}

#Usage: fulldomain txtvalue
#Remove the txt record after validation.
dns_he_ddns_rm() {
  fulldomain=$1
  txtvalue=$2
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"
}
