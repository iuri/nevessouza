# /packages/general-comments/www/url-add-2.tcl

ad_page_contract {
    Inserts a URL for object_id into the database
    
    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id: url-add-2.tcl,v 1.8 2018/05/01 08:49:35 gustafn Exp $
} {
    attach_id:naturalnum,notnull
    parent_id:naturalnum,notnull
    label:notnull
    url:notnull
    { return_url:localurl {} }
} -validate {
    allow_link_attachments {
        set allow_links_p [parameter::get -parameter AllowLinkAttachmentsP -default {t}]
        if { $allow_links_p != "t" } {
            ad_complain "[_ general-comments.lt_Attaching_links_to_co]"
        }
    }
}

# authenticate the user
set user_id [ad_conn user_id]

# check to see if the user can add an attachment
permission::require_permission -object_id $parent_id -privilege write

# insert the url into database 
set creation_ip [ad_conn peeraddr]
set name "extlink_$attach_id"
db_exec_plsql insert_comment {
    begin
        :1 := content_extlink.new (
                name            => :name,
                url             => :url,
                label           => :label,
                parent_id       => :parent_id,
                extlink_id      => :attach_id,
                creation_user   => :user_id,
                creation_ip     => :creation_ip
         );
    end;
}

ad_returnredirect [export_vars -base view-comment {{comment_id $parent_id} return_url}]







# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
