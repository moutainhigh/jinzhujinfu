<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
	                 <div class="well">
	               		 <form id="search" onsubmit="return validate();" action="${pageContext.request.contextPath}/sys/log/login" method="post">
	                   		<input type="hidden" id="page" name="page" value="${page}" />
	                   		<input type="hidden" id="size" name="size" value="${size}" />
							<div class="input-group pull-left">
								<span>管理员:</span>
								<input class="horizontal marginTop" id="name" name="name" type="text"  value="${name}" onkeyup="this.value=this.value.replace(/(^\s*)/g,'')" onblur="this.value=this.value.replace(/(\s*$)/g,'')"/>
 								<span >登录时间:</span> 
                                <input type="text" id="beginTime" name="beginTime" value="${beginTime}" class="span2 marginTop" onkeypress="return false"/>
							    <span style="vertical-align: 3px" >-</span> 
							    <input type="text" id="endTime" name="endTime" value="${endTime}" class="span2 marginTop" onkeypress="return false"/>
 								<input type="submit" value="查询" class="btn btn-default" />
	                            <input type="reset" value="重置" onclick="resetData()" class="btn btn-default" />
	                   		</div>
	                   	</form>
	                </div>
                    <div class="row-fluid">
                       	<div class="block">
                       		<div class="navbar navbar-inner block-header">&nbsp;</div>
                            <div class="block-content collapse in">
                                <div class="span12">
                                   <table cellpadding="0" cellspacing="0" border="0" class="table">
                                   		<thead>
                                        	<tr>
                                            	<th>序号</th>
                                                <th>管理员</th>
                                               	<th>IP地址</th>
                                               	<th>登录时间</th>
                                               	<th>退出时间</th>
                                           	</tr>
                                       </thead>
                                       <tbody>
                                       <c:choose>
											<c:when test="${fn:length(logs) > 0}">
                                       		<c:forEach var ="log" items="${logs}" varStatus="status">
                                       		<tr <c:if test="${status.count%2==0}">class="odd"</c:if>>
                                                <td style="width:30px;">${status.count}</td>
                                    			<td>${log.name}</td>
                                    			<td>${log.ip}</td>
                                    			<td><fmt:formatDate value="${log.loginTime}" type="both" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                    			<td>
                                   				<c:if test="${log.logoutTime != 'Thu Jan 01 00:00:00 GMT+08:00 1970' and log.logoutTime != 'Thu Jan 01 00:00:00 CST 1970'}">
   	                               					<fmt:formatDate value="${log.logoutTime}" type="both" pattern="yyyy-MM-dd HH:mm:ss" />
                                    			</c:if>
 	                                    		</td>
                                       		</tr>
                                       		</c:forEach>
                                       		</c:when>
                                       		<c:otherwise>
                                       		<tr>
                                       			<td>暂时没登录日志</td>
                                       		</tr>
                                       		</c:otherwise>
                                       	</c:choose>
                                        </tbody>
                                        <tfoot>
                                       		<tr>
                                       			<td colspan="5"><div id="log-page"></div></td>
                                       		</tr>
                                        </tfoot>
                                   </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
		<jsp:include page="${pageContext.request.contextPath}/footer" flush="true" />
	</body>
	<script type="text/javascript">
		$(document).ready(function() {
			var totalPages = '${pages}';
			$('.breadcrumb').html('<li class="active">系统管理&nbsp;/&nbsp;登录日志</li>');
			$('.marginTop').css('margin', '2px auto auto auto');
			$('.datepicker').css({width:120});
		    $('.horizontal').css({width:120});
			
			if(totalPages > 0) {
				var options = {
			        currentPage: '${page}',
			        totalPages: totalPages,
			        size: 'normal',
					alignment: 'center',
					tooltipTitles: function (type, page, current) {
						switch (type) {
					    case 'first':
					        return '首页';
					    case 'prev':
					        return '上一页';
					    case 'next':
					        return '下一页';
					    case 'last':
					        return '末页';
					    case 'page':
					        return (page === current) ? '当前页 ' + page : '跳到 ' + page;
					    }
					},
		            onPageClicked: function(event, originalEvent, type, page) {
		            	$('#search').attr('action', '${pageContext.request.contextPath}/sys/log/login');
		            	$('#page').val(page);
		                $('#search').submit();
		            }  
			    };
				$('#log-page').bootstrapPaginator(options);
			}
			
			$('#beginTime').datetimepicker({
			    format:'Y-m-d',
				lang:'ch',
		        timepicker:false,
		        maxDate:new Date().toLocaleDateString(),
		        onSelectDate:function() {
		        	getBeginTime();
				}
			});
			  
			$('#endTime').datetimepicker({
			    format:'Y-m-d',
				lang:'ch',
		        timepicker:false,
		        maxDate:new Date().toLocaleDateString(),
		        onSelectDate:function() {
		        	getEndTime();
				}
			});
			  
			getBeginTime();
			getEndTime();
		});
		  
		function getBeginTime() {
			var fromDate = $('#beginTime').val();
			var startDate = new Date(Date.parse(fromDate.replace(/-/g,"/")));
			$('#endTime').datetimepicker({
				format:'Y-m-d',
				minDate:startDate.getFullYear()+'/'+(startDate.getMonth()+1)+'/'+startDate.getDate(),
				maxDate:new Date().toLocaleDateString(),
				lang:'ch',
				timepicker:false
			});
		}
		  
		function getEndTime() {
			var toDate = $('#endTime').val();
			var endDate = new Date(Date.parse(toDate.replace(/-/g,"/")));
			$('#beginTime').datetimepicker({
				format:'Y-m-d',
				maxDate:endDate.getFullYear()+'/'+(endDate.getMonth()+1)+'/'+endDate.getDate(),
				lang:'ch',
				timepicker:false
			});
		}
		  
		function resetData() {
			$('#name').val('');
			$('#beginTime').val('');
			$('#endTime').val('');
			$('#search').attr('action','${pageContext.request.contextPath}/sys/log/login');
	        $('#search').submit(); 
		}
		  
		function validate() {
			if($('#endTime').val() && !$('#beginTime').val()) {
				alert('亲，请选择完整的时间段');
				return false;
			}
			if(!$('#endTime').val() && $('#beginTime').val()) {
				alert('亲，请选择完整的时间段');
				return false;
			}
			return true;
		}
	</script>
</html>