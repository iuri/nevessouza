--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License foreign key more
--  details.
--

--
-- The New Portal Package
--
-- @author Arjun Sanyal (arjun@openforce.net)
-- @version $Id: objects-drop.sql,v 1.3 2002/08/09 20:56:28 yon Exp $
--

-- XXX - FIX ME Do this the "right way"

delete
from acs_permissions
where object_id in (select object_id
                    from acs_objects
                    where object_type in ('portal_page', 'portal', 'portal_element_theme','portal_layout', 'portal_datasource'));

delete
from acs_permissions
where object_id in (select package_id
                    from apm_packages
                    where package_key = 'portal');

delete
from acs_objects
where object_type in ('portal_page', 'portal', 'portal_element_theme','portal_layout', 'portal_datasource');

select acs_object_type__drop_type('portal','f');
select acs_object_type__drop_type('portal_page','f');
select acs_object_type__drop_type('portal_element_theme','f');
select acs_object_type__drop_type('portal_layout','f');
select acs_object_type__drop_type('portal_datasource','f');
