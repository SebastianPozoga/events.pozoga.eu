
$(document).ready(function(){
	$('.tutScript').each(function(){
		$(this).append('\n/*Click to run*/');
		$(this).click(function(){
			var code = $(this).val();
			eval(code);		
		});
	});
});
