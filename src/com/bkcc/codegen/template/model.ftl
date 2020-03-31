<#import "function.ftl" as func>
<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign system=vars.system>
<#assign path=model.variables.path>
<#assign subtables=model.subTableList>
package com.hebei.${system}.${package}.data;

import lombok.Data;
import lombok.EqualsAndHashCode;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import com.hebei.core.model.BaseModel;
/**
 * 对象功能:${model.tabComment}
 <#if vars.company?exists>
 * 开发公司:${vars.company}
 </#if>
 <#if vars.developer?exists>
 * 开发人员:${vars.developer}
 </#if>
 * 创建时间:${date?string("yyyy-MM-dd HH:mm:ss")}
 */
@Data
@EqualsAndHashCode(callSuper=false)
@ApiModel(value="${model.tabComment}",description="${model.tabComment}")
public class ${class} extends BaseModel {
	private static final long serialVersionUID = 1L;
<#list model.columnList as col>
	/**
	 * ${col.comment}
	 */
	@ApiModelProperty(value="${col.comment}",name="${func.convertUnderLine(col.columnName)}")
	<#if (col.colType=="Integer")>
	protected Long  ${func.convertUnderLine(col.columnName)}; 
	<#else>
			<#if (col.colType=="java.util.Date")>
	protected java.util.Date  ${func.convertUnderLine(col.columnName)};
	/**
	 * 开始 ${col.comment}
	 */
	@ApiModelProperty(value="开始${col.comment}",name="begin${func.convertUnderLine(col.columnName)}")
	protected java.util.Date  begin${func.convertUnderLine(col.columnName)};
	/**
	 * 结束  ${col.comment}
	 */
	@ApiModelProperty(value="结束${col.comment}",name="end${func.convertUnderLine(col.columnName)}")
	protected java.util.Date  end${func.convertUnderLine(col.columnName)};	
			<#else>
	protected ${col.colType}  ${func.convertUnderLine(col.columnName)};
			</#if> 
	</#if>
</#list>

}