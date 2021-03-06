<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_photo_info">      
      <querytext>

select
 pp.caption,
 pp.story,
 cr.title,
 cr.description,
 i.height as height,
 i.width as width,
 i.image_id as image_id,
 ci.parent_id as album_id,
 case when acs_permission.permission_p(ci.item_id, :user_id, 'admin') ='t' then 1 else 0 end as admin_p,
 case when acs_permission.permission_p(ci.item_id, :user_id, 'write') = 't' then 1 else 0 end as write_p,
 case when acs_permission.permission_p(ci.parent_id, :user_id, 'write') = 't' then 1 else 0 end as album_write_p,
 case when acs_permission.permission_p(ci.item_id, :user_id, 'delete') = 't' then 1 else 0 end as photo_delete_p
from cr_items ci,
  cr_revisions cr,
  pa_photos pp,
  cr_items ci2,
  cr_child_rels ccr2,
  images i
where cr.revision_id = pp.pa_photo_id
  and ci.live_revision = cr.revision_id
  and ci.item_id = ccr2.parent_id
  and ccr2.child_id = ci2.item_id
  and ccr2.relation_tag = 'viewer'
  and ci2.live_revision = i.image_id
  and ci.item_id = :photo_id

      </querytext>
</fullquery>

<fullquery name="get_albums">       
      <querytext> 
    select r.title as name, i.item_id 
    from cr_items i left outer join cr_revisions r on (live_revision = revision_id)
    where
      acs_permission.permission_p(i.item_id, :user_id, 'pa_create_photo') = 't' 
      and i.content_type = 'pa_album' 
      and i.item_id != :old_album_id 
      start with i.item_id = :root_folder_id
      connect by i.parent_id = prior i.item_id
    order by i.item_id
      </querytext> 
</fullquery> 
 
</queryset>
