# This settings controls how the kernel behaves towards module changes at
# runtime. Setting to 1 will disable module loading at runtime.

{% if salt['pillar.get']('hardening:kernel:modules_disabled',True) %}
kernel.modules_disabled: 
 sysctl.present: 
  - value: 1
{% endif %}


# Magic Sysrq should be disabled, but can also be set to a safe value if so
# desired for physical machines. It can allow a safe reboot if the system hangs
# and is a 'cleaner' alternative to hitting the reset button.  The following
# values are permitted:
#
# * **0** - disable sysrq
# * **1** - enable sysrq completely
# * **>1** - bitmask of enabled sysrq functions:
# * **2** - control of console logging level
# * **4** - control of keyboard (SAK, unraw)
# * **8** - debugging dumps of processes etc.
# * **16** - sync command
# * **32** - remount read-only
# * **64** - signalling of processes (term, kill, oom-kill)
# * **128** - reboot/poweroff
# * **256** - nicing of all RT tasks

kernel.sysrq: 
 sysctl.present: 
  - value: 0

# Prevent core dumps with SUID. These are usually only needed by developers and
# may contain sensitive information.
fs.suid_dumpable: 
 sysctl.present: 
  - value: 0
# Stack protection through randomized VA kernel space
kernel.randomize_va_space:
 sysctl.present:
  - value: 2

