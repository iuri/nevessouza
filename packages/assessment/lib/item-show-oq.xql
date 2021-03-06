<?xml version="1.0"?>
<queryset>

<fullquery name="item_type_data">
<querytext>

    select c.title, t.default_value, t.feedback_text, t.reference_answer,
           t.keywords
    from as_item_type_oq t, cr_revisions c, as_item_rels r
    where t.as_item_type_id = r.target_rev_id
    and r.item_rev_id = :as_item_id
    and r.rel_type = 'as_item_type_rel'
    and c.revision_id = t.as_item_type_id

</querytext>
</fullquery>

</queryset>
