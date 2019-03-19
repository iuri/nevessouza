--
-- The Forums Package
--
-- @author David Arroyo darroyo@innova.uned.es
-- @creation-date 01-06-2007
-- @version $Id: forums-reading-info-create.sql,v 1.2 2017/11/10 17:21:05 antoniop Exp $
--
-- This is free software distributed under the terms of the GNU Public
-- License version 2 or later.  Full text of the license is available from the GNU Project:
-- http://www.fsf.org/copyleft/gpl.html


-- Tables to reading information


create table forums_reading_info (
    root_message_id integer
                    constraint forums_read_i_parent_id_fk
                    references forums_messages (message_id)
                    on delete cascade,
    user_id         integer
                    constraint forums_read_i_user_id_fk
                    references users(user_id)
                    constraint forums_read_i_user_id_nn
                    not null,
    reading_date    date
                    default sysdate
                    constraint forums_read_i_datetime_nn
                    not null,
		constraint forums_reading_info_pk primary key (root_message_id,user_id)
);
create index forums_reading_info_user_index on forums_reading_info (user_id);
create index forums_reading_info_forum_idx on forums_reading_info (root_message_id);
create index forums_reading_info_forum_forum_index on forums_reading_info (forum_id);

-- this was a sort of materialized view, but consistency checks made
-- code complicated. Redefined as a view
create or replace view forums_reading_info_user as
   select forum_id,
          user_id,
          count(*) as threads_read
     from forums_reading_info
    group by forum_id, user_id;
