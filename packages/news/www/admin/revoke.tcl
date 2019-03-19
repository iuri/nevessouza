# /packages/news/www/admin/revoke.tcl

ad_page_contract {

    This page allows the News Admin to revoke one or many news item.
    No intermediate page is shown.

    @author Stefan Deusch (stefan@arsdigita.com)
    @creation-date  2000-12-20
    @cvs-id $Id: revoke.tcl,v 1.7 2018/02/02 00:17:02 gustafn Exp $

} {
    item_id:naturalnum,notnull
    {revision_id:integer ""}
} 


db_exec_plsql news_item_revoke {}

ad_returnredirect "item?item_id=$item_id"
ad_script_abort

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
