#/chat/www/user-ban-2.tcl
ad_page_contract {

    Ban user.

    @author David Dao (ddao@arsdigita.com)
    @creation-date November 22, 2000
    @cvs-id $Id: user-ban-2.tcl,v 1.5.2.1 2019/02/14 16:15:01 gustafn Exp $
} {
    room_id:naturalnum,notnull
    party_id:naturalnum,notnull
}

permission::require_permission -object_id $room_id -privilege chat_user_ban

chat_user_ban $room_id $party_id

ad_returnredirect "room?room_id=$room_id"

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
