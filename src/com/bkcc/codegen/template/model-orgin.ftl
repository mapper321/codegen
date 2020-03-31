<#import "function.ftl" as func>
<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign system=vars.system>
<#assign path=model.variables.path>
<#assign subtables=model.subTableList>
package com.bkcc.${system}.${package}.data;

import com.bkcc.core.model.BaseModel;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.EqualsBuilder;
/**
 * 对象功能:${model.tabComment} Model对象
 <#if vars.company?exists>
 * 开发公司:${vars.company}
 </#if>
 <#if vars.developer?exists>
 * 开发人员:${vars.developer}
 </#if>
 * 创建时间:${date?string("yyyy-MM-dd HH:mm:ss")}
 */
public class ${class} extends BaseModel
{
	private static final long serialVersionUID = 1L;
<#list model.columnList as col>
	// ${col.comment}
	<#if (col.colType=="Integer")>
	protected Long  ${func.convertUnderLine(col.columnName)}; 
	<#else>
			<#if (col.colType=="java.util.Date")>
	protected java.util.Date  ${func.convertUnderLine(col.columnName)};
	//开始 ${col.comment}
	protected java.util.Date  begin${func.convertUnderLine(col.columnName)};
	//结束 ${col.comment}
	protected java.util.Date  end${func.convertUnderLine(col.columnName)};	
			<#else>
	protected ${col.colType}  ${func.convertUnderLine(col.columnName)};
			</#if> 
	</#if>
</#list>
<#if subtables?exists && subtables?size!=0>
	<#list subtables as table>
	<#assign vars=table.variables>
	//${table.tabComment}列表
	protected List<${vars.class}> ${vars.classVar}List=new ArrayList<${vars.class}>();
	</#list>
	</#if>
<#list model.columnList as col>
	<#assign colName=func.convertUnderLine(col.columnName)>
	public void set${colName?cap_first}(<#if (col.colType="Integer")>Long<#else>${col.colType}</#if> ${colName}) 
	{
		this.${colName} = ${colName};
	}
	/**
	 * 返回 ${col.comment}
	 * @return
	 */
	public <#if (col.colType="Integer")>Long<#else>${col.colType}</#if> get${colName?cap_first}() 
	{
		return this.${colName};
	}
 
 	<#if (col.colType=="java.util.Date")>
	public void setBegin${colName}(java.util.Date begin${colName}) 
	{
		this.begin${colName} = begin${colName};
	}
	/**
	 * 返回 开始${col.comment}
	 * @return
	 */
	public java.util.Date getBegin${colName}() 
	{
		return this.begin${colName};
	}
	
	public void setEnd${colName}(java.util.Date end${colName}) 
	{
		this.end${colName} = end${colName};
	}
	/**
	 * 返回 结束${col.comment}
	 * @return
	 */
	public java.util.Date getEnd${colName}() 
	{
		return this.end${colName};
	}
	</#if>

</#list>
<#if subtables?exists && subtables?size!=0>
<#list subtables as table>
<#assign vars=table.variables>
	public void set${vars.classVar?cap_first}List(List<${vars.class}> ${vars.classVar}List) 
	{
		this.${vars.classVar}List = ${vars.classVar}List;
	}
	/**
	 * 返回 ${table.tabComment}列表
	 * @return
	 */
	public List<${vars.class}> get${vars.classVar?cap_first}List() 
	{
		return this.${vars.classVar}List;
	} 
</#list>
</#if>

   
   	/**
	 * @see java.lang.Object#equals(Object)
	 */
	public boolean equals(Object object) 
	{
		if (!(object instanceof ${class})) 
		{
			return false;
		}
		${class} rhs = (${class}) object;
		return new EqualsBuilder()
		<#list model.columnList as col>
		<#assign colName=func.convertUnderLine(col.columnName)>
		.append(this.${colName}, rhs.${colName})
		</#list>
		.isEquals();
	}

	/**
	 * @see java.lang.Object#hashCode()
	 */
	public int hashCode() 
	{
		return new HashCodeBuilder(-82280557, -700257973)
		<#list model.columnList as col>
		<#assign colName=func.convertUnderLine(col.columnName)>
		.append(this.${colName}) 
		</#list>
		.toHashCode();
	}

	/**
	 * @see java.lang.Object#toString()
	 */
	public String toString() 
	{
		return new ToStringBuilder(this)
		<#list model.columnList as col>
		<#assign colName=func.convertUnderLine(col.columnName)>
		.append("${colName}", this.${colName}) 
		</#list>
		.toString();
	}
   
  

}