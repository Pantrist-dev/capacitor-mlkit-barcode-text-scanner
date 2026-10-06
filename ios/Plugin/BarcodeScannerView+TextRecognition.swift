import Foundation
import AVFoundation
import Capacitor
import MLKitTextRecognition
import MLKitVision

extension BarcodeScannerView {
    public func setTextRecognitionEnabled(_ enabled: Bool) {
        textRecognitionLock.lock()
        isTextRecognitionEnabled = enabled
        lastTextRecognitionTime = 0
        textRecognitionLock.unlock()
    }

    /// Runs text recognition on the frame if it is enabled and the configured interval since the last pass has elapsed.
    /// Called on the video output queue, which is serial, so passes never overlap.
    func recognizeTextIfDue(in visionImage: VisionImage, imageSize: CGSize) {
        let now = CFAbsoluteTimeGetCurrent()
        textRecognitionLock.lock()
        let isDue = isTextRecognitionEnabled
            && (lastTextRecognitionTime == 0 || now - lastTextRecognitionTime >= settings.textRecognitionInterval)
        if isDue {
            lastTextRecognitionTime = now
        }
        textRecognitionLock.unlock()
        if !isDue {
            return
        }
        if textRecognizerInstance == nil {
            textRecognizerInstance = MLKitTextRecognizer.textRecognizer(options: TextRecognizerOptions())
        }
        guard let textRecognizerInstance = textRecognizerInstance else {
            return
        }
        let text: MLKitText
        do {
            text = try textRecognizerInstance.results(in: visionImage)
        } catch let error {
            // Not reported as a scan error: barcode scanning keeps working without text recognition.
            CAPLog.print("Text recognition failed.", error.localizedDescription)
            return
        }
        textRecognitionLock.lock()
        let isStillEnabled = isTextRecognitionEnabled
        textRecognitionLock.unlock()
        if text.blocks.isEmpty || !isStillEnabled {
            return
        }
        self.delegate?.onTextDetected(text: text, imageSize: imageSize, videoOrientation: videoOrientation)
    }
}
