<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<!--board s -->
<section id="tabs" class="project-tab">
	<div class="custom-container" >
		<div class="row custom-mobile" >
			<div class="col-md-12">
				<div class="custom-board-title">
					<h3 class="custom-font-bold">기프티콘</h3>
				</div>
				<sec:authorize access="hasRole('ROLE_ADMIN')">
					<a id="regGift" class="btn btn-primary btn-sm">등록</a>
				</sec:authorize>
					<div class="container" >
					<div class="custom-gift-divide-border">
						<h4 class="custom-divide">food</h4>
					</div>
					<!-- data s -->
					<div class="row-gift">									
						<div class="custom-col-md-3">								
							<div class="custom-gift-items">									
								<div class="gift_area" id="giftArea">
								<c:forEach items="${list}" var="gift">	
						 		<div class="single_gift uploadDiv" id="${gift.giftNo}" >
									<div class="uploadResult"> 
										<ul>
										</ul>
									</div>									
								<a class="move" href="${gift.giftNo}">
								 	 <span><c:out value="${gift.giftName}"/></span><br>																																	 
									 <span><fmt:formatNumber value="${gift.giftPrice}" pattern="###,###"/>원</span>
								</a> 
								</div>
								</c:forEach> 
								</div>
							</div>
						</div>
					</div>																	
					</div>
						
					<!-- data e -->
						<form id="actionForm" action="/gift/list" method="get">
				
						</form>	
			</div>
		</div>
	</div>
</section>
<!--board-end-->

<script>
//즉시 실행함수 - 첨부파일 목록 가져오기
	$(function() {  
		$('.move').click(
				function(e) {
					e.preventDefault();
					//actionForm에 hidden으로 name 속성 추가 값은 noticeNo 지정, value 속성 추가값 지정 후 append
					$('#actionForm').append(
							"<input type='hidden' name='giftNo' value='" + $(this).attr("href") + "'>");								
					$('#actionForm').attr("action", "/gift/get");
					
					$('#actionForm').submit();
				});
		});

		(function(){
			$("#giftArea").find(".single_gift").each(function(){	
			
				var $this = $(this);		
				var li = ""; 
				
				$.get("/gift/getAttachList",{giftNo : $(this).attr("id")}, function(data) {				
					var filePath = data[0].giftUploadPath+ "\\" + data[0].giftUuid + "_" + data[0].giftFileName;		 
					filePath = filePath.replace(new RegExp(/\\/g), "/");
					li += "<img class='giftImg' src='/giftUpload/display?giftFileName="+filePath+"'>"						  		
						  		$this.find(".uploadResult").find("ul").append(li);
				});
			});
		})(); 

	$('#regGift').click(function() {
		self.location = "/gift/register";
	});
</script>

