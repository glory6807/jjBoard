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
                    <h3 class="custom-font-bold">공지사항 등록</h3>
                </div>               
                <form id="registerForm" role="form" action="/notice/register" method="post">
	                <div class="form-group">
	                    <label>제목</label>
	                    <input class="form-control" name="noticeTitle" id="noticeTitle" maxlength="60">
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
					<div class="row">
						<div class="col-lg-12">
							<div class="panel panel-default">
								<div class="panel-heading">
									<label>첨부파일</label>
								</div>
								<div class="panel-body">
									<div class="form-group uploadDiv">
										<input type="file" name="uploadFile" multiple>
									</div>
									<!-- 업로드 결과 출력 -->
									<div class="uploadResult">
										<ul style="display: flex">

										</ul>
									</div>
								</div>
							</div>
						</div>
					</div>
						
	                <br>                
	                <hr>
	                
	                <div class="form-group text-center">             
	                    <button type="submit"  id="register" class="btn btn-primary btn-sm">등록</button>
	                    <button type="button"  id="cancel" class="btn btn-secondary btn-sm">취소</button>                                     
	                </div>
                </form>              
            </div>
        </div>
    </div>
</section>
<!--board-end-->

<script>

	var fileLength = 0;

$(function(e){
	/* var formObj = $("form[role='form']");
	$("button[type='submit']").click(function(e){
		e.preventDefault();	//첨부파일 관련 처리를 할 수 있도록 기본 동작 막음
		console.log('submit clicked!');
		
		
	}); */
	
	//파일의 확장자와 크기를 설정하고 이를 검사하는 함수
	 var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	 var maxSize = 5242880; //5MB
	 
	 function checkExtension(fileName, fileSize) {
			if(fileSize >= maxSize) {	//파일 크기가 maxSize를 초과하는 경우
				alert("업로드 파일 사이즈가 " + (fileSize - maxSize) + "초과되었습니다.");
				return false;				
			}
			if(regex.test(fileName)) {	//파일 확장자가 exe, sh, zip, alz인 경우
				alert("업로드 할 수 없는 파일입니다.");
				return false;
			}			
			return true;
		 }//END checkExetension()

		 
		$("input[type='file']").change(function(e){
			fileLength;
			console.log("현재뿌려진파일들개수 : " + fileLength);
			 var formData = new FormData();	//jQuery를 이용하는 경우 파일 업로드는 FormData라는 객체를 이용. 쉽게 말하면 가상의 <form>태그
			 var inputFile = $("input[name='uploadFile']");
			 var files = inputFile[0].files;
			 
			 var jinju = fileLength + files.length;
			 console.log(jinju);
			 
			 if(jinju > 3) {
				 alert("최대 3개까지 업로드 가능합니다. 다시 선택해주세요.");
			 	 return false;
			 }
			 
			 /* add filedata to formdata */
			 for (f of files) {
				 if(files.length > 3) {
					 alert("최대 3개까지 업로드 가능합니다. 다시 선택해주세요.");
					 return false;
				 }
			 	
			 	alert('fileName : ' + f.name + '\nsize : ' + f.size);
			 	if(!checkExtension(f.name, f.size)) {	
					return;
				} 
					formData.append('uploadFile',f);			
			 }
				
			$.ajax({					
				url : '/uploadAjaxAction',					
				processData : false,
				contentType : false,
				data : formData,
				type : 'POST',
				dataType : 'json',	//반환된 정보를 처리하도록 추가
				success : function(result) {	
					alert("upload ok");
					fileLength = fileLength + result.length;   
					console.log(result);						
					showUpLoadedFile(result);
				},error : function(error) {
					alert("upload not ok");
				}		
			});//END ajax
			});//END click
		 
	$("button[type='submit']").click(function(e){
		e.preventDefault();
		console.log('submit clicked!');
	});
	
	function showUpLoadedFile(result) {
		var li = "";
		console.log("쇼리스트 : " + result.length);
		fileLength = fileLength + result.length;
		console.log(fileLength);
		$(result).each(function(index, obj){						
			//$('.uploadResult ul').append('<li>' + obj.fileName + '</li>');
			
			//이미지가 아니면 attach.png 표시
			if(!obj.image) {
				var filePath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
				var fileLink = filePath.replace(new RegExp(/\\/g),"/");		// \를 /로 바꾸라는 정규표현식
				//li += "<li><img src='/resources/img/attach.png'>" + obj.fileName + "</li>";
				//li += "<li><div><a href='/download?fileName="+filePath+"'>"+"<img src='/resources/img/attach.png'>" + obj.fileName + "</a>"
				//	   + "<span data-file=\'" + filePath + "\' data-type='image'>x</span>"+"</div></li>";
				li += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"' data-type='" + obj.image+ "'><div><span>" + obj.fileName + "</span>" + 
					  "<button type='button' data-file=\'" + filePath + "\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
						+ "<img src='/resources/img/attach2.png'></div></li>";
			} else {
				//이미지이면 그대로 표시
				//li += ('<li>' + obj.fileName + '</li>');
				var filePath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
				//var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
				//originPath = originPath.replace(new RegExp(/\\/g),"/");		// \를 /로 바꾸라는 정규표현식
				
				//li +ㄴ= "<li><img src='/display?fileName=" + filePath + "'></li>";
				//li += "<li><a href=\"javascript:showImage(\'" + originPath + "\')\"><img src='/display?fileName=" + filePath + "'></a>"
				//	  + "<span data-file=\'" + filePath + "\' data-type='image'>x</span>"+"</li>";
				li += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"' data-type='" + obj.image+ "'><div><span>" + obj.fileName + "</span>" +
					  "<button type='button' data-file=\'" + filePath + "\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
					  + "<img src='/display?fileName="+filePath+"'></div></li>";
			}	
		});	
		$('.uploadResult ul').append(li);
	}
		
	$(".uploadResult").on("click", ".btn-circle", function(e){
		console.log("clicked!")
		var targetFile = $(this).data("file");
		var type = $(this).data("type");
		console.log(targetFile);
		
		var targetLi = $(this).closest("li");
		$.ajax({
			url: '/deleteFile',
			data: {fileName: targetFile, type: type},				
			dataType: 'text',
			type: 'POST',
			success: function(result){
				
				fileLength = fileLength - 1;
				console.log("삭제ajax : " + fileLength);
				
				alert(result);
				targetLi.remove();
				return false;
			}, error : function(error){
				alert(error);
			}
		});
	});
			
});//END docReady

var formObj = $("form[role='form']");
var registerForm = $("#registerForm");
	
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
		$("#register").click(function(){	
			var noticeTitleFind = $.trim(registerForm.find("input[name='noticeTitle']").val());
			var writerFind = $.trim(registerForm.find("input[name='writer']").val());
			var noticeContentFind= $.trim(registerForm.find("textarea[name='noticeContent']").val());
			var noticePw = $.trim(registerForm.find("input[name='noticePw']").val());
			var noticePw2 = $.trim(registerForm.find("input[name='noticePw']").val().length);
			
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
				
				var tags = "";			
				$('.uploadResult ul li').each(function(i,obj){
					var o = $(obj);
					tags += "<input type='hidden' name='attachList["+i+"].fileName' value='" + o.data("filename") + "'>";
					tags += "<input type='hidden' name='attachList["+i+"].uuid' value='" + o.data("uuid") + "'>";
					tags += "<input type='hidden' name='attachList["+i+"].uploadPath' value='" + o.data("path") + "'>";
					tags += "<input type='hidden' name='attachList["+i+"].fileType' value='" + o.data("type") + "'>";
				});	
				console.log(tags);
				$("form[role='form']").append(tags).submit();
				
				registerForm.attr("action", "/notice/register").attr("method","post"); 
				registerForm.submit();
				return false;
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