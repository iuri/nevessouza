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
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- create the dotLRN communities model
--
-- @author Ben Adida (ben@openforce.net)
-- @author yon (yon@openforce.net
-- @author arjun (arjun@openforce.net)
-- @creation-date September 20th, 2001 (redone)
-- @version $Id: communities-create.sql,v 1.14 2006/08/08 21:26:21 donb Exp $
--

create table dotlrn_community_types (
    community_type              constraint dotlrn_ct_community_type_fk
                                references group_types (group_type)
                                constraint dotlrn_community_types_pk
                                primary key,
    supertype                   constraint dotlrn_ct_supertype_fk
                                references dotlrn_community_types (community_type),
    pretty_name                 varchar2(100)
                                constraint dotlrn_ct_pretty_name_nn
                                not null,
    description                 varchar2(4000),
    package_id                  constraint dotlrn_ct_package_id_fk
                                references apm_packages (package_id),
    portal_id                   constraint dotlrn_ct_portal_id_fk
                                references portals (portal_id),
    tree_sortkey                raw(240),
    max_child_sortkey           raw(3)
);

create table dotlrn_communities_all (
    community_id                constraint dotlrn_c_community_id_fk
                                references groups (group_id)
                                constraint dotlrn_communities_all_pk
                                primary key,
    parent_community_id         constraint dotlrn_c_parent_comm_id_fk
                                references dotlrn_communities_all (community_id),
    constraint dotlrn_c_community_key_un unique (community_key, parent_community_id),
    community_type              constraint dotlrn_c_community_type_nn
                                not null
                                constraint dotlrn_c_community_type_fk
                                references dotlrn_community_types (community_type),
    community_key               varchar2(100)
                                constraint dotlrn_c_community_key_nn
                                not null,
    pretty_name                 varchar2(100)
                                constraint dotlrn_c_pretty_name_nn
                                not null,
    description                 varchar2(4000),
    active_start_date           date,
    active_end_date             date,
    archived_p                  char(1)
                                default 'f'
                                constraint dotlrn_c_archived_p_ck
                                check (archived_p in ('t', 'f'))
                                constraint dotlrn_c_archived_p_nn
                                not null,
    portal_id                   constraint dotlrn_c_portal_id_fk
                                references portals (portal_id),
    non_member_portal_id        constraint dotlrn_c_non_member_portal_fk
                                references portals (portal_id),
    admin_portal_id             constraint dotlrn_c_admin_portal_id_fk
                                references portals (portal_id),
    package_id                  constraint dotlrn_c_package_id_fk
                                references apm_packages (package_id),
    tree_sortkey                raw(240),
    max_child_sortkey           raw(3),
	site_template_id			integer
				constraint dotlrn_c_site_template_id_fk
                                references dotlrn_site_templates(site_template_id)
);


create index dtlrn_com_all_com_par_id_idx on dotlrn_communities_all (community_id, parent_community_id);
create index dtlrn_com_all_archived_p_idx on dotlrn_communities_all (archived_p);

create or replace view dotlrn_communities
as
    select dotlrn_communities_all.*
    from dotlrn_communities_all
    where dotlrn_communities_all.archived_p = 'f';

create or replace view dotlrn_communities_not_closed
as
    select dotlrn_communities.*,
           groups.join_policy
    from dotlrn_communities,
         groups
    where dotlrn_communities.community_id = groups.group_id
    and groups.join_policy <> 'closed';

create or replace view dotlrn_active_communities
as
    select dotlrn_communities.*
    from dotlrn_communities
    where (dotlrn_communities.active_start_date is null or dotlrn_communities.active_start_date < sysdate)
    and (dotlrn_communities.active_end_date is null or dotlrn_communities.active_end_date > sysdate);

create or replace view dotlrn_active_comms_not_closed
as
    select dotlrn_communities.*,
           groups.join_policy
    from dotlrn_active_communities dotlrn_communities,
         groups
    where dotlrn_communities.community_id = groups.group_id
    and groups.join_policy <> 'closed';

@@ communities-tree-create.sql
