using System;
using System.Globalization;
using Newtonsoft.Json;
using Umbraco.Core.Logging;
using Umbraco.Core.Models.PublishedContent;
using Umbraco.Core.PropertyEditors;

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
	
	[PropertyValueType(typeof(ImageHotspot))]
	[PropertyValueCache(PropertyCacheValue.All, PropertyCacheLevel.Content)]
	public class ImageHotspotPropertyConverter : PropertyValueConverterBase {
		
		public override bool IsConverter(PublishedPropertyType propertyType) {
			return propertyType.PropertyEditorAlias.Equals("Vokseverk.ImageHotspot");
		}
	
		public override object ConvertSourceToObject(PublishedPropertyType propertyType, object source, bool preview) {
			if (source == null) return null;
			try {
				var obj = JsonConvert.DeserializeObject<ImageHotspot>(source.ToString());
				return obj;
			} catch (Exception e) {
				LogHelper.Info(typeof(ImageHotspotPropertyConverter), e.Message);
				return null;
			}
		}
	}
	
}
