ad_library {

    Notification Intervals Utilities.

    @creation-date 2002-05-24
    @author Ben Adida <ben@openforce.biz>
    @cvs-id $Id: interval-procs.tcl,v 1.4.24.1 2015/09/12 11:06:45 gustafn Exp $

}

namespace eval notification::interval {

    ad_proc -public get_id_from_name {
        -name:required
    } {

        Returns the interval_id for a given interval_name

        @param name The name of interval (weekly, etc)
        @author Don Baccus (dhogaza@pacifier.com)

    } {

        return [db_string get_interval_id {}]

    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
