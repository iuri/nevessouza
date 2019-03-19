ad_library {

    initialization for bulk-mail module

    @author yon (yon@openforce.net)
    @creation-date 2002-05-07
    @cvs-id $Id: bulk-mail-init.tcl,v 1.5 2017/08/07 23:48:04 gustafn Exp $

}

# default interval is 1 minute
ad_schedule_proc -thread t 60 bulk_mail::sweep
nsv_set bulk_mail_sweep bulk_mail_sweep 0

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
