<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2006-01-28 -->
<!-- @arch-tag: 33e3dcb8-30e3-445e-a6f7-7fc8e00c2301 -->
<!-- @cvs-id $Id: forums-callback-procs-postgresql.xql,v 1.2 2007/10/07 22:37:01 donb Exp $ -->

<queryset>

  <rdbms><type>postgresql</type><version>7.4</version></rdbms>
  
    <fullquery name="callback::acs_mail_lite::incoming_email::impl::forums.get_package_ids">
      <querytext>
	select v.package_id
	from apm_parameters p,
	apm_parameter_values v
	where p.package_key = :package_key
	and p.parameter_name = 'EmailPostID'
	and p.parameter_id = v.parameter_id
	and v.attr_value = :email_post_id
      </querytext>
    </fullquery>
    
    <fullquery name="callback::search::url::impl::forums_message.select_forums_package_url">
        <querytext>
            select site_node__url(min(node_id))
            from site_nodes
            where object_id = (select package_id
                               from forums_forums
                               where forums_forums.forum_id = :forum_id)
        </querytext>
    </fullquery>

    <fullquery name="callback::search::url::impl::forums_forum.select_forums_package_url">
        <querytext>
            select site_node__url(min(node_id))
            from site_nodes
            where object_id = (select package_id
                               from forums_forums
                               where forums_forums.forum_id = :forum_id)
        </querytext>
    </fullquery>

    <fullquery name="callback::search::datasource::impl::forums_message.messages">
      <querytext>
        select subject, content, format
        from forums_messages
        where message_id=:message_id or (tree_sortkey between tree_left(:tree_sortkey) and tree_right(:tree_sortkey))
        and forum_id=:forum_id
        order by tree_sortkey
      </querytext>
    </fullquery>

</queryset>
