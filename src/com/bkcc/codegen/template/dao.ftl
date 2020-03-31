<#import "function.ftl" as func>
<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign system=vars.system>
<#assign classVar=model.variables.classVar>
<#assign sub=model.sub>
<#assign foreignKey=func.convertUnderLine(model.foreignKey)>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.convertUnderLine(pk) >
package com.hebei.${system}.${package};

import org.springframework.stereotype.Repository;
import com.hebei.core.mybatis.BaseDao;
<#if sub?exists && sub>
import com.hebei.core.util.UniqueIdUtil;
import com.hebei.core.util.BeanUtils;
</#if>
import com.hebei.${system}.${package}.data.${class};
/**
 *
 <#if vars.company?exists>
 * 开发公司:${vars.company}
 </#if>
 <#if vars.developer?exists>
 * 开发人员:${vars.developer}
 </#if>
 * 创建时间:${date?string("yyyy-MM-dd HH:mm:ss")}
 */
@Repository
public class ${class}Dao extends BaseDao<${class}> {
	@Override
	public Class<${class}> getEntityClass()
	{
		return ${class}.class;
	}

	<#if sub?exists && sub>
	public List<${class}> getByMainId(Long ${foreignKey}) {
		return this.getBySqlKey("get${class}List", ${foreignKey});
	}
	
	public void delByMainId(Long ${foreignKey}) {
		this.delBySqlKey("delByMainId", ${foreignKey});
	}
	</#if>	
}