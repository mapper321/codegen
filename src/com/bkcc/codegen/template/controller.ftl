<#import "function.ftl" as func>
<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign path=model.variables.path>
<#assign system=vars.system>
<#assign comment=model.tabComment>
<#assign subtables=model.subTableList>
<#assign classVar=model.variables.classVar>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.convertUnderLine(pk) >
package com.hebei.${system}.${package};

import javax.annotation.Resource;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import com.hebei.core.model.PageBean;
import com.hebei.core.model.ResultView;
import com.hebei.core.util.UniqueIdUtil;
import com.hebei.core.util.StringUtil;
import com.hebei.core.web.controller.BaseController; 
import io.swagger.annotations.Api;
import com.hebei.${system}.${package}.data.${class};
import io.swagger.annotations.ApiOperation;
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
@Api(tags="${model.tabComment}")
@RestController
@RequestMapping("/${path}/${package}")
public class ${class}Controller extends BaseController {
	@Resource
	private ${class}Service ${classVar}Service;

	@ApiOperation(value = "列表查询")
	@GetMapping("/list")
	public ResultView list(PageBean PageBean,${class} ${classVar}) {		
		return ${classVar}Service.getAll(PageBean, ${classVar});
	}

    @ApiOperation(value = "根据主键查询详情")
	@GetMapping()
    public ResultView get(Long ${pkVar}) {
    	return ResultView.ok(${classVar}Service.getById(${pkVar}));
    }

	@ApiOperation(value = "保存/更新")
	@PostMapping()
	public  ResultView save(${class} ${classVar}) {
		ResultView ResultView=new ResultView(); 
		if(${classVar}.get${pkVar?cap_first}()==null||${classVar}.get${pkVar?cap_first}()<=0){
			${classVar}.set${pkVar?cap_first}(UniqueIdUtil.genId()); 
			${classVar}Service.add(${classVar});
		}else{
			${classVar}Service.update(${classVar});
		}
		ResultView.addKV("id",${classVar}.get${pkVar?cap_first}().toString());
		return ResultView;
	}

	@ApiOperation(value = "根据主键删除")
    @DeleteMapping()
    public ResultView del(String ${pkVar}) {
        Long[] lAryId = StringUtil.getLongAryByStr(${pkVar});
        for (int i = 0; i < lAryId.length; i++) {
            ${classVar}Service.delById(lAryId[i]);
        }
        return new ResultView();
    }
}
