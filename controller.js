angular.module("umbraco").controller("ImageHotspotController", function ($scope) {
	$scope.theme = 4;
	$scope.image = {
		src: "http://placem.at/places",
		width: 400,
		height: 300
	};
	
	$scope.positionHotspot = function ($event) {
		var offsetX = $event.offsetX;
		var offsetY = $event.offsetY;
		var hotspot = document.querySelector(".imagehotspot-hotspot");
		hotspot.style.left = offsetX + "px";
		hotspot.style.top = offsetY + "px";
		
		$scope.model.value = {
			left: offsetX,
			top: offsetY
		};
	};
});
