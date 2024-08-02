import AVFoundation
import AVKit
import UIKit

class VideoCallViewController: UIViewController {
    
    private var mainVideoView: UIView!
    private var pipVideoView: UIView!
    private var pipController: AVPictureInPictureController?
    
    private var localCaptureSession: AVCaptureSession?
    private var remoteCaptureSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCaptureSession()
        setupPictureInPicture()
    }
    
    private func setupUI() {
        mainVideoView = UIView(frame: view.bounds)
        mainVideoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mainVideoView)
        
        pipVideoView = UIView(frame: CGRect(x: view.bounds.width - 150, y: 20, width: 120, height: 160))
        pipVideoView.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        view.addSubview(pipVideoView)
    }
    
    private func setupCaptureSession() {
        // Setup local capture session (front camera)
        localCaptureSession = AVCaptureSession()
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: frontCamera),
              localCaptureSession!.canAddInput(input) else {
            print("Failed to set up local capture session")
            return
        }
        localCaptureSession!.addInput(input)
        
        let localPreviewLayer = AVCaptureVideoPreviewLayer(session: localCaptureSession!)
        localPreviewLayer.frame = pipVideoView.bounds
        localPreviewLayer.videoGravity = .resizeAspectFill
        pipVideoView.layer.addSublayer(localPreviewLayer)
        
        localCaptureSession!.startRunning()
        
        // Setup remote capture session (simulated for this example)
        remoteCaptureSession = AVCaptureSession()
        // In a real implementation, you would receive and display the remote video stream here
        // For this example, we'll just use a colored background to represent the remote video
        mainVideoView.backgroundColor = .gray
    }
    
    private func setupPictureInPicture() {
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            print("Picture in Picture is not supported")
            return
        }
        
        let pipContentSource = AVPictureInPictureController.ContentSource(
            activeVideoCallSourceView: mainVideoView,
            contentViewController: nil
        )
        
        pipController = AVPictureInPictureController(contentSource: pipContentSource)
        pipController?.delegate = self
        
        // Add PiP button to the UI
        let pipButton = UIButton(type: .system)
        pipButton.setTitle("PiP", for: .normal)
        pipButton.addTarget(self, action: #selector(togglePictureInPicture), for: .touchUpInside)
        pipButton.frame = CGRect(x: 20, y: 40, width: 60, height: 40)
        view.addSubview(pipButton)
    }
    
    @objc private func togglePictureInPicture() {
        if pipController?.isPictureInPictureActive == true {
            pipController?.stopPictureInPicture()
        } else {
            pipController?.startPictureInPicture()
        }
    }
}

extension VideoCallViewController: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP will start")
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP did start")
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP will stop")
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP did stop")
    }
}
