# $Id: index.tcl,v 1.5 2018/01/05 22:40:56 gustafn Exp $
# user try to play with the URL and get the directory structure instead of a file

ad_returnredirect [subsite::get_element -element url]
ad_script_abort

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
