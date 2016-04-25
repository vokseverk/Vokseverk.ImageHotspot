angular.module("umbraco").controller("ImageHotspotController", function ($scope, $element) {

	var	$image = $('.imagehotspot-image img', $($element));
	
	$scope.image = {
		width: 400,
		height: 0
	};
	
	$scope.initDragging = function () {
		$('.imagehotspot-hotspot', $($element)).draggable({
			cursorAt: { left: 0, top: 0 },
			drag: function (event, ui) {
				$scope.assertImageDimensions();
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
		var container = $event.target;
		
		var $hotspot = $(".imagehotspot-hotspot", container);
		$hotspot.css({
			left: offsetX + "px",
			top: offsetY + "px"
		});
		
		$scope.storePosition(offsetX, offsetY);
	};
	
	$scope.storePosition = function (x, y) {
		$scope.assertImageDimensions();
		
		var percentX = 100 * x / $scope.image.width;
		var percentY = 100 * y / $scope.image.height;
		
		$scope.model.value = {
			image: $scope.model.config.imageSrc, 
			left: x,
			top: y,
			percentX: percentX,
			percentY: percentY,
			width: $scope.image.width,
			height: $scope.image.height
		};
	}
	
	// This should not be called before the image has loaded
	$scope.assertImageDimensions = function () {
		if ($scope.image.height === 0) {
			$scope.image.height = $image.height();
		}
	}
	
	$scope.initDragging();
});
