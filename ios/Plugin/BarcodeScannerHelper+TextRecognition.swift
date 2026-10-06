import Foundation
import Capacitor
import MLKitTextRecognition
import AVFoundation

extension BarcodeScannerHelper {
    public static func createTextResult(_ text: MLKitText, imageSize: CGSize, videoOrientation: AVCaptureVideoOrientation?) -> JSObject {
        var blocksResult = JSArray()
        for block in text.blocks {
            var linesResult = JSArray()
            for line in block.lines {
                var lineResult = JSObject()
                lineResult["text"] = line.text
                if let cornerPoints = createNormalizedCornerPointsResult(line.cornerPoints, imageSize: imageSize,
                                                                        videoOrientation: videoOrientation) {
                    lineResult["cornerPoints"] = cornerPoints
                }
                linesResult.append(lineResult)
            }
            var blockResult = JSObject()
            blockResult["text"] = block.text
            if let cornerPoints = createNormalizedCornerPointsResult(block.cornerPoints, imageSize: imageSize,
                                                                    videoOrientation: videoOrientation) {
                blockResult["cornerPoints"] = cornerPoints
            }
            blockResult["lines"] = linesResult
            blocksResult.append(blockResult)
        }
        var result = JSObject()
        result["text"] = text.text
        result["blocks"] = blocksResult
        return result
    }

    private static func createNormalizedCornerPointsResult(
        _ cornerPoints: [NSValue],
        imageSize: CGSize,
        videoOrientation: AVCaptureVideoOrientation?
    ) -> [[Int]]? {
        if cornerPoints.count != 4 {
            return nil
        }
        // Same coordinate space as the barcode corner points: screen size in pixels.
        let screenSize = CGSize(width: UIScreen.main.bounds.width * UIScreen.main.scale,
                                height: UIScreen.main.bounds.height * UIScreen.main.scale)
        let normalizedCornerPoints = normalizeCornerPoints(cornerPoints: cornerPoints, imageSize: imageSize,
                                                           screenSize: screenSize, videoOrientation: videoOrientation)
        return normalizedCornerPoints.map { [Int($0.cgPointValue.x), Int($0.cgPointValue.y)] }
    }
}
