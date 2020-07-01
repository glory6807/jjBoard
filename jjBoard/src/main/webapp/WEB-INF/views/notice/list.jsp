<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../include/header.jsp" %>

<!--board s-->
<section id="tabs" class="project-tab" >
	<div class="container" style="width: 1000px; margin-left: -80px;">
		<div class="row no-mean">		
			<div class="col-md-12">
				<div class="custom-board-title">
					<h3 class="custom-font-bold">공지사항</h3>
				</div>
				<div class="custom-search-position">
						
					<button id="regNotice" type="button" class="btn btn-primary btn-sm">등록</button>						
					<button id="ExcelNotice" type="button" class="btn btn-success btn-sm">엑셀다운(전체)</button>						
					<button id="ExcelNoticePage" type="button" class="btn btn-success btn-sm">엑셀다운(페이지)</button>						
					
					<!--search s -->
					<div class="pull-right">
						<form id="searchForm" action="/notice/list" method="get">							
						<select name="type" class="typeChk">
							<option value="T" <c:out value="${ pageMaker.cri.type =='T'?'selected':''}"/>>제목</option>
							<option value="C" <c:out value="${ pageMaker.cri.type =='C'?'selected':''}"/>>내용</option>
						</select>
						<input type="text" placeholder="검색어를 입력하세요" maxlength="100" class="input-group-btn" name="keyword" id="keywordSearch" value='<c:out value="${ pageMaker.cri.keyword }"/>'/>
						<input type="hidden" name="pageNum" value="${ pageMaker.cri.pageNum }" /> 
						<input type="hidden" name="amount" value="${ pageMaker.cri.amount }" />
						<button class="btn btn-primary btn-sm" id="search">검색</button>																		
						<c:if test="${!empty pageMaker.cri.keyword}">
							<button class="btn btn-primary btn-sm" type="button" id="return">LIST</button>
						</c:if>	
						</form>			
					</div>					
					<!--search e -->				
					<div class="tab-content" id="nav-tabContent" >					
						<form id="listForm" role="form" action="/notice/getExcelFile" method="get">
						<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}"> 
								<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
								<input type="hidden" name="type" value="${ pageMaker.cri.type }" /> 
								<input type="hidden" name="keyword" value="${ pageMaker.cri.keyword }" />
						<table class="table custom-th-size table-hover">								
							<tr>
								<th style="width: 60px; ">번호</th>
								<th style="width: 250px; text-align: center;">제목</th>
								<th style="width: 200px; text-align: center">작성자</th>
								<th style="width: 100px; text-align: center;">등록일</th>
								<th style="width: 100px;text-align: center;">파일</th>
							</tr>							
							<c:forEach items="${list}" var="notice" varStatus="status"> <!-- jstl 인덱스 생성 -->								
								
							<tbody>
								<tr>												
									<td style="width: 50px;">${pageMaker.total - ((pageMaker.cri.pageNum-1) * pageMaker.cri.amount + status.index)}</td>	
									<c:choose>
									 <c:when test="${notice.noticeDepth > 0}">
										 <td>
										 	<a class="move" href="${notice.noticeNo}" style="padding-left: ${notice.noticeDepth*20}px;">
										 		<%-- <c:forEach begin="1" end="${notice.noticeDepth}">┗&nbsp;</c:forEach> --%>
												┗&ensp;<c:out value="${notice.noticeTitle}" escapeXml="true"/>												
													<c:if test="${notice.replyCnt ne 0}">
														[<c:out value="${notice.replyCnt}"/>]
													</c:if>
										 	</a>
										 </td>
									 </c:when>
									 <c:otherwise>
									 	<td>
									 		<a class="move" href="${notice.noticeNo}"><c:out value="${notice.noticeTitle}" escapeXml="true"/>
										 		<c:if test="${notice.replyCnt ne 0}">
										 			[<c:out value="${notice.replyCnt}"/>]
										 		</c:if>
									 		</a>
									 	</td>
									 </c:otherwise>								 
									</c:choose>													
									<td style="width: 60px; text-align: center;" ><c:out value="${notice.writer}" escapeXml="true"/></td>
									<td style="text-align: center;"><fmt:formatDate value="${notice.noticeDate}" pattern="yyyy.MM.dd"/></td>
									<td style="text-align: center; padding-left: 20px;">
										<c:choose>
											<c:when test="${notice.attachChk == 1}">
												<a style="text-align: center;"><img src="/resources/img/attach.png"></a>
											</c:when>
											<c:otherwise>
												
											</c:otherwise>
										</c:choose>
									</td>																											
								</tr>									
							</tbody>												 								
							</c:forEach>					
						</table>				
						</form>	
						</div>						
					<!-- paging s -->
					<div class="pagination justify-content-center">
						<ul class="pagination">
								<!-- 맨 처음으로  -->
								<c:if test="${pageMaker.prev2}">
									<li class="page-item previous">
										<a class="page-link"href="${pageMaker.start}" aria-label="Previous"> 
											<span aria-hidden="true">&laquo;</span>
										</a>
									</li>
								</c:if>
								<c:if test="${pageMaker.prev}">
									<li class="page-item previous">
										<a class="page-link"href="${pageMaker.startPage-1}" aria-label="Previous"> 
											<span aria-hidden="true">&lt;</span>
										</a>
									</li>
								</c:if>	
								<!-- active 되게 할 페이지 선정 -->																								
								<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
									<li class="page-item ${pageMaker.cri.pageNum == num ? 'active' : ''}">
										<a class="page-link" href="${num}">${num}</a>
									</li>
								</c:forEach>
																
								<c:if test="${pageMaker.next}">
									<li class="page-item next">
										<a class="page-link"href="${pageMaker.endPage+1}" aria-label="Next"> 
											<span aria-hidden="true">&gt;</span>
										</a>
									</li>
								</c:if>
								<!-- 맨 끝으로  -->
								<c:if test="${pageMaker.next2}">
									<li class="page-item next">
										<a class="page-link" href="${pageMaker.realEnd}" aria-label="Next"> 
											<span aria-hidden="true">&raquo;</span>
										</a>
									</li>
								</c:if>
							</ul>
						</div>
						<!--paging e -->
							<form id="actionForm" action="/notice/list" method="get">
								<input type="hidden" name="pageNum" id="pageNum" value="${pageMaker.cri.pageNum}"> 
								<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
								<input type="hidden" name="type" value="${ pageMaker.cri.type }" /> 
								<input type="hidden" name="keyword" value="${ pageMaker.cri.keyword }" />
							</form>
					</div>
				</div>
			</div>
		</div>
</section>
<!--board e-->

<script>
/* 
var totalCount = ${pageMaker.total};	//총 게시물 갯수
var pageNum = ${pageMaker.cri.pageNum};	//페이지 넘버
var amount = ${pageMaker.cri.amount};	//가져오는 게시물 갯수
var realNum = totalCount - (pageNum - 1) * amount;	//총게시물 - (페이지 넘버 - 1) * 가져오는 게시물 갯수  160 - (1 )

var j = 1;

for (var i = realNum; i > realNum-amount; i--) {
	$('#num' + j).html(i);
	j++;
} */

 
$(function() {  	
	$("#search").click(function(e) {
		
		var searchForm = $("#searchForm");
		if (!searchForm.find("option:selected").val()) {
			alert("검색 종류를 선택하세요");
			return false;
		}
		
		if (!searchForm.find("input[name='keyword']").val()) {
			alert("내용을 입력해주세요");
			return false;
		}
		searchForm.find("input[name='pageNum']").val("1");
		e.preventDefault();
		searchForm.submit();	 
	});
	
	var listForm = $("#listForm");
	
	$('#ExcelNotice').click(function() {
		
		listForm.attr("action", "/notice/getExcelFile").attr("method","get"); 
		listForm.submit();
	});
	
	$('#ExcelNoticePage').click(function() {
		listForm.attr("action", "/notice/getExcelFilePage").attr("method","get"); 
		listForm.submit();
	});

//상세보기 	
$('.move').click(
	function(e) {
		e.preventDefault();
		//actionForm에 hidden으로 name 속성 추가 값은 noticeNo 지정, value 속성 추가 값은 ~~ 지정한 후 append
		$('#actionForm').append(
				"<input type='hidden' name='noticeNo' value='"
						+ $(this).attr("href") + "'>");
		$('#actionForm').attr("action", "/notice/get");

		$('#actionForm').submit();
	});


	
});

//페이지번호 링크 처리
$('.page-item a').click(function(e) {
	e.preventDefault();
	$('#pageNum').val($(this).attr('href'));
	$('#actionForm').submit();
});

$('#regNotice').click(function() {
	self.location = "/notice/register";
});

$('#return').click(function() {
	self.location = "/notice/list";
});

</script>
	
<%@include file="../include/footer.jsp" %>