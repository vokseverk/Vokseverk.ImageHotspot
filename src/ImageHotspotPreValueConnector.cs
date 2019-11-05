using System.Collections.Generic;
using Umbraco.Core;
using Umbraco.Core.Deploy;
using Umbraco.Core.Services;

namespace Vokseverk
{
    public class ImageHotspotPreValueConnector : IPreValueConnector
    {
        private readonly IMediaService _mediaService;

        // By the Power of Grayskull, I have dependency injection!
        public ImageHotspotPreValueConnector(IMediaService mediaService)
        {
            _mediaService = mediaService;
        }

        public IEnumerable<string> PropertyEditorAliases => new[] { "Vokseverk.ImageHotspot" };

        public IDictionary<string, string> ConvertToDeploy(IDictionary<string, string> preValues, ICollection<ArtifactDependency> dependencies)
        {
            // Get the value for the "imageSrc" prevalue/field.
            if (preValues.TryGetValue("imageSrc", out string imageSrc) && string.IsNullOrWhiteSpace(imageSrc) == false)
            {
                // Go find the media node from the image path.
                var media = _mediaService.GetMediaByPath(imageSrc);
                if (media != null)
                {
                    // Once found, get the UDI and add it as a dependency.
                    var udi = media.GetUdi();
                    dependencies.Add(new ArtifactDependency(udi, false, ArtifactDependencyMode.Exist));
                }
            }

            // We didn't do anything with the prevalues, let's return them as is.
            return preValues;
        }

        public IDictionary<string, string> ConvertToLocalEnvironment(IDictionary<string, string> preValues)
        {
            // Nothing to do here. Return the prevalues as is.
            return preValues;
        }
    }
}