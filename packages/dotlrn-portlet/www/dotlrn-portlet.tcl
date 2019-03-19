#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

# dotlrn-portlet/www/dotlrn-portlet.tcl

ad_page_contract {
    The display logic for the dotrn (Group Info)  portlet

    @author Arjun Sanyal (arjun@openforce.net)
    @cvs-id $Id: dotlrn-portlet.tcl,v 1.15 2018/06/29 17:27:19 hectorr Exp $
}

array set config $cf	
set community_id $config(community_id)

set subcomm_pretty_plural [dotlrn::parameter -localize -name subcommunities_pretty_plural]
set subcomm_data [dotlrn_community::get_subcomm_chunk -community_id $community_id]

set has_subcomm_p 0
if {$subcomm_data ne ""} {
    set has_subcomm_p 1
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
