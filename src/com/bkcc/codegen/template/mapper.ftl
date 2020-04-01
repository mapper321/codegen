<#import "function.ftl" as func>
<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign system=vars.system>
<#assign type="com.hebei."+system+"."+package+".data." +class>
<#assign tableName=model.tableName>
<#assign system=vars.system>
<#assign foreignKey=model.foreignKey>
<#assign sub=model.sub>
<#assign colList=model.columnList>
<#assign commonList=model.commonList>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.getPkVar(model) >




<#-- 模板开始  -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd"> 
<mapper namespace="${type}">
	<resultMap id="${class}" type="${type}">
		<#list colList as col>
		<#assign colName=func.convertUnderLine(col.columnName)>
		<#if (col.isPK) >
		<id property="${colName}" column="${col.columnName}" jdbcType="${func.getJdbcType(col.colDbType)}"/>
        <#elseif (col.colType=="java.util.Date") >
        <result property="${colName}" column="${col.columnName}" jdbcType="TIMESTAMP"/>
        <#else>
		<result property="${colName}" column="${col.columnName}" jdbcType="${func.getJdbcType(col.colDbType)}"/>
		</#if>
		</#list>
	</resultMap>

	<sql id="columns">
		<#list colList as col>${tableName}.${col.columnName}<#if col_has_next>,</#if></#list>
	</sql>
	
	<sql id="dynamicWhere">
		<where>
			<#list colList as col>
			<#assign colName=func.convertUnderLine(col.columnName)>
			<#if (col.colType=="String")>
			<if test="${colName}!= null and ${colName} != ''"> AND ${tableName}.${col.columnName}  LIKE '%<#noparse>${</#noparse>${colName}}%'  </if>
			<#else>
			<#if (col.colType=="java.util.Date")>
			<if test="${colName} != null"> AND ${tableName}.${col.columnName}  =<#noparse>#{</#noparse>${colName}} </if>
			<if test="begin${colName} != null"> AND ${tableName}${col.columnName}  >=<#noparse>#{</#noparse>begin${colName},jdbcType=TIMESTAMP} </if>
			<if test="end${colName} != null"> AND ${tableName}${col.columnName} <![CDATA[ <=<#noparse>#{</#noparse>end${colName},jdbcType=TIMESTAMP}]]> </if>
			<#else>
			<if test="${colName} != null"> AND ${tableName}.${col.columnName}  =<#noparse>#{</#noparse>${colName}} </if>
			</#if>
			</#if>
			</#list>
		</where>
	</sql>

	<insert id="add" parameterType="${type}">
		INSERT INTO ${tableName}
		(<#list colList as col>${col.columnName}<#if col_has_next>,</#if></#list>)
		VALUES
		(<#list colList as col>
		<#assign colName=func.convertUnderLine(col.columnName)>
		<#if (col.colType=="java.util.Date")>
		<#noparse>#{</#noparse>${colName},jdbcType=TIMESTAMP<#noparse>}</#noparse><#if col_has_next>, </#if>
		<#else>
		<#noparse>#{</#noparse>${colName},jdbcType=${func.getJdbcType(col.colDbType)}<#noparse>}</#noparse><#if col_has_next>, </#if>
		</#if>
		</#list>)
	</insert>
	
	<delete id="delById" parameterType="java.lang.Long">
		DELETE FROM ${tableName} 
		WHERE
		${pk}=<#noparse>#{</#noparse>${func.convertUnderLine(pk)}}
	</delete>
	
	<update id="update" parameterType="${type}">
		UPDATE ${tableName} SET
		<#list commonList as col>
		<#assign colName=func.convertUnderLine(col.columnName)>
        <#if (col.columnName == "create_time")>
        <#elseif (col.columnName == "create_by")>
        <#else>
        <#if (col.colType=="java.util.Date")>
		${tableName}.${col.columnName}=<#noparse>#{</#noparse>${colName},jdbcType=TIMESTAMP<#noparse>}</#noparse> <#if col_has_next>,</#if>
        <#else>
		${tableName}.${col.columnName}=<#noparse>#{</#noparse>${colName},jdbcType=${func.getJdbcType(col.colDbType)}<#noparse>}</#noparse><#if col_has_next>,</#if>
		</#if>
		</#if>
		</#list>
		WHERE
		${pk}=<#noparse>#{</#noparse>${func.convertUnderLine(pk)}<#noparse>}</#noparse>
	</update>
	<#if sub?exists && sub==true>
	<#assign foreignKeyVar=func.convertUnderLine(foreignKey)>
	<delete id="delByMainId">
	    DELETE FROM ${tableName}
	    WHERE
	    ${foreignKey}=<#noparse>#{</#noparse>${foreignKeyVar}}
	</delete>    
	
	<select id="get${class}List" resultMap="${class}">
	    SELECT <include refid="columns"/>
	    FROM ${tableName} 
	    WHERE ${foreignKey}=<#noparse>#{</#noparse>${foreignKeyVar}}
	</select>
	</#if>
		    
	<select id="getById" parameterType="java.lang.Long" resultMap="${class}">
		SELECT <include refid="columns"/>
		FROM ${tableName}
		WHERE
		${pk}=<#noparse>#{</#noparse>${func.convertUnderLine(pk)}}
	</select>
	
	<select id="getAll" resultMap="${class}">
		SELECT <include refid="columns"/>
		FROM ${tableName}   
		<include refid="dynamicWhere" />
		<if test="orderSeq !=null and orderSeq !=''">
		order by <#noparse>${orderField}</#noparse> <#noparse>${orderSeq}</#noparse>
		</if>
		<if test="orderField == null or orderField == ''">
		order by ${tableName}.${pk}  desc
		</if>
	</select>
</mapper>
