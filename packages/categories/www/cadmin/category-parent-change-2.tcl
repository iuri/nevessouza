ad_page_contract {

    Changes the parent category of a category.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id: category-parent-change-2.tcl,v 1.6.2.1 2019/02/14 16:15:01 gustafn Exp $
} {
    tree_id:naturalnum,notnull
    category_id:naturalnum,notnull
    {parent_id:naturalnum,optional ""}
    {locale ""}
    object_id:naturalnum,optional
    ctx_id:naturalnum,optional
}

permission::require_permission -object_id $tree_id -privilege category_tree_write

category::change_parent -tree_id $tree_id -category_id $category_id -parent_id $parent_id

ad_returnredirect [export_vars -no_empty -base tree-view {tree_id locale object_id ctx_id}]
ad_script_abort

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
