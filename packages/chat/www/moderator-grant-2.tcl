#/chat/www/moderator-grant-2.tcl
ad_page_contract {

    Add moderator to a room.

    @author David Dao (ddao@arsdigita.com)
    @creation-date November 17, 2000
    @cvs-id $Id: moderator-grant-2.tcl,v 1.4.2.1 2019/02/14 16:15:01 gustafn Exp $
} {
    room_id:naturalnum,notnull
    party_id:naturalnum,notnull
}

permission::require_permission -object_id $room_id -privilege chat_moderator_grant

chat_moderator_grant $room_id $party_id

ad_returnredirect "room?room_id=$room_id"

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
