<#import "function.ftl" as func>
<#assign class=model.variables.class>
<#assign comment=model.tabComment>
<#assign class=model.variables.class>
<#assign comment=model.tabComment>
<#assign classVar=model.variables.class?lower_case>
<#assign classVar=model.variables.classVar>
<#assign commonList=model.commonList>
<#assign pkModel=model.pkModel>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.convertUnderLine(pk) >
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@include file="/commons/include/html_doctype.html"%> --%>
<%-- <%@include file="/commons/include/base.jsp"%> --%>
<html>
<body>
<!--列表页-->
<div id="${classVar}Main" class="panel mainArea" fit="true">
 <div class="toolbar">
   <ul class="toolbar-button">
	 <li><f:a href="#" css="linkbutton" iconCls="icon-add" onclick="${classVar}.add()">增加</f:a></li>
	 <li><f:a href="#" css="linkbutton" iconCls="icon-edit" onclick="${classVar}.edit()">修改</f:a></li>
	 <li><f:a href="#" css="linkbutton" iconCls="icon-remove" onclick="${classVar}.del()">删除</f:a></li>
	 <li><f:a href="#" css="linkbutton" iconCls="icon-export-excel" onclick="exportXls(<#noparse>'</#noparse>${classVar}<#noparse>'</#noparse>)">导出</f:a></li>
		  <li class="searchLinkButton"> 
	  			<a class="linkbutton" iconCls="icon-search" onclick="${classVar}.query()">搜索</a> 
	   			<a class="linkbutton" iconCls="icon-clear" onclick="${classVar}.clear()">清空</a>
				<a class="linkbutton" iconCls="icon-arrow-up" onclick="showSearchPanel(this)"></a>
	 		</li>
   </ul>
   <ul class="toolbar-search">
	 <form id="${classVar}Form_Q"  method="post">
	   <f:field options="query">
	   <#list commonList as col>
       <#assign colName=func.convertUnderLine(col.columnName)>
         <li>
           <span class="label">${col.comment}：</span>
            <#if (col.colType=="java.util.Date")>
                <input name="begin${colName}" class="datebox" />-<input name="end${colName}" class="datebox" /> 
            <#else>
          	<input class="validatebox"  name="${colName}"/>
           	</#if>
       </li>
      </#list>
      </f:field>
	 </form>
   </ul>
 </div>
 <table id="${classVar}Grid" class="datagrid" toolbar="<#noparse>#</#noparse>${classVar}Main .toolbar" data-options="fitColumns:false,onDblClickRow:${classVar}.dbRow">
   <thead>
	 <th data-options="field:'${pkVar}',checkbox:true"></th>
	   <f:field options="grid"> 
	     <#list model.commonList as col>
		 <#assign colName=func.convertUnderLine(col.columnName)>
		 <#if (col.colType=="java.util.Date")>
		   <th field="${colName}" sortable="true" width="80px"  formatter="DateUtil.formatDay">${col.getComment()}</th>
		   <#else>
		   <th field="${colName}" sortable="true" width="80px" >${col.getComment()}</th>
		 </#if>
		   </#list>
		</f:field>
   </thead>
		</table>
</div>

<!--详情页-->
<div id="${classVar}Detail" class="panel detailArea" fit="true">
<div class="layout" fit="true"> 
 <form  id="${classVar}Form"  method="post">
  <input type="hidden" name="${pkVar}"/>
 <div class="basicPanel" data-options="region:'north'">
 <div class="formWarp">
   <div class="title">
	 <h1>基本信息</h1>
	 <ul class="action">
	   <li><a href="#" class="linkbutton" iconCls='icon-back' onclick="${classVar}.back()">返回</a></li>
	   <li><a href="#" class="linkbutton" iconCls='icon-save' onclick="${classVar}.save()">保存</a></li>
	   <li><a href="#" class="linkbutton" iconCls='icon-edit' onclick="${classVar}.detailToEdit()">修改</a></li>
	 </ul>
   </div> 
 </div>
 <div id="${classVar}Top"  class="panel" data-options="region:'center'" style="height:150px;overflow: hidden;"> 
   <div class="formWarp">
	     <f:field options="form"> 
               <ul class="fbd" cell="3">
				 <#list commonList as col>
                 <#assign colName=func.convertUnderLine(col.columnName)> 
				 <li>
				   <span class="label">${col.comment}：</span>
				   <#if (col.colType=="java.util.Date")>
				     <input class="datebox"  id="${colName}" name="${colName}" />
				    <#else> 
				  	 <input class="validatebox"  id="${colName}"  name="${colName}"  data-options="validType:'length[0,${col.length/2}]'"  />
				 	</#if>
				 </li>
				 </#list>
			   </ul>
			</f:field>
   </div>
 </div>
 </div>
  </form>
</div>
</div>
<script type="text/javascript">
Namespace.register("${classVar}");
$.parser.onComplete = function (context) {
	$('<#noparse>#</#noparse>${classVar}Grid').loadData('list.ht');
	${classVar}<#noparse>.</#noparse>forminit();
    layout('${classVar}');
};

${classVar}<#noparse>.</#noparse>forminit=function(){ 
	 
};

${classVar}<#noparse>.</#noparse>query=function(){
    var fields =$('<#noparse>#</#noparse>${classVar}Form_Q').serializeArray(); //获取模糊查询数据
    $('<#noparse>#</#noparse>${classVar}Grid').setQueryParams(fields);//传递参数
    $('<#noparse>#</#noparse>${classVar}Grid').datagrid('reload');//根据参数显示数据
};

${classVar}<#noparse>.</#noparse>clear=function(){
    $('<#noparse>#</#noparse>${classVar}Form_Q').form('clear');//清空参数
    ${classVar}<#noparse>.</#noparse>query();//查询
};

${classVar}<#noparse>.</#noparse>back=function(){
    $('<#noparse>#</#noparse>${classVar}Main').showArea();
    ${classVar}<#noparse>.</#noparse>query();//查询
};

${classVar}<#noparse>.</#noparse>del=function(){  
    $('<#noparse>#</#noparse>${classVar}Grid').delData('del.ht','${pkVar}',function(){
        ${classVar}<#noparse>.</#noparse>query();//查询
    });//删除数据
};

${classVar}<#noparse>.</#noparse>add=function(){ 
     ${classVar}<#noparse>.</#noparse>showMode(0,"ADD"); 
};

${classVar}<#noparse>.</#noparse>edit=function(){ 
     var rowData = $('<#noparse>#</#noparse>${classVar}Grid').datagrid('getSelected');
     if (!rowData){
      	$.messager.alert('提示','请选中一条记录');
       return;
     }
     ${classVar}<#noparse>.</#noparse>showMode(rowData.${pkVar},"EDIT"); 
};

${classVar}<#noparse>.</#noparse>save=function(){
      $('<#noparse>#</#noparse>${classVar}Form').submit('save.ht',function(ViewData){
       //如果执行错误，提示错误信息
       if (!ViewData.isSucceed) {
           $.messager.alert('错误', ViewData.message);
          return;
       }
       ${classVar}<#noparse>.</#noparse>${pkVar}=ViewData.${pkVar}; 
       $('<#noparse>#</#noparse>${classVar}Detail').showArea();
    }); 
};

${classVar}<#noparse>.</#noparse>dbRow=function(rowIndex, rowData){ 
	${classVar}<#noparse>.</#noparse>showMode(rowData.${pkVar},""); 
};

${classVar}<#noparse>.</#noparse>detailToEdit = function () {
	${classVar}<#noparse>.</#noparse>showMode(${classVar}<#noparse>.</#noparse>${pkVar}, "EDIT");
};

${classVar}<#noparse>.</#noparse>showMode=function(id,view){ 
	$('<#noparse>#</#noparse>${classVar}Form').form('clear');
	$('<#noparse>#</#noparse>${classVar}Detail').showArea(view); 
	if(id==null||id<=0){ 
		return;
	}
	${classVar}<#noparse>.</#noparse>${pkVar}=id; 
	$("<#noparse>#</#noparse>${classVar}Form").loadData('get.ht?${pkVar}='+id);
};


</script>
</body>
</html>
