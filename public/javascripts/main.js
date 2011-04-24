// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var j = jQuery.noConflict();

j(document).ready(function()
{
	// maximum length
	var maxLen = 140;
    var	newLen = 140;
	if(j("#micropost_content").length > 0)
	{
		j("#micropost_content").bind("change blur keyup", function()
		{
			newLen = j(this).val().length;
			j("#micropost_size").text((maxLen - newLen));
			
			if((maxLen - newLen) < 0)
			{
				j("#micropost_submit").attr("disabled","disabled");
			}
			else
			{
				j("#micropost_submit").removeAttr("disabled");
			}
			
			
		});
	}
});