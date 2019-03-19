ad_page_contract { 
    Main category display page 
    @author Jeff Davis (davis@xarg.net)
    @cvs-id $Id: list-categories.tcl,v 1.3 2017/08/07 23:48:11 gustafn Exp $
} {
    {cat:trim,integer {}}
    {orderby:token "object_title"}
}

set cat_name [category::get_names $cat]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
