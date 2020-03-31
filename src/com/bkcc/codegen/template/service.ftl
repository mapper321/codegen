<#import "function.ftl" as func>
<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign system=vars.system>
<#assign subtables=model.subTableList>
<#assign classVar=model.variables.classVar>
<#assign path=model.variables.path>
<#assign table=model.subTableList>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.convertUnderLine(pk)>
package com.hebei.${system}.${package};

import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import com.hebei.core.service.BaseService;
import com.hebei.core.mybatis.IEntityDao;
import com.hebei.${system}.${package}.data.${class};
<#if subtables?exists && subtables?size != 0>
	<#list subtables as table>
import com.hebei.${system}.model.${table.variables.package}.${table.variables.class};
import com.hebei.${system}.dao.${table.variables.package}.${table.variables.class}Dao;
	</#list>
</#if>

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
@Service
public class ${class}Service extends BaseService<${class}> {
	@Resource
	private ${class}Dao dao;
	
	<#if subtables?exists && subtables?size != 0>
		<#list subtables as table>
	@Resource
	private ${table.variables.class}Dao ${table.variables.classVar}Dao;
		</#list>
	</#if>
	public ${class}Service() {
	}
	
	@Override
	protected IEntityDao<${class}, Long> getEntityDao() {
		return dao;
	}
	
	<#if subtables?exists && subtables?size != 0>
	private void delByPk(Long ${pkVar}){
	    <#list model.subTableList as table>
		${table.variables.classVar}Dao.delByMainId(${pkVar});
	    </#list>
	}
	
	public void delAll(Long[] lAryId) {
		for(Long id:lAryId){	
			delByPk(id);
			dao.delById(id);	
		}	
	}
	
	public void addAll(${class} ${classVar}) throws Exception {
		add(${classVar});
		addSubList(${classVar});
	}
	
	public void updateAll(${class} ${classVar}) throws Exception {
		update(${classVar});
		delByPk(${classVar}.get${pkVar?cap_first}());
		addSubList(${classVar});
	}
	
	public void addSubList(${class} ${classVar}) throws Exception {
	<#list subtables as table>
	<#assign vars=table.variables>
	<#assign foreignKey=func.convertUnderLine(table.foreignKey) >
	<#assign subPk=func.getPk(table)>
	<#assign subPkVar=func.convertUnderLine(subPk)>
		List<${vars.class}> ${vars.classVar}List=${classVar}.get${vars.classVar?cap_first}List();
		if(BeanUtils.isNotEmpty(${vars.classVar}List)){
			for(${vars.class} ${vars.classVar}:${vars.classVar}List){
				${vars.classVar}.set${foreignKey?cap_first}(${classVar}.get${pkVar?cap_first}());
				${vars.classVar}.set${subPkVar?cap_first}(UniqueIdUtil.genId());
				${vars.classVar}Dao.add(${vars.classVar});
			}
		}
	</#list>
	}
	
	<#list subtables as table>
	<#assign vars=table.variables>
	public List<${vars.class}> get${vars.classVar?cap_first}List(Long ${pkVar}) {
		return ${vars.classVar}Dao.getByMainId(${pkVar});
	}
	</#list>
	
	</#if>
}
