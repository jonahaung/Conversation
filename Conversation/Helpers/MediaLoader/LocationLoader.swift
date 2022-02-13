//
// Copyright (c) 2021 Related Code - https://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import MapKit

//-----------------------------------------------------------------------------------------------------------------------------------------------
class LocationLoader: NSObject {

    class func loadMedia(_ msg: Msg) {
        
        guard let data = msg.locationData else { return }

		var region: MKCoordinateRegion = MKCoordinateRegion()
        region.center = data.location.location2D
		region.span.latitudeDelta = CLLocationDegrees(0.005)
		region.span.longitudeDelta = CLLocationDegrees(0.005)

		let options = MKMapSnapshotter.Options()
		options.region = region
        options.size = data.imageSize
		options.scale = UIScreen.main.scale

		let snapshotter = MKMapSnapshotter(options: options)
		snapshotter.start(with: DispatchQueue.global(qos: .default), completionHandler: { [weak msg] snapshot, error in
            guard let msg = msg else  { return }
			if let snapshot = snapshot {
				DispatchQueue.main.async {
                    UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
                    do {
                        snapshot.image.draw(at: CGPoint.zero)
                        let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                        var point = snapshot.point(for: data.location.location2D)
                        point.x += pin.centerOffset.x - (pin.bounds.size.width / 2)
                        point.y += pin.centerOffset.y - (pin.bounds.size.height / 2)
                        pin.image?.draw(at: point)
                        let image = UIGraphicsGetImageFromCurrentImageContext()
                        msg.locationData?.image = image
                        msg.objectWillChange.send()
                    }
                    UIGraphicsEndImageContext()
				}
			}
		})
	}
}
