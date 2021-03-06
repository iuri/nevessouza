-- 
-- 
-- 
-- @author Jade Rubick (jader@bread.com)
-- @creation-date 2004-09-13
-- @arch-tag: 858b0c43-d09d-4caa-ad37-09be9b5cbf4d
-- @cvs-id $Id: upgrade-2.15b4-2.16b1.sql,v 1.3 2005/05/26 09:34:28 maltes Exp $
--

create table pm_users_viewed (
        viewing_user    integer constraint
                        pm_users_viewed_viewing_user_fk
                        references parties,
        viewed_user     integer constraint
                        pm_users_viewed_viewed_user_fk
                        references parties
);

comment on table pm_users_viewed is '
  Used to keep track of what users to see on the task calendar and other
  views.
';
