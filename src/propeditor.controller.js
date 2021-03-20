angular.module("umbraco").controller("ImageHotspotController", function($scope, $element, mediaResource, editorState, contentResource, contentEditingHelper) {
	
	$scope.image = {
		src: "",
		width: ($scope.model.config.width || 400),
		height: 0
	}
	
	$scope.findImageReference = function(context, alias) {
		var found = false
		var maxRecurse = 200
		var aliasRE = new RegExp(`(?:^|_)${alias}\$`)
		var ref
		var imageReference
		
		while (context != null && !found && maxRecurse > 0) {
			ref = context.content || context.embeddedContentItem
			if (ref) {
				var props = ref.properties
				var tabs = ref.tabs
				var imageProperties
				
				if (props) {
					imageProperties = props.filter(function(prop) { return prop.alias.match(aliasRE) })
					if (imageProperties.length >= 1) {
						imageReference = imageProperties[0].value
						found = true
					}
				} else if (tabs) {
					props = contentEditingHelper.getAllProps(ref)
					if (props) {
						imageProperties = props.filter(function(prop) { return prop.alias.match(aliasRE) })
						if (imageProperties.length >= 1) {
							imageReference = imageProperties[0].value
							found = true
						}
					}
				}
			}
			context = context.$parent
			maxRecurse -= 1
		}
		
		if (found) {
			return imageReference
		} else {
			var currentPage = editorState.getCurrent()
			
			if (currentPage.parentId) {
				contentResource.getById(currentPage.parentId).then(function(doc){
					if (doc.variants) {
						doc.variants.forEach(function(variant) {
							props = contentEditingHelper.getAllProps(variant)
							if (props) {
								imageProperties = props.filter(function(prop) { return prop.alias.match(aliasRE) })
								if (imageProperties.length >= 1) {
									imageReference = imageProperties[0].value
									console.log(`Found ${imageReference}`)
									found = true
									$scope.updateImageSrc(imageReference)
								}
							}
						})
					}
				})
			}
		}
	}
	
	$scope.setImageSrc = function(context, propertyAlias) {
		var imageRef = $scope.findImageReference(context, propertyAlias)
		$scope.updateImageSrc(imageRef)
	}

	$scope.updateImageSrc = function(imageRef) {
		if (imageRef) {
			mediaResource.getById(imageRef).then(function(media) {
				$scope.image.src = media.mediaLink
				
				var editorWidth = $scope.image.width
				var propsHolder = media.properties || (media.tabs && media.tabs[0] ? media.tabs[0].properties : null)
				
				if (propsHolder) {
					var originalWidth = propsHolder.find(function (prop) { return prop.alias == 'umbracoWidth' })
					var originalHeight = propsHolder.find(function(prop) { return prop.alias == 'umbracoHeight' })
					if ((originalHeight && originalHeight.value > 0) && (originalWidth && originalWidth.value > 0)) {
						var ratio = originalHeight.value / originalWidth.value
						var editorHeight = Math.ceil(editorWidth * ratio)
						$scope.image.height = editorHeight
					}
				}
			})
		} else {
			console.log("Couldn't find the image property")
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
