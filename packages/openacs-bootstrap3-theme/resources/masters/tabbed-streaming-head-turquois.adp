<master src="plain-streaming-head">
<if @doc@ defined><property name="&doc">doc</property></if>
<if @body@ defined><property name="&body">body</property></if>
<if @head@ not nil><property name="head">@head;noquote@</property></if>
<if @focus@ not nil><property name="focus">@focus;noquote@</property></if>
<if @context@ not nil><property name="context">@context;noquote@</property></if>
<if @subsite_logo@ not nil><property name="subsite_logo">@subsite_logo;noquote@</property></if>
<if @subsite_link@ not nil><property name="subsite_link">@subsite_link;noquote@</property></if>
<property name="&navigation">navigation</property>

<slave>
