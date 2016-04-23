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
			drag: function (event, ui) {
				ui.position.left = Math.max(0, ui.position.left);
				ui.position.left = Math.min(ui.position.left, $scope.image.width);
				ui.position.top = Math.max(0, ui.position.top);
				ui.position.top = Math.min(ui.position.top, $scope.image.height);
			},
			stop: function (event, ui) {
				$scope.storePosition(ui.position.left, ui.position.top);
			}
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
