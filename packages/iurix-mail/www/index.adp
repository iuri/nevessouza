<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<if @emails:rowcount@ not nil and @emails:rowcount@ gt 0>
  <listtemplate name="emails"></listtemplate>
</if>
<else>#iurix-mail.No_data# <a href="/mail/account-ae">#iurix-mail.Click#</a> #iurix-mail.to_connect_lt#</else>