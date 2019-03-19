ad_page_contract {

    Deletes a category synonym.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id: synonym-delete-2.tcl,v 1.7 2018/06/29 17:27:18 hectorr Exp $
} {
    synonym_id:naturalnum,multiple
    category_id:naturalnum,notnull
    tree_id:naturalnum,notnull
    {locale ""}
    object_id:naturalnum,optional
    ctx_id:naturalnum,optional
}

set user_id [auth::require_login]
permission::require_permission -object_id $tree_id -privilege category_tree_write

db_transaction {
    foreach synonym_id [db_list check_synonyms_for_delete ""] {
	category_synonym::delete $synonym_id
    }
} on_error {
    ad_return_complaint 1 {{Error deleting category synonym.}}
    return
}

ad_returnredirect [export_vars -no_empty -base synonyms-view {category_id tree_id locale object_id ctx_id}]
ad_script_abort

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
