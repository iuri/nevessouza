# packages/dotlrn/www/help/help-master.tcl

ad_page_contract {
    
    help master template
    
    @author Emmanuelle Raffenne (eraffenne@gmail.com)
    @creation-date 2007-10-12
    @cvs-id $Id: help-master.tcl,v 1.2 2017/08/07 23:48:09 gustafn Exp $
} {
    
} -properties {
} -validate {
} -errors {
}

template::head::add_css -href "/resources/dotlrn/help.css" -media "screen"

set doc(title) $title

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
