<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- <%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%> --%>
<div class="col-md-3">
	<div class="section-top-border">
		<div class="row">
			<div class="col-md-7 mt-sm-30">
				<h3 class="mb-20">마이페이지</h3>
				<div class="">
					<ul class="unordered-list">
						<li><a class= '${memberInfo == null? "" : "custom-active"}' href="/member/myInfo" id="myInfoMove">내 정보 조회</a></li>
						<li><a class= '${myReserveList == null? "" : "custom-active"}' href="/reserve/list" id="myReserveMove">예매 내역</a></li>
		                  <li><a class= '${myReviewList == null? "" : "custom-active"}' href="/myReview/list" id="myReviewMove">내 리뷰</a></li>
		                  <li><a class= '${myCommentList == null? "" : "custom-active"}' href="/myComment/myList" id="myCommentMove">내 한줄평</a></li>
						<li><a class='${mygift == null? "" : "custom-active" }' href="/myGift/list" id="myGiftMove">내 기프티콘</a></li>
						<li><a class='${mySuggest == null? "" : "custom-active" }' href="/member/mySuggst" id="mySuggestMove">내 건의사항</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- <sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.username" var="loginUsername" />
</sec:authorize> -->
<script>
	$(function(){
		$('#myInfoMove').on("click", function(e){
			e.preventDefault();
			location.href="/member/myInfo?memberId=${loginUsername}";
		});
		
		$('#myReserveMove').on("click", function(e){
			e.preventDefault();
			location.href="/reserve/list?memberId=${loginUsername}";
		});
		
		$('#myGiftMove').on("click", function(e){
			e.preventDefault();
			location.href="/myGift/list?memberId=${loginUsername}";
		});

		$("#mySuggestMove").on("click", function(e){
			e.preventDefault();
			location.href="/member/mySuggest?keyword=${loginUsername}&type=W";
		});

		$("#myReviewMove").on("click", function(e){
			e.preventDefault();
			location.href="/myReview/list?memberId=${loginUsername}";
		});

		$("#myCommentMove").on("click", function(e){
			e.preventDefault();
			location.href="/myComment/myList?memberId=${loginUsername}";
		});
		
		
		
		
	});
</script>