<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<!--board s -->
<section id="tabs" class="project-tab">
	<div class="container custom-mobile">
		<div class="custom-gift-divide-border">
			<h3 class="custom-font-bold">
				<input class="giftName" value="${gift.giftName}" />
			</h3>
		</div>
		<div class="section-top-border">
			<div class="row">
				<div class="col-md-3">
					<div class="panel panel-default">
						<div class="panel-body">
							<div class="uploadResult">
								<ul>
									<!-- 사진 -->
								</ul>
							</div>
						</div>
					</div>
				</div>
				<!-- data s -->
				<div class="col-md-9 mt-sm-20">
					<div class="form-group">
						<label>No&emsp; : &ensp;</label>
						<input value="${gift.giftNo}" class="giftNo" readonly>
					</div>
					<div class="form-group">
						<label>가격&ensp; : &ensp;</label>
						<input type="hidden" name="giftPrice" class="giftPrice" value="${gift.giftPrice}" readonly>
						<fmt:formatNumber   pattern="###,###" value="${gift.giftPrice}" />&nbsp;원
					</div>
					<div class="form-group">
						<label>구성&ensp; : &ensp;</label>
						<input value="${gift.giftSet}" class="giftSet" readonly>
					</div>
					<div class="qty mt-5">
						<span class="minus bg-dark">-</span> 
							<input type="number" class="num-count" id="qty" name="qty" value="1">
						<span class="plus bg-dark">+</span>
						<span class="custom-price"><input name="totalPrice" class="totalPrice" value="${gift.giftPrice}" readonly>원</span>
					</div>
				</div>
				<!-- data e -->
			</div>
		</div>
		<div class="custom-divide-border-top">
			<span class="custom-pull-right">
				<label>총 구매금액&emsp; : &emsp;</label>
					<input name="totalPrice" class="totalPrice" value="${gift.giftPrice}" readonly>원
			</span>
			<br><br>			
		</div><br>
	<!-- 버튼 s -->		
	<div class="float-left">
		<button class="btn btn-primary float-left custom-button-gift pull-left" id="list">LIST</button>
	</div>		
	<div class="float-right">	
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<form action="/gift/modify"  method="get" id="operForm" style="float: left">
				<input value="${gift.giftNo}" name="giftNo" type="hidden">		
				<button type="submit" class="btn btn-primary custom-button-gift" data-oper='modify'>수정</button>
			</form>
			
			<form action="/gift/remove" method="post" role="form"  style="float: left">				
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">	
				<input value="${gift.giftNo}" name="giftNo" type="hidden">				
				<button type="submit" class="btn btn-danger custom-button-gift" data-oper="remove">삭제</button>
			</form>
		</sec:authorize>
		
			<form action="/gift/paying" method="post" id="payRealForm" style="float: left">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">	
					<sec:authorize access="isAuthenticated()">
						<input type="hidden" name="memberId" id="memberInput" value="<sec:authentication property='principal.username'/>">			
					</sec:authorize>
					
					<div id="payHere">
						<!-- 결제 -->
					</div>
					<sec:authorize access="isAnonymous() or hasRole('ROLE_MEMBER')">
						<button type="button" id="payment" class="btn btn-primary custom-button-gift" >구입</button>
					</sec:authorize>
			</form>		
	</div>	
	<!-- 버튼 e -->				
	</div>	
</section>
<!-- board e -->

	<!-- 비회원이 결제버튼 눌렀을 때 확인하기  -->
	<sec:authorize access="isAuthenticated()">
		<c:set value="<sec:authentication property='principal.username'/>" var="userId"></c:set>
	</sec:authorize>
	<!-- 비회원이 결제버튼 눌렀을 때 확인하기  -->
	
<script>

//기프티콘 수량 변경
$(document).ready(function () {
	/* 처음에 총 합계금액에 정규표현식 적용해서 표시 */
	var total = $('.totalPrice').val();
    	total = total.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    	parseInt($('.totalPrice').val(total));
    
    //+를 클릭했을 때
    $('.num-count').prop('disabled', true);
    $(document).on('click', '.plus', function () {
        $('.num-count').val(parseInt($('.num-count').val()) + 1);
        $('.totalPrice').val(parseInt($('.giftPrice').val() * $('.num-count').val()));  
        var total = $('.totalPrice').val();
        if(!total == 0) {
        	total = total.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        	parseInt($('.totalPrice').val(total));
        }           
    });
    
  //-를 클릭했을 때
    $(document).on('click', '.minus', function () {
        $('.num-count').val(parseInt($('.num-count').val()) - 1);
        var gift = $('.giftPrice').val();
        gift = parseInt(gift);
        var total = $('.totalPrice').val();
        total = total.replace(/\,/g,'');	//연산을 위해서 정규표현식 원래대로 되돌리기
     
        $('.totalPrice').val(parseInt(total-gift));        
       
        if(!total == 0) {
        	var total = $('.totalPrice').val();
        	total = total.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        	
        	parseInt($('.totalPrice').val(total));
        }
        
        if ($('.num-count').val() == 0) {
            $('.num-count').val(1);
            alert("1개 이상 구입 가능");
            $('.totalPrice').val(parseInt($('.giftPrice').val() * 1));
        }
    });
}); 

  //결제 함수 호출
	$(function(){
		$('#payment').on("click", function(e){
			e.preventDefault();
			var userConnect = '<c:out value="${userId}"/>';
			if(!userConnect) {
				alert('로그인이 필요한 서비스입니다.');
				location.href="/customLogin";
				return;
			}
			var giftNo = ${gift.giftNo};
			var giftName = $('.giftName').val();
			var giftPrice = $('.totalPrice').val();
			giftPrice = giftPrice.replace(/\,/g,'');
			giftPrice = parseInt(giftPrice);
			console.log(giftPrice);
			var giftSet = $('.giftSet').val();
			var qty = $('#qty').val();
			payment(giftNo, giftName, giftPrice, giftSet, qty);
		});
	})
  
  //결제 함수
	function payment(giftNo, giftName, giftPrice, giftSet, qty) {	
	
		var IMP = window.IMP; // 생략가능
		IMP.init('imp92933704'); // 'iamport' 대신 부여받은 "가맹점 식별코드"를 사용
	
		IMP.request_pay({
			pg: 'inicis', // version 1.1.0부터 지원.
			pay_method: 'card',
			merchant_uid: 'merchant_' + new Date().getTime()+30,
			name: $('.giftName').val(),
			amount: 4000 * $('#qty').val(),
			buyer_email: 'iamport@siot.do',
			buyer_name: '홍길동',
			buyer_tel: '010-1234-5678',
			buyer_addr: '서울특별시 강남구 삼성동',
			buyer_postcode: '123-456'
		}, function(rsp) {
			if (rsp.success) {
				//컨트롤러로 값
				var msg = '결제가 완료되었습니다.';
				// payHere에 input hidden append 를 시켜주고 그걸 form
				var str = "<input type='hidden' value='"+ giftNo +"' name='giftNo'/>";
				str += "<input type='hidden' value='"+ giftName +"' name='giftName'/>";
				str += "<input type='hidden' value='"+ giftPrice +"' name='giftPrice'/>";
				str += "<input type='hidden' value='"+ giftSet +"' name='giftSet'/>";
				str += "<input type='hidden' value='"+ qty +"' name='qty'/>";
				
				$('#payHere').append(str);
				$('#payRealForm').submit(); 
			} else {
				var msg = '결제에 실패하였습니다.';
				msg += '에러내용 : ' + rsp.error_msg;
				$('#payHere').html("");
			}
			alert(msg);			
		});
	}

	//form 전송
	$(function(){
	   var formObj = $("form");
	   $('button').on("click", function(e){
	      e.preventDefault();	      
	      var operation = $(this).data("oper");
	      if(operation === 'remove'){	//삭제 버튼
	    	   if(confirm("정말로 삭제하시겠습니까?") == true) { 
		         formObj.attr("action", "/gift/remove");
		         formObj.submit();
	    	   } else {
	    		   false;
	    	   }      
	      }else if(operation === 'modify'){
	         formObj.attr("action", "/gift/modify");
	         formObj.submit();
	      } 	      
	   });	  	
	}); 

	//첨부파일 목록 가져오기
	(function() {	
		$.getJSON("/gift/getAttachList", { giftNo : ${gift.giftNo}}, function(data) {					
			var li = "";
			$(data).each(function(index, obj){								
				//이미지이면 그대로 표시				
				var filePath = encodeURIComponent(obj.giftUploadPath + obj.giftUuid + "_" + obj.giftFileName);				
				li += "<li data-path='"+obj.giftUploadPath+"' data-uuid='"+obj.giftUuid+"' data-fileName='"+obj.giftFileName+"'><div>" + 
					  "<img src='/giftUpload/display?giftFileName="+filePath+"' style='width:100%'></div></li>";		
			});	
					$('.uploadResult ul').append(li);		
				}).fail(function(xhr, status, err) {
					/* if(error) {
						error(err);
					} */
		});//END JSON	
	})();  
    
    $("#list").click(function(){ 
    	self.location='/gift/list';
    });
    
</script>

