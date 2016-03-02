<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<link href="<%=request.getContextPath()%>/static/rs/bootstrap.css" rel="stylesheet"/>
<link href="<%=request.getContextPath()%>/static/rs/summernote.css" rel="stylesheet"/>
<link href="<%=request.getContextPath()%>/static/rs/customization.css" rel="stylesheet"/>
<script type="text/javascript" src="<%=request.getContextPath()%>/static/rs/jquery.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/static/rs/bootstrap.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/static/rs/resize.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/static/rs/treeview.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/static/rs/summernote.min.js"></script>
<script src="<%=request.getContextPath()%>/static/rs/jQuery-File-Upload-8.8.5/js/vendor/jquery.ui.widget.js"></script>
<script src="<%=request.getContextPath()%>/static/rs/jQuery-File-Upload-8.8.5/js/jquery.iframe-transport.js"></script>
<script src="<%=request.getContextPath()%>/static/rs/jQuery-File-Upload-8.8.5/js/jquery.fileupload.js"></script>
<title>XML EDITOR</title>
</head>
<body>
<div id="file">
    <div class="choose-btn c"><span class="glyphicon glyphicon-open-file"></span>&nbsp;Choose XML File</div>
    <div class="choose-btn s"><span class="glyphicon glyphicon-save-file"></span>&nbsp;Save XML File</div>
    <input id="fileupload" class="choose-file" type="file" name="file">
    <div class="cb"></div>
</div>

<div class="top-bar">
    <div id="text"></div>
</div>
<ul id="json"></ul>
<script type="text/javascript">
    var data;
    var container = $ ('#json');
    $ (document).ready (function () {
        $ ('#text').summernote ({
            height: 540,
            minHeight: null,
            maxHeight: null
        });
        $('#file .choose-btn.c').on ('click', function () {
            console.log('startTime:'+new Date().getTime());
            $('#fileupload').trigger ('click');
        });
        $('#file .choose-btn.s').on ('click', function () {
            console.log('上传JSON:'+JSON.stringify(data));
            var json = encodeURI(JSON.stringify(data));
            $.post('<%=request.getContextPath()%>/convert/doConvert',{json:json},function(data){
                console.log(data);
                $('#file').append('<a href="<%=request.getContextPath()%>'+data+'">DownLoad</a>');
            });
        });
    });

    function parseJSON (json, xml, id) {
        for (var i in json) {
            var d = json[i];
            if (typeof (d) === "object" || typeof (d) === "array") {
                if(typeof(d) === 'array'){
                    var cId = id!=""?id+ '>' + i:i;
                }
                else{
                    var cId = id!=""?id+ '&' + i:i;
                }
                var p, nb, c, ne;
                p  = document.createElement ("li");
                nb = document.createElement ("div");
                ne = document.createElement ("div");
                c  = document.createElement ("ul");
                nb.setAttribute ("class", "node-name");
                ne.setAttribute ("class", "node-name");
                nb.innerHTML = ne.innerHTML = i;
                p.setAttribute('class','node');
                $(p).append('<span class="before"><span class="plus">+</span><span class="minus">-</span></span>');
                p.setAttribute('id',cId);
                p.appendChild (nb);
                p.appendChild (c);
                p.appendChild (ne);
                xml.append (p);
                parseJSON (d, $(c),cId);
            }
            else {
                var cId = id!=""?id+ '&' + i:i;
                xml.append ("<li class='leaf' id='"+cId+"'><span class='node-name'>" + i + "</span>&nbsp;&nbsp;<span class='node-value' contenteditable='true'>" + json[i] + "</span></li>");
            }
        }

    }
    $('#fileupload').fileupload({
        url:'<%=request.getContextPath()%>/file/upload',
        dataType: 'json',
        done: function (e, d) {
            //上传成功后，解析后的JSON数据
            //console.log(d.result);
            //$('#text-entity').summernote('code',JSON.stringify(d.result));
            console.log('endTime:'+new Date().getTime());
            var $json = $('#json').empty();
            data = d.result;
            parseJSON(data,$json,"");
            $("[contenteditable='true']").on('focus', function() {
                var $this = $(this);
                $this.data('before', $this.html());
                return $this;
            }).on('blur keyup paste', function() {
                var $this = $(this);
                if ($this.data('before') !== $this.html()) {
                    $this.data('before', $this.html());
                    $this.trigger('change');
                }
                return $this;
            }).on('change', function() {
                //console.log('change:' + $(this).parents('li').attr('id'));
                var id = $(this).parents('li').attr('id');
                var arr = id.split('&');
                var str = 'data';
                for(var i = 0,len=arr.length;i<len;i++){
                    str += '["'+arr[i]+'"]';
                }
                str += '="'+$(this).text()+'";';
                (new Function(str))();
                //console.log(JSON.stringify(data));
            });
            $(".node .before").click(function(){
                var $this = $(this).closest('li');
                $this.toggleClass('closed');
            });
        }
    }).prop('disabled', !$.support.fileInput)
      .parent().addClass($.support.fileInput ? undefined : 'disabled');
</script>
</body>
</html>