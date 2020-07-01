<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../include/header.jsp" %>

<!--board s-->
<section id="tabs" class="project-tab">
    <div class="container">
        <div class="custom-gift-divide-border">
            <h3 class="custom-font-bold">${mygift[0].giftList[0].giftName}</h3>                  
        </div>       
        <div class="section-top-border">
            <div class="row">
                <div class="col-md-3">
	                <div class="gift_area" id="giftArea">
	                    <div class="single_gift uploadDiv" id="${mygift[0].giftList[0].giftNo}" >                  
							<div class="uploadResult"> 
								<ul>							
									<!-- 사진 -->
								</ul>
							</div>
	               	 	</div>
	               	 </div>
               	 </div>
                <div class="col-md-9 mt-sm-20">            
                    <p>가격 : <fmt:formatNumber value="${mygift[0].giftList[0].giftPrice}" pattern="###,###"/>원</p>
                    <p>구성 : ${mygift[0].giftList[0].giftSet}</p>
                    <p>구입일자 : <fmt:formatDate value="${mygift[0].buyingDate}" pattern="yyyy.MM.dd"/></p>
		            <c:if test="${!empty mygift[0].expireDate}">
		           	 <p>만료일자 : <fmt:formatDate value="${mygift[0].expireDate}" pattern="yyyy.MM.dd"/></p> 
		            </c:if>    
                       <form action="/myGift/extend" method="POST" id="extendForm">
		                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">		                             
		                    <input type="hidden" name="myGiftNo" value="${mygift[0].myGiftNo}"/>                    
		                    <input type='hidden' name="expireDate" value="${mygift[0].expireDate}"/>	            		
		                    <input type='hidden' name="memberId" value="${mygift[0].memberId}"/>	            		
		                    <input type="hidden" name="pageNum"  value="${cri.pageNum }"> 
							<input type="hidden" name="amount" value="${cri.amount}">
                       	</form>  
                       	
                       	<form action="/myGift/refund" method="POST" id="refundForm">
                       		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                       		<input type="hidden" name="myGiftNo" value="${mygift[0].myGiftNo}"/>
                       		<input type="hidden" value="${mygift[0].status}"/>	                    
                       		<input type="hidden" value="${mygift[0].extendChk}"/>	                    
		                    <input type='hidden' name="memberId" value="${mygift[0].memberId}"/>	            		
		                    <input type="hidden" name="pageNum"  value="${cri.pageNum }"> 
							<input type="hidden" name="amount" value="${cri.amount}">
                       	</form>  
                </div>
            </div>
			<div class="custom-gift-divide-border"></div>
			<br>
			<form id="listForm" action="/myGift/list" method="get">
				<input type='hidden' name="memberId" value="${mygift[0].memberId}"/>
				<input type="hidden" name="pageNum" id="pageNum" value="${cri.pageNum}"> 
				<input type="hidden" name="amount" value="${cri.amount}">
			</form>
			<button type="button" class="btn btn-primary float-left custom-button-gift" id="listBtn">LIST</button>
			<c:if test="${!empty mygift[0].expireDate}">
				<div class="pull-right">
					<c:if test="${mygift[0].status == 0 && mygift[0].extendChk == 0}">
						<button type="button" class="btn btn-primary custom-button-gift" id="extendBtn">기간연장</button>										
					</c:if>
					<c:if test="${mygift[0].status == 0}">
					<button type="button" class="btn btn-primary custom-button-gift" id="refundBtn">환불</button>
					</c:if>
				</div>
			</c:if>
		</div>
    </div>
</section>
<!--board e-->
<script>

//즉시 실행함수 - 첨부파일 목록 가져오기
(function(){
	$("#giftArea").find(".single_gift").each(function(){	
		var $this = $(this);			
		var li = ""; 		
		$.get("/myGift/getAttachList",{giftNo : $(this).attr("id")}, function(data) {			
			var filePath = data[0].giftUploadPath+ "\\" + data[0].giftUuid + "_" + data[0].giftFileName;
		 
			filePath = filePath.replace(new RegExp(/\\/g), "/");

			li += "<img class='giftImg' src='/giftUpload/display?giftFileName="+filePath+"'>"						  		
				  		$this.find(".uploadResult").find("ul").append(li);
		});//END JSON	
	});
	})(); 

	$(function() {
		var memberIdValidate = '${param.memberId}';
		var principalUsernmae = '<sec:authorize access="isAuthenticated()"><sec:authentication property="principal.username"/></sec:authorize>';
		
		if(memberIdValidate != principalUsernmae){
			location.href='/accessError';
		}
		
		var extendForm = $("#extendForm");
		var refundForm = $("#refundForm");
		var listForm = $("#listForm");

		$('#extendBtn').on("click", function(e) {
			e.preventDefault();
			if(confirm("기간을 연장하시겠습니까?") == true) { 
				extendForm.submit();
			 } else {
	    		   return false;
	    	   }					
		});
		
		$('#refundBtn').on("click", function(e) {
			e.preventDefault();
			if(confirm("환불하시겠습니까?") == true) { 
				refundForm.submit();
			 } else {
	    		   return false;
	    	   }			
		});
		
		$('#listBtn').on("click", function(e) {
			e.preventDefault();
			listForm.submit();
		});
	});
	
</script>
<%@include file="../include/footer.jsp" %>