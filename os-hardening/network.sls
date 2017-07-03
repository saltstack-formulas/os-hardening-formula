{% from "os-hardening/map.jinja" import hardening with context %}
# Only enable IP traffic forwarding, if required.
net.ipv4.ip_forward:
  sysctl.present:
    - value: {{hardening.networking.ip_forwarding}}
{% if hardening.networking.ipv6_disable %}
# Disable IPv6
net.ipv6.conf.all.disable_ipv6:
  sysctl.present:
    - value: 1

net.ipv6.conf.all.forwarding:
  sysctl.present:
    - value: 0

net.ipv6.conf.default.router_solicitations:
  sysctl.present:
    - value: 0

net.ipv6.conf.default.accept_ra_rtr_pref:
  sysctl.present:
    - value: 0

net.ipv6.conf.default.accept_ra_pinfo:
  sysctl.present:
    - value: 0

net.ipv6.conf.default.accept_ra_defrtr:
  sysctl.present:
    - value: 0

net.ipv6.conf.default.autoconf:
  sysctl.present:
    - value: 0

net.ipv6.conf.default.dad_transmits:
  sysctl.present:
    - value: 0

net.ipv6.conf.default.max_addresses:
  sysctl.present:
    - value: 1

# Ignore RAs on Ipv6
net.ipv6.conf.all.accept_ra:
  sysctl.present:
    - value: 0
{% endif %}
# Enable RFC-recommended source validation feature. It should not be used for
# routers on complex networks, but is helpful for end hosts and routers serving
# small networks.
net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 1

net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 1

# Reduce the surface on SMURF attacks. Make sure to ignore ECHO broadcasts,
# which are only required in broad network analysis.
net.ipv4.icmp_echo_ignore_broadcasts:
  sysctl.present:
    - value: 1

# There is no reason to accept bogus error responses from ICMP, so ignore them
# instead.
net.ipv4.icmp_ignore_bogus_error_responses:
  sysctl.present:
    - value: 1

# Limit the amount of traffic the system uses for ICMP.
net.ipv4.icmp_ratelimit:
  sysctl.present:
    - value: 100

# Adjust the ICMP ratelimit to include: ping, dst unreachable, source quench,
# time exceed, param problem, timestamp reply, information reply
net.ipv4.icmp_ratemask:
  sysctl.present:
    - value: 88089

# Protect against wrapping sequence numbers at gigabit speeds:
net.ipv4.tcp_timestamps:
  sysctl.present:
    - value: 0

# arp_announce - INTEGER
# Define different restriction levels for announcing the local source IP
# address from IP packets in ARP requests sent on interface:
#
# * **0** - (default) Use any local address, configured on any interface
#
# * **1** - Try to avoid local addresses that are not in the target's subnet
# for this interface. This mode is useful when target hosts reachable via this
# interface require the source IP address in ARP requests to be part of their
# logical network configured on the receiving interface. When we generate the
# request we will check all our subnets that include the target IP and will
# preserve the source address if it is from such subnet. If there is no such
# subnet we select source address according to the rules for level 2.
#
# * **2** - Always use the best local address for this target. In this mode we
# ignore the source address in the IP packet and try to select local address
# that we prefer for talks with the target host. Such local address is selected
# by looking for primary IP addresses on all our subnets on the outgoing
# interface that include the target IP address. If no suitable local address is
# found we select the first local address we have on the outgoing interface or
# on all other interfaces, with the hope we will receive reply for our request
# and even sometimes no matter the source IP address we announce.

{% if hardening.networking.arp_restricted %}
net.ipv4.conf.all.arp_ignore:
  sysctl.present:
    - value: 1
{% else %}
net.ipv4.conf.all.arp_ignore:
  sysctl.present:
    - value: 0
{% endif %}


# Define different modes for sending replies in response to received ARP
# requests that resolve local target IP addresses:
#
# * **0** - (default): reply for any local target IP address, configured on any
# interface
#
# * **1** - reply only if the target IP address is local address configured on
# the incoming interface
#
# * **2** - reply only if the target IP address is local address configured on
# the incoming interface and both with the sender's IP address are part from
# same subnet on this interface
#
# * **3** - do not reply for local addresses configured with scope host, only
# resolutions for global and link addresses are replied
#
# * **4-7** - reserved
#
# * **8** - do not reply for all local addresses

{% if hardening.networking.arp_restricted %}
net.ipv4.conf.all.arp_announce:
  sysctl.present:
    - value: 2
{% else %}
net.ipv4.conf.all.arp_announce:
  sysctl.present:
    - value: 0
{% endif %}

# RFC 1337 fix F1
net.ipv4.tcp_rfc1337:
  sysctl.present:
    - value: 1

# Syncookies is used to prevent SYN-flooding attacks.
net.ipv4.tcp_syncookies:
  sysctl.present:
    - value: 1

net.ipv4.conf.all.shared_media:
  sysctl.present:
    - value: 1

net.ipv4.conf.default.shared_media:
  sysctl.present:
    - value: 1

# Accepting source route can lead to malicious networking behavior, so disable
# it if not needed.
net.ipv4.conf.all.accept_source_route:
  sysctl.present:
    - value: 0

net.ipv6.conf.all.accept_source_route:
  sysctl.present:
    - value: 0

net.ipv4.conf.default.accept_source_route:
  sysctl.present:
    - value: 0

net.ipv6.conf.default.accept_source_route:
  sysctl.present:
    - value: 0

# Accepting redirects can lead to malicious networking behavior, so disable it
# if not needed.
net.ipv4.conf.all.accept_redirects:
  sysctl.present:
    - value: 0

net.ipv4.conf.default.accept_redirects:
  sysctl.present:
    - value: 0

net.ipv6.conf.all.accept_redirects:
  sysctl.present:
    - value: 0

net.ipv6.conf.default.accept_redirects:
  sysctl.present:
    - value: 0

net.ipv4.conf.all.secure_redirects:
  sysctl.present:
    - value: 0

net.ipv4.conf.default.secure_redirects:
  sysctl.present:
    - value: 0

# For non-routers: don't send redirects, these settings are 0
net.ipv4.conf.all.send_redirects:
  sysctl.present:
    - value: 0

net.ipv4.conf.default.send_redirects:
  sysctl.present:
    - value: 0

# log martian packets (risky, may cause DoS)
net.ipv4.conf.all.log_martians:
  sysctl.present:
    - value: 1

# Forbid Proxy ARP
net.ipv4.conf.all.proxy_arp:
  sysctl.present:
    - value: 0

net.ipv4.conf.default.proxy_arp:
  sysctl.present:
    - value: 0

# Forbid BOOTP Relaying
net.ipv4.conf.all.bootp_relay:
  sysctl.present:
    - value: 0

net.ipv4.conf.default.bootp_relay:
  sysctl.present:
    - value: 0

# Enable RP Filtering
net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 1

net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 1
