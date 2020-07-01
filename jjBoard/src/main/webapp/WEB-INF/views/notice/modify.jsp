<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../include/header.jsp" %>

<!--board s -->
<section id="tabs" class="project-tab">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="custom-board-title">
                    <h3 class="custom-font-bold">공지사항 수정</h3>
                </div>
                <form method="post" action="/notice/modify" role="form" id="modifyForm">
                <input type="hidden" name="noticeNo" value="${notice.noticeNo}"/>
                           
                <div class="form-group">
                    <label>제목</label>
                    <input class="form-control" name="noticeTitle" value="${notice.noticeTitle}" id="noticeTitle" maxlength="60">
                </div>
                <div class="form-group">
					<label>작성자</label> 
					<input readonly class="form-control" name="writer" value='<c:out value="${notice.writer}"/>'>
				</div>  
                <div class="form-group">
                    <label>내용</label>
                    <textarea class="form-control" name="noticeContent" id="custom-notice-content" wrap="hard" style="resize : none; height: 650px; "><c:out value="${notice.noticeContent}"/></textarea>
                	<br>
                	<label id="counting" style="font-size: 14px;">0</label> <label>/ 1000</label>
                </div>
                <div class="form-group">
	                    <label>비밀번호</label>
	                    <input type="password" class="form-control" name="noticePw" value="${notice.noticePw}" id="noticePw">
	                    <div class="custom-red-font custom-text-right" id="memberPwErrorMsg"></div>
	            </div>
	            <div class="form-group">
						<label>첨부파일</label><br>

							<input type="file" name="uploadFile" id="uploadFile" multiple>						
							<div class="uploadResult" id="uploadResult"><br>
								<ul style="display: flex">
								</ul>
							</div>
							
					</div>	
	                <br>                
	                <hr>
                <div class="form-group text-center">                
                    <button type="button" id="modify" class="btn btn-primary btn-sm">수정완료</button>
                    <button type="button" class="btn btn-secondary btn-sm" id="cancel">돌아가기</button>
                </div>
                </form>
            </div>
        </div>
    </div>
</section>
<!--board e -->

<script>

//파일의 확장자와 크기를 설정하고 이를 검사하는 함수
var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
var maxSize = 5242880; //5MB
	
function checkExtension(fileName, fileSize) {
		if(fileSize >= maxSize) {	//파일 크기가 maxSize를 초과하는 경우
			alert("업로드 파일 사이즈가 " + (maxSize-fileSize) + "초과되었습니다.");
			return false;				
		}
		if(regex.test(fileName)) {	//파일 확장자가 exe, sh, zip, alz인 경우
			alert("업로드 할 수 없는 파일입니다.");
			return false;
		}			
		return true;
	 }//END checkExetension()
	
	 var fileLength;
		
	 (function() {	
			$.getJSON("/notice/getAttachList", { noticeNo : ${notice.noticeNo}}, 
			function(data) {	
				fileLength = data.length;
				console.log('inner getJSON : ' + fileLength);
				var li = "";
				$(data).each(function(index, obj){					
					//이미지가 아니면 attach.png 표시
					if(obj.fileType == false) {
						var filePath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
						var fileLink = filePath.replace(new RegExp(/\\/g),"/");		// \를 /로 바꾸라는 정규표현식		
						li += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"' data-type='" + obj.fileType+ "'><div style='margin-right:20px;'><span>" + obj.fileName + "</span>" + 					   
							  "<button data-file=\'" + filePath + "\' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><a href='/download?fileName="+filePath+"'><br>"+"<img src='/resources/img/attach2.png'></a></div></li>";				 	
					
					} else {
						//이미지이면 그대로 표시				
						var filePath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);	
						var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
						originPath = originPath.replace(new RegExp(/\\/g),"/");		// \를 /로 바꾸라는 정규표현식
						li += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"' data-type='" + obj.fileType+ "'><div><span>" + obj.fileName + "</span>" + 
							  "<button data-file=\'" + filePath + "\' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><a href='/download?fileName="+originPath+"'><br>"+"<img src='/display?fileName="+filePath+"'></a></div></li>";
					}	
				});	
						$('.uploadResult ul').html(li);		
					}).fail(function(xhr, status, err) {
						 if(error) {
							error(err);
						} 
			});//END JSON	
		})(); 

	 
	  $("input[type='file']").change(function(e){
		console.log("현재뿌려진파일들개수 : " + fileLength);
		  
		 var formData = new FormData();	//jQuery를 이용하는 경우 파일 업로드는 FormData라는 객체를 이용. 쉽게 말하면 가상의 <form>태그
		 var inputFile = $("input[name='uploadFile']");
		 var files = inputFile[0].files;
		
		 var jinju = fileLength + files.length;
		 console.log("현재뿌려진파일들+체인지 : " + jinju);
		 
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
				console.log("업로드에이젝스 : " + result.length);
				fileLength = fileLength + result.length;
				console.log("업로드에이젝스후개수 : " + fileLength);
				showUpLoadedFile(result);
			},error : function(error) {
				alert("upload not ok");
			}		
		});//END ajax
		});//END click


		
 

function showUpLoadedFile(result) {
	var li = "";
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
				  "<button data-file=\'" + filePath + "\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
					+ "<img src='/resources/img/attach.png'></div></li>";
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
				  "<button data-file=\'" + filePath + "\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
				  + "<img src='/display?fileName="+filePath+"'></div></li>";
		}	
	});	
	$('.uploadResult ul').append(li);
}
		
$(".uploadResult").on("click", "button", function(e){
	if(confirm("파일을 삭제하시겠습니까?")) {
		var targetLi = $(this).closest("li");
		targetLi.remove();
		
		fileLength = fileLength - 1;
		console.log(fileLength);
		
	} else {
		return false;
	}
});	//END X표시 클릭 이벤트 처리
		
$(document).ready(function(){
	var contentLength = $('textarea').val().length;
	console.log(contentLength);
	$("#counting").html(contentLength);
});

 var formObj = $("form");
 var modifyForm = $("#modifyForm");

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
 
 $(function(e){			
		$("#modify").click(function(){	
			var noticeTitleFind = $.trim(modifyForm.find("input[name='noticeTitle']").val());
			var writerFind = $.trim(modifyForm.find("input[name='writer']").val());
			var noticeContentFind= $.trim(modifyForm.find("textarea[name='noticeContent']").val());
			var noticePw = $.trim(modifyForm.find("input[name='noticePw']").val());
			var noticePw2 = $.trim(modifyForm.find("input[name='noticePw']").val().length);
			
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
				formObj.append(tags).submit(); 	
				
				modifyForm.attr("action", "/notice/modify").attr("method","post"); 
				modifyForm.submit();
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
		
		if (remain == 0 || remain < 0) {          
         alert("최대 입력은 1000자까지 가능합니다.");
         $(this).val($(this).val().substring(0, 1000));
         $('#counting').html(1000);
     }
	}); 
	
   
			/* var ctrlDown = false;
			var ctrlKey = 17, vKey = 86, cKey = 67; 
			
			if (inputLength == 1000 || inputLength < 0) { 
				
				/* $(document).keydown(function(e) {
						
					 
				if (eventd.keyCode == ctrlKey)
					alert("최대 입력은 1000자까지 가능합니다.");
					 ctrlDown = true; 
				}).keyup(function(e){
					alert("최대 입력은 1000자까지 가능합니다.");
				if (e.keyCode == ctrlKey) 
					
					ctrlDown = false;
			}); */
   
	$("#cancel").click(function(){
		if(confirm("수정을 취소 하시겠습니까?") == true) { 
			modifyForm.attr("action","/notice/get").attr("method","get");
			modifyForm.submit();
		}else {
 		   false;
 	   }
	});
</script>
	   
<%@include file="../include/footer.jsp" %>