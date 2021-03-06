<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<jsp:include page="${pageContext.request.contextPath}/header" flush="true" />
	<body>
		<jsp:include page="${pageContext.request.contextPath}/menu" flush="true" />
        <div class="container-fluid">
            <div class="row-fluid">
                <jsp:include page="${pageContext.request.contextPath}/sidebar" flush="true" />
                <div class="span10" id="content">
                    <jsp:include page="${pageContext.request.contextPath}/breadcrumb" flush="true" />
                    <!-- content begin -->
                    <div class="row-fluid">
                    	<form class="form-horizontal" id="fm" method="post" action="${pageContext.request.contextPath}/service/faq/save">
                    		<input id="id" name="id" value="0" type="hidden">
                    		<div class="well" style="padding-bottom: 20px; margin: 0;">
	                    		<div class="control-group">
									<label class="control-label"><span class="required">*</span>问题名称</label>
									<div class="controls"><input type="text" name="ask" class="validate[required,minSize[6],maxSize[40],ajax[validateFaq]] text-input span9"  onkeyup="this.value=this.value.replace(/(^\s*)/g,'')" onblur="this.value=this.value.replace(/(\s*$)/g,'')" placeholder="6~40个字"/></div>
								</div>
								<div class="control-group">
									<label class="control-label"><span class="required">*</span>回答</label>
									<div class="controls">
									 <textarea id="institutionDesc" name="question" class="validate[required,minSize[2],maxSize[1000]] text-input span9" rows="5" onkeyup="this.value=this.value.replace(/(^\s*)/g,'')" onblur="this.value=this.value.replace(/(\s*$)/g,'')"></textarea>
									</div>
								</div>
								<div class="control-group">
									<label class="control-label"></label>
									<div class="controls">
										<button type="submit" class="btn btn-icon btn-primary glyphicons circle_ok"><i></i>保存</button>
										<button type="reset" class="btn btn-icon btn-default glyphicons circle_remove" onclick="quit();"><i></i>返回</button>
									</div>
								</div>
                    		</div>
                    	</form>
                    </div>
                    <!-- content end -->
                </div>
            </div>
        </div>
		<jsp:include page="${pageContext.request.contextPath}/footer" flush="true" />
	</body>
	<script type="text/javascript">
		$(function() {
			$('.breadcrumb').html('<li class="active">客服管理&nbsp;/&nbsp;<a href="javascript:quit();">常见问题</a>&nbsp;/&nbsp;新增</li>');
			$('#fm').validationEngine('attach', {
		        promptPosition:'bottomLeft',
		        showOneMessage: true,
		        focusFirstField:true,
		        scroll: true
		    });
		});
		
		function quit(){
			window.location.href='${pageContext.request.contextPath}/service/faq/list';
		}
	</script>
</html>