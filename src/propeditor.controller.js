angular.module("umbraco").controller("ImageHotspotController", function($scope, $element, mediaResource) {
	$scope.image = {
		src: "",
		width: 400,
		height: 0
	}
	
	$scope.setImageSrc = function(context, propertyAlias) {
		var imageRef = ""
		var maxRecurse = 200
		var found = false
		var aliasRE = new RegExp(`${propertyAlias}\$`)
		var ref
		
		while (!found && maxRecurse > 0) {
			ref = context.content || context.embeddedContentItem
			if (ref != null) {
				var props = ref.properties || ref.tabs[0].properties
				if (props) {
					var imageProperties = props.filter(function(prop) { return prop.alias.match(aliasRE) })
					if (imageProperties.length >= 1) {
						imageRef = imageProperties[0].value
						found = true
					}
				}
			}
			context = context.$parent
			maxRecurse -= 1
		}
		
		if (imageRef != "") {
			mediaResource.getById(imageRef).then(function(media) {
				$scope.image.src = media.mediaLink
			})
		}
	}

	var	$image = $('.imagehotspot-image img', $($element))
	
	$scope.initDragging = function () {
		$('.imagehotspot-hotspot', $($element)).draggable({
			cursorAt: { left: 0, top: 0 },
			drag: function (event, ui) {
				ui.position.left = Math.max(0, ui.position.left)
				ui.position.left = Math.min(ui.position.left, $scope.image.width)
				ui.position.top = Math.max(0, ui.position.top)
				ui.position.top = Math.min(ui.position.top, $scope.image.height)
			},
			stop: function (event, ui) {
				$scope.storePosition(ui.position.left, ui.position.top)
			}
		})
	}
	
	$scope.positionHotspot = function ($event) {
		var offsetX = $event.offsetX
		var offsetY = $event.offsetY
		var container = $event.target
		
		var $hotspot = $(".imagehotspot-hotspot", container)
		$hotspot.css({
			left: offsetX + "px",
			top: offsetY + "px"
		})
		
		$scope.storePosition(offsetX, offsetY)
	}
	
	$scope.storePosition = function (x, y) {
		$scope.assertImageDimensions()
		
		var percentX = 100 * x / $scope.image.width
		var percentY = 100 * y / $scope.image.height
		
		$scope.model.value = {
			image: $scope.image.src,
			left: x,
			top: y,
			percentX: percentX,
			percentY: percentY,
			width: $scope.image.width,
			height: $scope.image.height
		}
	}
	
	// This should not be called before the image has loaded
	$scope.assertImageDimensions = function () {
		if (($scope.image.height === 0) && ($image.height() != null)) {
			$scope.image.height = $image.height()
		}
	}
	
	$scope.setImageSrc($scope, $scope.model.config.imageSrc)
	$scope.initDragging()
})
