#
# Register some URNs that we are providing for sharing.
#

set version $::openacs_bootstrap3_theme::bootstrap_version

#
# Get resource info from this package. If not locally installed, offer
# a link for download.
#
set resource_info [::openacs_bootstrap3_theme::resource_info]
set prefix        [dict get $resource_info prefix]

foreach URN [dict keys [dict get $resource_info urnMap]] {
    ns_log notice "TEST -urn $URN -resource $prefix/[dict get $resource_info urnMap $URN]"
    template::register_urn \
	-urn $URN \
	-resource $prefix/[dict get $resource_info urnMap $URN]
}
