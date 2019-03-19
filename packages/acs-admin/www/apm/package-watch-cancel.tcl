ad_page_contract {
    Cancels all watches in given package.

    @author Peter Marklund
    @cvs-id $Id: package-watch-cancel.tcl,v 1.4 2018/02/02 00:04:50 gustafn Exp $
} {
    package_key:token
    {return_url:localurl "index"}
} 

apm_cancel_all_watches $package_key

ad_returnredirect $return_url
ad_script_abort

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
