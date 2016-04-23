angular.module("umbraco").controller("ImageHotspotController", function ($scope, $element) {
	$scope.theme = 4;
	$scope.image = {
		src: "http://placem.at/places",
		width: 400,
		height: 300
	};
	
	$scope.initDragging = function () {
		$('.imagehotspot-hotspot', $($element)).draggable({
			cursorAt: { left: 0, top: 0 },
			containment: "parent",
			start: function (event, ui) { console.log(ui); },
			drag: function (event, ui) { },
			stop: function (event, ui) { $scope.storePosition(ui.position.left, ui.position.top); }
		});
	}
	
	$scope.positionHotspot = function ($event) {
		var offsetX = $event.offsetX;
		var offsetY = $event.offsetY;
		var hotspot = document.querySelector(".imagehotspot-hotspot");
		hotspot.style.left = offsetX + "px";
		hotspot.style.top = offsetY + "px";
		
		$scope.storePosition(offsetX, offsetY);
	};
	
	$scope.storePosition = function (x, y) {
		$scope.model.value = {
			left: x,
			top: y
		};
	}
	
	$scope.initDragging();
});
