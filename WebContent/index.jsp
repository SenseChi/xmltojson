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
    <div class="choose-btn"><span class="glyphicon glyphicon-open-file"></span>&nbsp;Choose XML File</div>
    <input id="fileupload" class="choose-file" type="file" name="file">
</div>
<div class="top-bar">
    <div id="text"></div>
</div>
<ul id="json"></ul>
<script type="text/javascript">
    $ (document).ready (function () {
        $ ('#text').summernote ({
            height: 540,
            minHeight: null,
            maxHeight: null
        });
        $ ('#file .choose-btn').on ('click', function () {
            $ ('#file .choose-file').trigger ('click');
        });
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
            console.log('change:' + $(this).parents('li').attr('id'));
            var id = $(this).parents('li').attr('id');
            var arr = id.split('&');
            var str = 'data';
            for(var i = 0,len=arr.length;i<len;i++){
                str += '["'+arr[i]+'"]';
            }
            str += '="'+$(this).text()+'";';
            (new Function(str))();
            console.log(JSON.stringify(data));
        });
    });

    var data = {
        "四川省":{
            "成都市": ["成华区", "青阳区", "朝阳区", "丰台区", "石景山区", "海淀区", "门头沟区", "房山区", "通州区", "顺义区", "昌平区", "大兴区", "怀柔区", "平谷区", "密云县", "延庆县"],
            "绵阳市": ["东城区", "西城区", "朝阳区", "丰台区", "石景山区", "海淀区", "门头沟区", "房山区", "通州区", "顺义区", "昌平区", "大兴区", "怀柔区", "平谷区", "密云县", "延庆县"]
        }
    };

    var container = $ ('#json');
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
                p.setAttribute('class','node open');
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
    parseJSON (data, container,'',false);
    $('#fileupload').fileupload({
        url:'<%=request.getContextPath()%>/file/upload',
        dataType: 'json',
        done: function (e, data) {
            //上传成功后，解析后的JSON数据
            console.log(data.result);
            $('#text-entity').summernote('code',JSON.stringify(data.result));
            parseJSON(data.result,$('#json'),"");
        }
    }).prop('disabled', !$.support.fileInput)
      .parent().addClass($.support.fileInput ? undefined : 'disabled');
</script>
</body>
</html>