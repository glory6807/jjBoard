<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../include/header.jsp" %>

<div class="whole-wrap">
    <div class="container box_1170">
        <div class="section-top-border">
            <div class="row">
     
                <!-- 마이페이지 인클루드....start -- row 밑에서 include-->
				<%@ include file="../include/myPageMenu.jsp"%>
				<!-- 마이페이지 인클루드....end -->
				
                <!-- board s -->
                <div class="hanna_container" style="width : 100%; padding : 0px; margin : 0px;">
					<table class="table" style="width : 100%;">				
						<tr>
							<th>이름</th>
							<th>가격</th>
							<th>현재상태</th>
							<th>만료일자</th>
							<th>기간연장</th>
						</tr>					
						<c:forEach items="${mygift}" var="mygift" varStatus="status">
							<tbody>
								<tr>
									<td><a class="move" href="${mygift.myGiftNo}">${mygift.giftList[0].giftName}</a></td>									
									<td><fmt:formatNumber value="${mygift.giftList[0].giftPrice}" pattern="###,###" />원</td>
									<td class=""><c:set var="status" value="${mygift.status}" />
										<c:choose>
											<c:when test="${status eq 0}">사용가능</c:when>		
					    					<c:when test="${status eq 1}">기간만료</c:when>
					    					<c:when test="${status eq 2}">환불완료</c:when>
	      									<c:otherwise></c:otherwise>							
	   									</c:choose></td>
									<td><fmt:formatDate value="${mygift.expireDate}" pattern="yyyy.MM.dd"/></td>
									<td><c:set var="extendChk" value="${mygift.extendChk}"/>
										<c:choose>
											<c:when test="${extendChk eq 0}">가능</c:when>	      									     									
											<c:when test="${extendChk eq 1}">불가능</c:when>	      									     									
	      									<c:otherwise></c:otherwise>							
	   									</c:choose>
	   								</td>  																							
								</tr>
							</tbody>
						</c:forEach>					
					</table>
					<!--paging s -->               
						<div class="pagination justify-content-center">
      						 <ul class="pagination">
								<c:if test="${pageMaker.prev}">
									<li class="page-item previous">
										<a class="page-link"href="${pageMaker.startPage-1}" aria-label="Previous"> 
											<span aria-hidden="true">&laquo;</span>
										</a>
									</li>
								</c:if>										
								<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
									<li class="page-item + ${pageMaker.cri.pageNum == num ? 'active' : ''}">
										<a class="page-link" href="${num}">${num}</a>
									</li>
								</c:forEach>
								<c:if test="${pageMaker.next}">
									<li class="page-item next">
										<a class="page-link"href="${pageMaker.endPage+1}" aria-label="Next"> 
											<span aria-hidden="true">&raquo;</span>
										</a>
									</li>
								</c:if>
							</ul>
    					</div>
					<!--paging e -->
						<form id="actionForm" action="/myGift/list" method="get">
							<input type="hidden" name="pageNum" id="pageNum" value="${pageMaker.cri.pageNum}"> 
							<input type="hidden" name="amount" value="${pageMaker.cri.amount}">														
							<input type="hidden" name="memberId" value="${mygift[0].memberId}">																											
						</form>            
	            </div>
	        </div>
	    </div>
	</div>
</div>
 <!--board-end-->
<script>

$(function() {  
	var enterMember = '${param.memberId}';
	console.log(enterMember);
	var principalUsernmae = '<sec:authorize access="isAuthenticated()"><sec:authentication property="principal.username"/></sec:authorize>';
	
	if(enterMember != principalUsernmae){
		location.href='/accessError';
	}
	
	$('.move').click(
		function(e) {
			e.preventDefault();
			//actionForm에 hidden으로 name 속성 추가 값은 noticeNo 지정, value 속성 추가 값은 ~~ 지정한 후 append
			$('#actionForm').append(
					"<input type='hidden' name='myGiftNo' value='"
							+ $(this).attr("href") + "'>");
			$('#actionForm').attr("action", "/myGift/get");
	
			$('#actionForm').submit();
		});
});

$('.page-item a').click(function(e) {
	e.preventDefault();
	$('#pageNum').val($(this).attr('href'));
	$('#actionForm').submit();

});

</script>

<%@include file="../include/footer.jsp" %>