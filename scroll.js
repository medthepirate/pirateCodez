var i = 0;
var speedInt = 300;
var scrollInt;

function scrollMe(speedInt){
	var scrollInt = window.setInterval(function(){scrollBy(0,1);}, speedInt);	
		
}

function stopit(){
	clearInterval(scrollInt);

}
