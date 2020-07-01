<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../include/header.jsp" %>

<!--board-start-->
<section id="tabs" class="project-tab">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="custom-board-title">
                    <h3 class="custom-font-bold">답글 등록</h3>
                </div>               
                <form id="registerReForm" role="form" action="/notice/registerRe" method="post">
	                <input type="hidden" name="noticeNo" value="${notice.noticeNo}"/>
	                <input type="hidden" name="originNo" value="${notice.originNo}"/>
	                <input type="hidden" name="groupOrd" value="${notice.groupOrd}"/>
	             	
                	<input type="hidden" name="noticeDepth" value="${notice.noticeDepth}"/>
	                <div class="form-group">
	                    <label>제목</label>
	                    <input class="form-control" name="noticeTitle" id="noticeTitle" maxlength="60" required>
	                </div>
	                <div class="form-group">
	                    <label>작성자</label>
	                    <input class="form-control" name="writer" id="writer" maxlength="14">
	                </div>
	                <div class="form-group">
	                    <label>내용</label>              
	                   		<textarea class="form-control" name="noticeContent" id="custom-notice-content" wrap="hard" 
	                   				  style="resize: none; white-space :pre-wrap; height: 650px;" maxlength="1000" ></textarea>                  
	                    <br>
	                    <label id="counting" style="font-size: 14px;">0</label> <label>/ 1000</label>
	                </div>
	                <div class="form-group">
	                    <label>비밀번호</label>
	                    <input type="password" class="form-control" name="noticePw" id="noticePw">
	                    <div class="custom-red-font custom-text-right" id="memberPwErrorMsg"></div>
	                </div>	
	                <br>                
	                <hr>
	                
	                <div class="form-group text-center">             
	                    <button type="submit"  id="registerRe" class="btn btn-primary btn-sm">등록</button>
	                    <button type="button"  id="cancel" class="btn btn-secondary btn-sm">취소</button>                                     
	                </div>
                </form>              
            </div>
        </div>
    </div>
</section>
<!--board-end-->

<script>
var formObj = $("form[role='form']");
var registerReForm = $("#registerReForm");
	
var regex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,15}$/;

$('#noticePw').keyup(function(e) {
	
	v = $(this).val();
	vLeng = $(this).val().length;

	if (regex.test(v)) {
		$('#memberPwErrorMsg').html('사용 가능합니다!');
		$(this).focus();
	}else{
		$('#memberPwErrorMsg').html('영어/숫자/특수문자의 조합으로 최소 8자리, 최대 15자리로 입력해주세요');
	}
	
	if(vLeng > 15) {
		alert("15자 이하로 입력해주세요");
	}
	
});
	
/* 공백 유효성 검사 */
$(function(e){			
	$("#registerRe").click(function(){	
		var noticeTitleFind = $.trim(registerReForm.find("input[name='noticeTitle']").val());
		var writerFind = $.trim(registerReForm.find("input[name='writer']").val());
		var noticeContentFind= $.trim(registerReForm.find("textarea[name='noticeContent']").val());
		var noticePw = $.trim(registerReForm.find("input[name='noticePw']").val());
		var noticePw2 = $.trim(registerReForm.find("input[name='noticePw']").val().length);
		
		console.log(noticePw2);
		
		if (!noticeTitleFind){
			alert("제목을 입력해주세요");
			return false;
		} else if (!writerFind){
			alert("작성자를 입력해주세요");
			return false;
		} else if(!noticeContentFind){
			alert("내용을 입력해주세요");
			return false;
		} else if(!noticePw){
			alert("비밀번호를 입력해주세요");
			return false;
		} 
		var regex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,15}$/;			

		if (regex.test(noticePw)) {
			registerReForm.attr("action", "/notice/registerRe").attr("method","post"); 
			registerReForm.submit();
		}else{
			alert('비밀번호를 형식에 맞게 입력해주세요');
			return false;
		}
		
		if(noticePw2 > 15) {
			alert("15자 이하로 입력해주세요");
		}

	});
});
	
	/* 제목 글자수 counting하고 제한 글자수만큼 자르기 */
	$('#noticeTitle').keyup(function(){
		var titleLength = $(this).val().length;
		console.log(titleLength);
		
		if (titleLength == 60) {          
            alert("최대 입력은 60자까지 가능합니다.");
            $(this).val($(this).val().substring(0, 60));
        }
	});
	
	/* 작성자 글자수 counting하고 제한 글자수만큼 자르기 */
	$('#writer').keyup(function(){
		var writerLength = $(this).val().length;
		console.log(writerLength);
		
		if (writerLength == 14) {          
            alert("최대 입력은 14자까지 가능합니다.");
            $(this).val($(this).val().substring(0, 14));
        }
	});
	
	/* 본문 글자수 counting하고 제한 글자수만큼 자르기 */
	$('textarea').keyup(function(){
		var contentLength = $(this).val().length;
		var remain = 1000 - contentLength;
		console.log(remain);
		
		$('#counting').html(contentLength);
		
		if (contentLength == 1000 || contentLength > 1000) {          
            alert("최대 입력은 1000자까지 가능합니다.");
            var trim = $.trim($(this).val().substring(0, 1000));
            (this).val(trim);
            $('#counting').html(1000);
        }
	});
	
 	function Limit(obj){
	    var maxLength = parseInt(obj.getAttribute("maxlength"));
	    if(obj.value.length > maxLength){
	        alert("1000자이하로입력하세요");
	        obj.value = obj.value.substring(0, 1000);
	    }
	} 
	
 	
 	$(document).ready(function(e){
	 	$("#noticeTitle").focusout(function(){
	 		var noticeTitle2 = $('#noticeTitle').val();
	 		console.log(noticeTitle2);
	 		if(noticeTitle2 == '') {
	 			alert("제목을 입력해주세요");
	 		} else {
	 			false;
	 		}
	 	});
	 	$("#writer").focusout(function(e){
	 		var noticeWriter2 = $('#writer').val();
	 		console.log(noticeWriter2);
	 		if(noticeWriter2 == '') {
	 			alert("작성자를 입력해주세요");
	 			false;
	 		} else {
	 			false;
	 		}
	 	});
	 	
	 	$("textarea").focusout(function(){
	 		var textarea = $('textarea').val();
	 		console.log(textarea);
	 		if(textarea == '') {
	 			alert("내용을 입력해주세요");
	 		} else {
	 			false;
	 		}
	 	});
 	});
	
	/* 취소 클릭했을 때 조회 화면으로 */
	$("#cancel").click(function(){
		if(confirm("정말로 취소하시겠습니까?") == true) { 
			self.location = "/notice/list";
		}else {
 		   false;
 	   }
	});
	
	
	
</script>

<%@include file="../include/footer.jsp" %>