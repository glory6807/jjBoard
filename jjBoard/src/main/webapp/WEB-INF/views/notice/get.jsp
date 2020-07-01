<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../include/header.jsp"%>

<!--board s -->
<section id="tabs" class="project-tab">
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="custom-board-title">
					<h3 class="custom-font-bold">공지사항</h3>
				</div>
				<ul class="custom-notice">
					<c:choose>
					 <c:when test="${notice.noticeDepth >= 1}">
						<li class="listTitle" style="width: 630px; white-space:pre-wrap;">┗&ensp;<c:out value="${notice.noticeTitle}" escapeXml="true"/></li>
					 </c:when>
					 <c:otherwise>
					 	<li class="listTitle" style="width: 630px; white-space:pre-wrap;" ><c:out value='${notice.noticeTitle}' escapeXml="true"/></li>
					 </c:otherwise>
					</c:choose>						
						<li style="text-align: center">등록일 <br> <fmt:formatDate pattern="yyyy.MM.dd" value="${notice.noticeDate}" /></li>
						<li style="text-align: center; width: 100px;">조회수 <br> <c:out value='${notice.noticeView}' /></li>
				</ul>
				<ul class="custom-writer">
					<li class="custom-writer">■ &nbsp; 작성자 : <c:out value='${notice.writer}' escapeXml="true"/></li>
				</ul>
				<div class="view_area">					
						<span class="custom-font-only-bold" id="noticeContent" style="white-space:pre-line;"><c:out value='${notice.noticeContent}' escapeXml="true"/></span>														
				</div>
				<br>
				<!-- upload s -->
				<c:if test="${notice.attachChk == 1}">
				<div class="row"  style="padding-left: 10px;">
					<div class="col-lg-12">
						<div class="panel panel-default">
							<div class="panel-heading">첨부파일 (클릭하여 다운로드 가능)</div>
							<hr>
							<div class="custom-panel-body">
								<div class="uploadResult">
									<ul style=" display: flex;">

									</ul>
								</div>
							</div>
						</div>
						
					</div>
				</div>
				</c:if>
				<hr>
				<!-- upload e -->
				<br>
				<c:if test="${notice.noticeDeleteChk eq 0}">
				<div id="noticeReply">
					<i class="fa fa-comments fa-2x"></i>&nbsp;댓글<br>
						<div style="background : lightgrey; padding: 10px">							
							<label>내용</label><br>
							<textarea id="noticeInput" name="replyContent" placeholder="내용을 입력해주세요" maxlength="300"></textarea><br>
							<label id="counting" style="font-size: 14px;">0</label> <label>/ 300</label><br><br>
							
							<label style="margin-right: 460px;">작성자</label>  <label>비밀번호</label><br>
								<div style="display: flex; height: 27px; ">
									<input id="replyer" name="replyer" maxlength="12" style=" margin-right: 290px;"><br><br>						
			                   		<input id="replyPw" type="password" name="replyPw"><br><br>
		                   		</div>
	                    		<div class="custom-red-font custom-text-right errorMsg" id="memberPwErrorMsg"></div><br>
		               		 <div>
								<button id="replyReg" class="btn btn-secondary" data-oper="replyReg">등록</button>
							</div>
						</div>
				</div>
				</c:if>
				<br>
				<!-- 댓글 s -->

				<div class="row">
					<div class="col-lg-12">
						<div class="panel panel-default">
							<div class="panel-heading">
								<i class="fa fa-commenting fa-fw"></i>Reply
							</div>	
								<!-- reply panel body start-->				
									<div class="panel-body">
										<ul class="commentList">
											<li class="left clearfix">
												<div>
													<div class="header">
														<strong class="primary-font"></strong>
														<small class="pull-right text-muted"></small>
													</div>
														<p></p>
												</div>												
											</li>						
										</ul>									
									</div>
							<!-- 댓글 목록 페이징 -->
							<div class="panel-footer">
								
							</div>
						</div>
					</div>						
			</div>

			<!-- 댓글 e -->
				<br>
				<hr style="border : 2px dashed lightgrey;">				
				<div class="">	
					<form>		
						<button type="button" data-oper="listShow" class="btn btn-primary float-left custom-button-gift">LIST</button>		
					</form>
				<c:if test="${notice.noticeDeleteChk eq 0}">
				<div class="float-right">						
					<form action="/notice/modify" id="modifyForm" method="get" style="float: left">
						<input type="hidden" id="noticeNo" name="noticeNo" value="${notice.noticeNo}"> 
						<input type="hidden" id="originNo" name="originNo" value="${notice.originNo}"> 
						<input type="hidden" name="pageNum" value="${cri.pageNum}"> 
						<input type="hidden" name="amount" value="${cri.amount}"> 
						<input type="hidden" name="type" value="${cri.type}"> 
						<input type="hidden" name="keyword" value="${cri.keyword}">
						<input type="hidden" id="noticePw" name="password"  value="${notice.noticePw}">
						<button data-oper="modify" id="modify" class="btn btn-primary custom-button-gift">수정</button>
					</form>					
					<form action="/notice/remove" id="removeForm" method="post" style="float: left" role="form" >
						<input type="hidden" name="noticeNo" value="${notice.noticeNo}">
						<input type="hidden" name="groupOrd" value="${notice.groupOrd}">
						<input type="hidden" name="noticeReplyCnt" value="${notice.replyCnt}">
						<button type="submit" data-noticeNo="${notice.noticeNo}" data-oper="remove" data-total-re="${totalRe}" class="btn btn-danger custom-button-gift">삭제</button>
					</form>
					<button type="button" data-oper="regRe" class="btn btn-primary custom-button-gift" style="float: left">답글달기</button>
				</div>
				</c:if>
				</div>		
			</div>
		</div>
	</div>
</section>
<!--board e -->

<!-- 게시글 비밀번호 모달 -->
<div id="modal" class="searchModal">
	<div class="search-modal-content" style="width: 500px">
		<div class="page-header">
			<div>비밀번호를 입력해주세요</div>
			<hr>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<div class="row">
					<div class="col-sm-12">						
						<div class="mt-10 custom-input">
							<div>비밀번호</div>
							<input type="password" name="noticePw2" id="noticePw2" value="" class="single-input custom-text-right" 
								   style="background: lightgrey; height: 30px;">
							<div class="custom-red-font custom-text-right" id="memberPwErrorMsg"></div>
						</div>
						
						<div class="mt-10 custom-input text-center">
							<button type="submit" class="btn btn-primary btn-sm" id="noticePwBtn">입력</button>
							<button type="button" class="btn btn-primary btn-sm" id="closeBtn3">닫기</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<hr>
	</div>
</div>

<!-- 댓글 비밀번호 모달 -->
<div id="modal2" class="searchModal">
	<div class="search-modal-content" style="width: 500px">
		<div class="page-header">
			<div>비밀번호를 입력해주세요</div>
			<hr>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<div class="row">
					<div class="col-sm-12">						
						<div class="mt-10 custom-input">
							<div>비밀번호</div>
							<input type="password" name="replyPw2" id="replyPw2" value="" class="single-input custom-text-right" 
								   style="background: lightgrey; height: 30px;">
							<input type="text" style="width 0px; visibility: hidden;">	   
							<div class="custom-red-font custom-text-right" id="memberPwErrorMsg"></div>
						</div>
						<div class="mt-10 custom-input text-center">
							<button type="button" class="btn btn-primary btn-sm" id="replyPwBtn" data-reply-no="">입력</button>
							<button type="button" class="btn btn-primary btn-sm" id="replyClose">닫기</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<hr>
	</div>
</div>

<script type="text/javascript" src="/resources/js/noticeReply.js"></script>
<script>
	
(function() {	
	$.getJSON("/notice/getAttachList", { noticeNo : ${notice.noticeNo}}, 
	function(data) {			
		var li = "";
		$(data).each(function(index, obj){	
			//이미지가 아니면 attach.png 표시
			if(obj.fileType == false) {
				var filePath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
				var fileLink = filePath.replace(new RegExp(/\\/g),"/");		// \를 /로 바꾸라는 정규표현식		
				li += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"' data-type='" + obj.fileType+ "'><div style='margin-right:20px;'><span>" + obj.fileName + "</span>" + 					   
					  "<a href='/download?fileName="+filePath+"'><br>"+"<img src='/resources/img/attach2.png'></a></div></li>";
			} else {
				//이미지이면 그대로 표시				
				var filePath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);	
				var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
				originPath = originPath.replace(new RegExp(/\\/g),"/");		// \를 /로 바꾸라는 정규표현식
				li += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"' data-type='" + obj.fileType+ "'><div><span>" + obj.fileName + "</span>" + 
					  "<a href='/download?fileName="+originPath+"'><br>"+"<img src='/display?fileName="+filePath+"'></a></div></li>";
			}	
		});	
				$('.uploadResult ul').html(li);		
			}).fail(function(xhr, status, err) {
				 if(error) {
					error(err);
				} 
	});//END JSON	
})();  
	
	 //파일의 확장자와 크기를 설정하고 이를 검사하는 함수
	 var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	 var maxSize = 5242880; //5MB
	
	 function checkExtension(fileName, fileSize) {
		if(fileSize >= maxSize) {	//파일 크기가 maxSize를 초과하는 경우
			alert("업로드 파일 사이즈가 초과되었습니다.");
			return false;				
		}
		if(regex.test(fileName)) {	//파일 확장자가 exe, sh, zip, alz인 경우
			alert("업로드 할 수 없는 파일입니다.");
			return false;
		}			
		return true;
	 }//END checkExetension()

		function showUpLoadedFile(result) {
			var li = "";
			$(result).each(function(index, obj){						
				//$('.uploadResult ul').append('<li>' + obj.fileName + '</li>');
				
				//이미지가 아니면 attach.png 표시
				if(!obj.image) {
					var filePath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
					//li += "<li><img src='/resources/img/attach.png'>" + obj.fileName + "</li>";
					li += "<li><div><a href='/download?fileName="+filePath+"'>"+"<img src='/resources/img/attach.png'>" + obj.fileName + "</a>"
						   + "<span data-file=\'" + filePath + "\' data-type='image'>x</span>"+"</div></li>";
				} else {
					//이미지이면 그대로 표시
					//li += ('<li>' + obj.fileName + '</li>');
					var filePath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
					var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
					originPath = originPath.replace(new RegExp(/\\/g),"/");		// \를 /로 바꾸라는 정규표현식
					//li += "<li><img src='/display?fileName=" + filePath + "'></li>";
					li += "<li><a href='/download?fileName="+originPath+"'>"+"<img src='/display?fileName=" + filePath + "'></a>"
						  + "<span data-file=\'" + filePath + "\' data-type='image'>x</span>"+"</li>";
				}	
			});	
			$('.uploadResult ul').append(li);
		}
	 
var uploadDivClone = $('.uploadDiv').clone();

$("#uploadBtn").on("click",function(e){
	 var formData = new FormData();	//jQuery를 이용하는 경우 파일 업로드는 FormData라는 객체를 이용. 쉽게 말하면 가상의 <form>태그
	 var inputFile = $("input[name='uploadFile']");
	 var files = inputFile[0].files;
	
	 console.log(files);		
	
	 //add filedata to formdata
	 for (f of files) {
	 	alert('filename : ' + f.name + '\nsize : ' + f.size);
	 	if(!checkExtension(f.name, f.size)) {					
			return;
		} 
			formData.append('uploadFile',f);			
	 }
		
	$.ajax({
		type : 'POST',
		url : '/uploadAjaxAction',
		data : formData,
		processData : false,
		contentType : false,
		dataType : 'json',	//반환된 정보를 처리하도록 추가
		success : function(result) {
			alert("upload ok");
			console.log(result);
			$('.uploadDiv').html(uploadDivClone.html());
			showUpLoadedFile(result);
		},error : function(error) {
			alert("upload not ok");
		}		
	});//END ajax
	});//END click
	
 	$(function() { 		
		var formObj = $("form");
		var realPassword = $('#noticePw').val();
		
		/* 버튼이 클릭되었을 때 data속성으로 해당 버튼 찾기 */
		$('button').on("click", function(e) {
			e.preventDefault();
			var operation = $(this).data("oper");	
			var noticePwBtn = $('#noticePwBtn');			
			
			var replyCnt;			
			
			if (operation === 'remove') {		 /* 삭제 버튼 */
 		 		// ajax로 해당 글의 댓글 갯수 가져오기
 		 		$.ajax({
		 			type : 'get',
		 			url : "/notice/getReplyCnt/" + noticeNo,
		 			contentType : "application/json; charset=utf-8",
		 			data : JSON.stringify(noticeNo),
		 			async : false,
		 			success : function(result, status, xhr){
		 				replyCnt = result;
		 			}
		 		});
				
				var totalRe = $(this).data("totalRe");	//해당 글에 달린 답글 갯수
				console.log(totalRe); 
				console.log(replyCnt); 
	
				
				/* 비밀번호체크 모달 띄우기 */
				$('#modal').show();		
				$('#noticePw2').focus();
					noticePwBtn.on("click", function(e) {		
						var userInputPassword = $('input[name=noticePw2]').val();				
						var groupOrd = $('input[name=groupOrd]').val();				
						//var noticeReplyCnt = $('input[name=noticeReplyCnt]').val();
						if (realPassword === userInputPassword) {						
				  if(confirm("정말로 삭제하시겠습니까?") == true) { 
					  if(replyCnt > 0 || totalRe != 0) {
						  // 실제로는 update
						  formObj.attr("action", "/notice/removeTwo").attr("method","post");
						  formObj.submit();
					  } else {
						  // 실제로도 delete
						  formObj.attr("action", "/notice/remove").attr("method","post");
						  formObj.submit();
					  }
		    	   } else {
		    		  return;
		    	   }//END confirm();
				} else {
					alert('비밀번호가 일치하지 않습니다');
					return;
				}		
					});
			} else if (operation == 'listShow') { /* LIST버튼 */
				goToList();
			} else if (operation === 'regRe') {   /* 답글 버튼 */
				goToRe();	
			} else if (operation === 'modify') {  /* 수정 버튼 */
				/* 비밀번호체크 모달 띄우기 */
				$('#modal').show();
				$('#noticePw2').focus();
					noticePwBtn.on("click", function(e) {
						var userInputPassword = $('input[name=noticePw2]').val();			
						removeOrModi(realPassword, userInputPassword, operation);
					});
			} else {
				
			}	
		});
		
		/* 수정이나 삭제할때 실행되는 함수 */
		function removeOrModi(realPassword, userInputPassword, operation){
			if(operation === 'modify'){	/* 수정 데이터 속성일 때 */
				if (realPassword === userInputPassword) {
					$('#noticePw2').focus();
					formObj.attr("action", "/notice/modify").attr("method","get");
					formObj.submit();
				} else {
					alert('비밀번호가 일치하지 않습니다');
					return;
				}
			}
		}
		
		/* 비밀번호 입력 모달 취소 버튼 클릭시 이벤트 */
		$('#closeBtn3').on("click", function(e) {
			e.preventDefault();
			$('#modal').hide();
			$('#noticePw2').val('');
		});
		
		/* LIST버튼 클릭시 함수 */
		function goToList(){
			formObj.attr("action", "/notice/list").attr("method", "get");
			formObj.append($("input[name='pageNum']").clone());
			formObj.append($("input[name='amount']").clone());
			formObj.append($("input[name='type']").clone());
			formObj.append($("input[name='keyword']").clone());	
			formObj.submit();
		}
		
		/* 답글 버튼 클릭시 함수 */
		function goToRe(){
	 		formObj.attr("action", "/notice/registerRe").attr("method", "get");
			formObj.append($("input[name='pageNum']").clone());
			formObj.append($("input[name='amount']").clone());
			formObj.append($("input[name='type']").clone());
			formObj.append($("input[name='keyword']").clone());	
			formObj.append($("input[name='originNo']").clone());	
			formObj.submit();
	 	}
	}); 
 	
 	////////////////////////////////////////////[댓글시작]//////////////////////////////////////////////////////
 	
 	/* 댓글 글쓴이 글자수 counting하고 제한 글자수만큼 자르기 */
	$('#replyer').keyup(function(){
		var replyerLength = $(this).val().length;
		console.log(replyerLength);
		
		if (replyerLength == 12) {          
            alert("최대 입력은 12자까지 가능합니다.");
            $(this).val($(this).val().substring(0, 12));
            return false;
        }
	});
 	
	/* 본문 글자수 counting하고 제한 글자수만큼 자르기 */
	$('textarea').keyup(function(){
		var contentLength = $(this).val().length;
		var remain = 300 - contentLength;
		console.log(remain);
		
		$('#counting').html(contentLength);
		
		if (contentLength == 300 || contentLength > 300) {          
            alert("최대 입력은 300자까지 가능합니다.");
            var trim = $.trim($(this).val().substring(0, 300));
            (this).val(trim);
            $('#counting').html(300);
        }
	});
 	
 	var pageNum = 1;
	var replyPageFooter = $(".panel-footer");
	
	/* 댓글 페이징 */
	function showReplyPage(replyCnt) {
		var endNum = Math.ceil(pageNum / 10.0)*10;
		var startNum = endNum - 9;		
		var prev = startNum != 1;
		var next = false;
		
			if(endNum * 10 >= replyCnt) {
				endNum = Math.ceil(replyCnt/10.0);
			}
			
			if(endNum * 10 < replyCnt) {
				next = true;
			}
			
			var str = "<ul class='pagination justify-content-center'>";		
			
			if(prev) {
				str += "<li class='page-item'><a class='pagelink' href='"+(startNum-1)+"'>previous</a></li>";
			}
			
			for (var i = startNum ; i<=endNum ; i++) {
				var active = pageNum == i? "active" : "";
				str += "<li class='page-item " + active+"'><a class='page-link' href='"+i+"'>"+i+"</a></li>";
			}
			
			if(next) {
				str += "<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>Next</a></li>";
			}		
			
		str +="</ul></div>"
		replyPageFooter.html(str);
	}
	
	/* 댓글 다른 페이지로 이동할 때 페이지 번호 링크 */
	replyPageFooter.on("click", "li a", function(e){
		e.preventDefault();
		var targetPageNum = $(this).attr("href");
		pageNum = targetPageNum;
		showList(pageNum);
	});
	
	var noticeNo ='<c:out value="${notice.noticeNo}"/>';	
 	var replyUL = $('.commentList');
 	
 	//댓글 목록 출력 함수 호출 - page 번호는 1로 저장
	showList(1);

	//댓글 목록 <li> 구성                                        
	function showList(page) {
		replyService.getList({noticeNo:noticeNo, page:page||1}, function(replyCnt, list){	//page 번호가 없을 경우 1로 설정 			
			if(page == -1) {		//page번호가 -1인 경우 : 마지막 페이지 표시
				pageNum = Math.ceil(replyCnt/10.0);
				showList(pageNum);
				return;
			}
		
			var li = '';
			if(list == null || list.length == 0) {	//댓글 목록이 없으면
				li += "<h3 style='text-align : center; font-size : 20px; padding-top : 50px;'>댓글이 없습니다</h3>";
				replyUL.html(li);	//replyUL에 li의 내용 가져오기
			}			
				for(var i = 0, len = list.length || 0; i < len; i++) {
					li += "<li class='left clearfix' data-replyNo='"+list[i].replyNo+"'>";	//댓글 목록을 replyUL에 <li>로 추가
					li += "<div><hr><div class='header'><strong class='primary-font'>"+ escapeHtml(list[i].replyer) +"</strong>";
					li += "<small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) +"</small></div>"
					li += "<div style='width : 750px; height : 200px; white-space:pre-wrap;' id='updateSpace"+list[i].replyNo+"'><pre><p>"+ escapeHtml(list[i].replyContent) + "</p></pre></div>";
					li += "<br><div class='float-right'><button class='btn btn-primary btn-sm replyModify' data-update-replyno='"+list[i].replyNo+"' data-content='"+ list[i].replyContent +"'>수정</button>"
					li += "<button class='btn btn-danger btn-sm replyRemove' data-remove-replyno='" +list[i].replyNo+"'>삭제</button></div></div></li>"
				}
			replyUL.html(li);
			showReplyPage(replyCnt);
		});
	}
	
	//유효성 검사
	var entityMap = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;', '/': '&#x2F;', '`': '&#x60;', '=': '&#x3D;' }; 
	function escapeHtml (string) { 
		return String(string).replace(/[&<>"'`=\/]/g, function (s) { 
			return entityMap[s]; 
			}); 
		}
	
	
	var noticeReply = $('#noticeReply');
	var replyer = noticeReply.find("input[name='replyer']");
	var replyContent = noticeReply.find("textarea[name='replyContent']");
	var replyPw = noticeReply.find("input[name='replyPw']");
	
	var replyReg = $("#replyReg");
	var replyRemove = $(".replyRemove");
	
	$(function(e){			
		$("#replyReg").click(function(){	
			var replyer = $.trim(noticeReply.find("input[name='replyer']").val());
			var replyContent= $.trim(noticeReply.find("textarea[name='replyContent']").val());
			var replyPw = $.trim(noticeReply.find("input[name='replyPw']").val());
			
			if (!replyer){
				alert("작성자를 입력해주세요");
				return false;
			} else if(!replyContent){
				alert("내용을 입력해주세요");
				return false;
			} else if(!replyPw){
				alert("비밀번호를 입력해주세요");
				return false;
			} 
		
			
			
		});
	});
	
	/* 비밀번호 유효성 검사 */
	var regex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,15}$/;

	$('#replyPw').keyup(function(e) {
		v = $(this).val();
		vLeng = $(this).val().length;

		if (regex.test(v)) {
			$('#memberPwErrorMsg').html('사용 가능합니다!');
			$(this).focus();
		} else {
			$('#memberPwErrorMsg').html('8~15자리의 영어/숫자/특수문자의 조합으로 입력해주세요');
		}
		
		if(vLeng > 15) {
			alert("15자 이하로 입력해주세요");
		}	
	});	
	
	//댓글 등록
	$(document).on("click","#replyReg", function(e){
	 	
		var regex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,15}$/;			
		
		var noticePw = $('#replyPw').val();
		console.log(noticePw);
		
		if (regex.test(noticePw)) {
			
			var reply = {
					replyer : replyer.val(),
					replyContent : replyContent.val(),
					replyPw : replyPw.val(),
					noticeNo : noticeNo
			};
			
			replyService.add(reply, function(result) {
				noticeReply.find("input").val('');
				noticeReply.find("textarea").val('');
				noticeReply.find("div[id='memberPwErrorMsg']").html('');
				showList(pageNum);
				
			})
		}else{
			alert('비밀번호를 형식에 맞게 입력해주세요');
			return false;
		}
		
		if(noticePw2 > 15) {
			alert("15자 이하로 입력해주세요");
		}
		

	});	
	
	//댓글 수정
	/* 수정하고자 하는 댓글의 수정 버튼을 누를경우 이벤트 */
 	$(document).on("click",".replyModify", function(e){
 		var content = $(this).data("content");
 		var replyNo = $(this).data("updateReplyno");
 		console.log(replyNo);
 		
 		$('#replyPwBtn').data("replyNo", replyNo);
 		var realPasswordChoi;
 		
 		// ajax로 해당 댓글 번호의 비밀번호 가져오기
 		$.ajax({
 			type : 'get',
 			url : "/replies/getPassword/" + replyNo,
 			contentType : "application/json; charset=utf-8",
 			data : JSON.stringify(replyNo),
 			success : function(result, status, xhr){
 				realPasswordChoi = result;
 			}
 		});
 		
 		$('#modal2').find("input[name='replyPw2']").val('');
 		
 		$('#modal2').show();			
 		
		//비밀번호 체크 후 확인 버튼 클릭
 		$('#replyPwBtn').on("click", function(e) {
 			
 			var replyNo = $(this).data("replyNo");
 			
 			console.log(replyNo);
 			
			var userInputPassword2 = $('input[name=replyPw2]').val();		 		
			if (realPasswordChoi == userInputPassword2) {
				
	 			$('#updateSpace'+replyNo).html('<textarea type="text" id="replyTextArea'+replyNo+'" style="resize : none; width : 720px; height : 200px; maxlength : 300">' + content +'</textarea><br><button class="btn btn-primary btn-sm modiEnd" data-reply-choi="'+replyNo+'">수정완료</button><br><br>'); 		
	 			$('#modal2').hide();
	 			
	 			$(this).data("replyNo", "");
			} else {
				alert('비밀번호가 일치하지 않습니다');
				return false;
			}
		});
 		
		//내용 수정 후 수정완료 버튼 클릭하면 내용이 감
 		$(document).on("click", ".modiEnd", function(e){
 			
 			var reply = {
					replyContent : $('#replyTextArea'+replyNo).val(),
					replyNo : replyNo
 			}
 			
 			replyService.update(reply, function(result){
 				showList(pageNum);
 			});
 		});	
	}); 
	
	/* 댓글의 비밀번호 모달에서 닫기버튼 클릭시 이벤트 */
	$('#replyClose').on("click", function(e) {
		e.preventDefault();
		$('#modal2').hide();
		$('#replyPw2').val('');
	});
	
	//댓글 삭제
 	$(document).on("click",".replyRemove", function(e){
 		
		var replyNo = $(this).data("removeReplyno");
 		console.log(replyNo);
 		
 		var realPasswordChoi;
 		
 		// ajax로 해당 댓글 번호의 비밀번호 가져오기
 		$.ajax({
 			type : 'get',
 			url : "/replies/getPassword/" + replyNo,
 			contentType : "application/json; charset=utf-8",
 			data : JSON.stringify(replyNo),
 			success : function(result, status, xhr){
 				realPasswordChoi = result;
 			}
 		});
 		
 		$('#modal2').find("input[name='replyPw2']").val('');		
 		$('#modal2').show();			
 		
		//비밀번호 체크 후 확인 버튼 클릭
 		 $('#replyPwBtn').on("click", function(e) { 
			var userInputPassword2 = $('input[name=replyPw2]').val();	
			if (realPasswordChoi == userInputPassword2) {	
				if(confirm("정말로 삭제하시겠습니까?") == true) {
					$('#modal2').hide();
					replyService.remove(replyNo, function(result) {
						alert(result);
						showList(pageNum);
					}, function(err) {
						console.log('reply error...');
					});
				} else {
					
					alert('비밀번호가 일치하지 않습니다');
					return false;
				}
			}
	 	}); 
		
	});  
	
</script>

<%@include file="../include/footer.jsp"%>