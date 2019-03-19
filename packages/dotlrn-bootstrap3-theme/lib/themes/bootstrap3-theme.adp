<div class="panel panel-default portlet">
    <div class="panel-heading">
    
        <if @shadeable_p;literal@ true>     
            <a href="@configure_element_url@">
              <if @shaded_p;literal@ true>
                <span style="float:right;color:#666;"><i class="glyphicon glyphicon-plus"></i> #dotlrn-bootstrap3-theme.maximize_portlet#</span>
              </if>
              <else>
                <span style="float:right;color:#666;"><i class="glyphicon glyphicon-minus"></i> #dotlrn-bootstrap3-theme.minimize_portlet#</span>
              </else>
            </a>
        </if>
        <h3 class="panel-title">@name;noquote@</h3>
    </div>
    <div class="panel-body">
        <slave>
    </div>
</div>
