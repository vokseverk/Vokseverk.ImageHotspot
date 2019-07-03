angular.module("umbraco").controller("ImageHotspotThemePrevalueController", function ($scope) {
	$scope.model.prevalues = [
		{ id: 1, label: "Red" },
		{ id: 2, label: "Green" },
		{ id: 3, label: "Blue" },
		{ id: 4, label: "Orange" }
	];
});
