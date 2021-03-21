using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Umbraco.Core;
using Umbraco.Core.Models;
using Umbraco.Core.PropertyEditors;
using Umbraco.Core.Models.PublishedContent;

namespace Vokseverk {
	
	public class ImageHotspot {
		public int Left { get; set; }
		public int Top { get; set; }
		public decimal PercentX { get; set; }
		public decimal PercentY { get; set; }
		public int Width { get; set; }
		public int Height { get; set; }
		public string Image { get; set; }
		
		public override string ToString() {
			return "left: " + PercentX + "%; top: " + PercentY + "%;";
		}
	}
	
	public class ImageHotspotPropertyConverter : IPropertyValueConverter {
		
		public bool IsConverter(IPublishedPropertyType propertyType) {
			return propertyType.EditorAlias.Equals("Vokseverk.ImageHotspot");
		}
		
		public Type GetPropertyValueType(IPublishedPropertyType propertyType) {
			return typeof(ImageHotspot);
		}
		
		public PropertyCacheLevel GetPropertyCacheLevel(IPublishedPropertyType propertyType) {
			return PropertyCacheLevel.Element;
		}
		
		public bool? IsValue(object value, PropertyValueLevel level) {
			switch (level) {
				case PropertyValueLevel.Source:
					return value != null && value is ImageHotspot;
				default:
					throw new NotSupportedException($"Invalid level: {level}.");
			}
		}
		
		public object ConvertSourceToIntermediate(IPublishedElement owner, IPublishedPropertyType propertyType, object source, bool preview) {
			if (source == null) return null;
			try {
				var obj = JsonConvert.DeserializeObject<ImageHotspot>(source.ToString());
				return obj;
			} catch (Exception e) {
				return null;
			}
		}
		
		public object ConvertIntermediateToObject(IPublishedElement owner, IPublishedPropertyType propertyType, PropertyCacheLevel referenceCacheLevel, object inter, bool preview) {
			return inter;
		}
		
		public object ConvertIntermediateToXPath(IPublishedElement owner, IPublishedPropertyType propertyType, PropertyCacheLevel referenceCacheLevel, object inter, bool preview) {
			if (inter == null) {
				return null;
			}
			
			return inter.ToString();
		}
	}
}
