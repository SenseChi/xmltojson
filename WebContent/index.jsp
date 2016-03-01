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
<title>XML EDITOR</title>
</head>
<body>
<div id="frame">
	<div id="tree">
		<div id="tree-entity"></div>
	</div>
	<div id="text">
		<div id="text-entity"></div>
	</div>
	<div class="cb"></div>
</div>
<script type="text/javascript">
	var json = '[{"text":"Parent 1", "nodes":[{"text":"Child 1", "nodes":[{"text":"Grandchild 1"}, {"text":"Grandchild 2"}]}, {"text":"Child 2"}]}, {"text":"Parent 2"}, {"text":"Parent 3"}, {"text":"Parent 4"}, {"text":"Parent 5"}]';
	$ (document).ready (function () {
		$ ('#tree-entity').treeview ({
			data: json
		});
		var text = $ ('#text-entity').summernote ({
			height: $ ('#tree').height () > 164 ? ($ ('#tree').height () - 41) : 164,
			minHeight: null,
			maxHeight: null
		});
		$ ('#tree').on ("resize", function () {
			$ ('#text .note-editable.panel-body').height (($ ('#tree').height () > 164 ? ($ ('#tree').height () - 41) : 164) - 20);
		});
	});
</script>
</body>
</html>