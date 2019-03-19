<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2006-01-28 -->
<!-- @cvs-id $Id: forums-callback-procs-oracle.xql,v 1.3 2018/08/15 17:03:48 gustafn Exp $ -->

<queryset>

    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="callback::search::url::impl::forums_message.select_forums_package_url">
        <querytext>
            select site_node.url(min(node_id))
            from site_nodes
            where object_id = (select package_id
                               from forums_forums
                               where forums_forums.forum_id = :forum_id)
        </querytext>
    </fullquery>

    <fullquery name="callback::search::url::impl::forums_forum.select_forums_package_url">
        <querytext>
            select site_node.url(min(node_id))
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
        start with message_id=:message_id 
        connect by prior message_id = parent_id
      </querytext>
    </fullquery>

</queryset>
