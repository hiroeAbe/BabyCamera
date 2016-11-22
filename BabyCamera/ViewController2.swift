

import UIKit
import AVFoundation


class ViewController2: UIViewController ,AVAudioPlayerDelegate{
    
    var myAudioPlayer : AVAudioPlayer!
    var musicButton:UIButton!
    // セッション.
    var mySession : AVCaptureSession!
    // デバイス.
    var myDevice : AVCaptureDevice!
    // 画像のアウトプット.
    var myImageOutput: AVCaptureStillImageOutput!
   
    //let myButton3 = UIButton()
    var imageView : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //再生する音源のURLを生成.
        let soundFilePath : String = Bundle.main.path(forResource: "kira1", ofType: "mp3")!
        let fileURL = URL(fileURLWithPath: soundFilePath)
        
        //AVAudioPlayerのインスタンス化.
        myAudioPlayer = try! AVAudioPlayer(contentsOf: fileURL)
        
        //AVAudioPlayerのデリゲートをセット.
        myAudioPlayer.delegate = self
        
                // セッションの作成.
        mySession = AVCaptureSession()
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // バックカメラをmyDeviceに格納.
        for device in devices! {
            if((device as AnyObject).position == AVCaptureDevicePosition.front){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        // フロントカメラからVideoInputを取得.
        let videoInput = try! AVCaptureDeviceInput.init(device: myDevice)
        // セッションに追加.
        mySession.addInput(videoInput)
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer = AVCaptureVideoPreviewLayer.init(session: mySession)
        myVideoLayer?.frame = self.view.bounds
        myVideoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer!)
        
        // セッション開始.
        mySession.startRunning()
        
        // UIボタンを作成.
        let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        //myButton.backgroundColor = UIColor.red
        let sImage:UIImage = UIImage(named:"camera.png")!
        
        myButton.layer.masksToBounds = true
        //myButton.setTitle("撮影", for: .normal)
        myButton.setImage(sImage, for: .normal)
        //myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2+120, y:self.view.bounds.height-450)
        myButton.addTarget(self, action: #selector(onClickMyButton), for: .touchUpInside)
        
        let myButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width , height: view.frame.size.height))
        //myButton2.backgroundColor = UIColor.blue
        let hImage:UIImage = UIImage(named:"home2.png")!
        myButton2.layer.masksToBounds = true
        //myButton2.setTitle("戻る", for: .normal)
        myButton2.setImage(hImage, for: .normal)
        myButton2.layer.cornerRadius = 20.0
        myButton2.layer.position = CGPoint(x: self.view.bounds.width/2+100, y:self.view.bounds.height-50)
        myButton2.addTarget(self, action: #selector(onClickMyButton2), for: .touchUpInside)
        
        let myButton3 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width , height: view.frame.size.height))
        let aImage:UIImage = UIImage(named:"Anpanmann.png")!
        myButton3.layer.masksToBounds = true
        myButton3.setImage(aImage, for: .normal)
        myButton3.layer.cornerRadius = 20.0
        myButton3.layer.position = CGPoint(x: self.view.bounds.width/2-100, y:self.view.bounds.height/2+170)
       // myButton3.addTarget(self, action: #selector(onClickMyButton4), for: UIControlEvents.valueChanged)
        myButton3.addTarget(self, action: #selector(onClickMyButton3), for: .touchUpInside)

        // UIボタンをViewに追加.
        self.view.addSubview(myButton);
        self.view.addSubview(myButton2);
        self.view.addSubview(myButton3);
       
    
    }
    
    private var starImageView: FallingImageView {
        let image = UIImage(named: "yellow1")!
        let unitSize = image.size
        let xPoint =  CGFloat(arc4random() % UInt32(self.view.frame.size.width - unitSize.width))
        let rect = CGRect(x: xPoint, y: -unitSize.height, width: unitSize.width, height: unitSize.width)
        let imageView = FallingImageView(frame: rect)
        imageView.image = image
        return imageView
    }

    internal func onClickMyButton2(sender: UIButton){
        
        // 遷移するViewを定義する.
        let myViewController: UIViewController = ViewController()
        
        // Viewの移動する.
        self.present(myViewController, animated: true, completion: nil)
    }
    // ボタンイベント.
    func onClickMyButton(sender: UIButton){
        
        // ビデオ出力に接続.
        // let myVideoConnection = myImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        let myVideoConnection = myImageOutput.connection(withMediaType: AVMediaTypeVideo)
        
        // 接続から画像を取得.
        self.myImageOutput.captureStillImageAsynchronously(from: myVideoConnection, completionHandler: {(imageDataBuffer, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            // 取得したImageのDataBufferをJpegに変換.
            let myImageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: imageDataBuffer!, previewPhotoSampleBuffer: nil)
            // JpegからUIIMageを作成.
            let myImage = UIImage(data: myImageData!)
            // アルバムに追加.
            UIImageWriteToSavedPhotosAlbum(myImage!, nil, nil, nil)
        })
    }
    //ボタンがタップされた時に呼ばれるメソッド.
    func onClickMyButton3(sender: UIButton) {
        
        //playingプロパティがtrueであれば音源再生中.
        if myAudioPlayer.isPlaying == true {
            
            //myAudioPlayerを一時停止.
            myAudioPlayer.pause()
            //sender.setTitle("", for: .normal)
        } else {
            
            //myAudioPlayerの再生.
            myAudioPlayer.play()
            //sender.setTitle("", for: .normal)
        }
        let animationImageView = starImageView
        self.view.addSubview(animationImageView)
        animationImageView.falling()

        
    }
    // MARK: - AVAudioPlayerDelegate
    
    //音楽再生が成功した時に呼ばれるメソッド.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if !flag { return }
        
        print("Music Finish")
        //再度myButtonを"▶︎"に設定.
        //musicButton.setTitle("", for: .normal)
    }
    
    
    //デコード中にエラーが起きた時に呼ばれるメソッド.
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print("Error")
            print(e.localizedDescription)
            return
        }
    }
   
    
}

// くるくるアニメーションするUIImageView
class FallingImageView: UIImageView {
    private var fallingDuration: TimeInterval = 2.5
    private let animationKey = "fallingAnimation"
    
    func falling(delayDouble: Double = 0.1) {
        // 回転
        let rotateAnimation = CABasicAnimation(keyPath: "transform")
        rotateAnimation.duration = 0.3
        rotateAnimation.repeatCount = Float.infinity
        let transform = CATransform3DMakeRotation(CGFloat(M_PI),  0, 1.0, 0)
        rotateAnimation.toValue = NSValue(caTransform3D : transform)
        // 移動
        let endPoint = CGPoint(x:self.layer.position.x, y:UIScreen.main.bounds.height)
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.duration = fallingDuration
        moveAnimation.fromValue = NSValue(cgPoint: self.layer.position)
        moveAnimation.toValue = NSValue(cgPoint: endPoint)
        // zPosition(最前面に表示し続けるための処理)
        let zAnimation = CABasicAnimation(keyPath: "transform.translation.z")
        zAnimation.fromValue = self.layer.bounds.size.width
        zAnimation.repeatCount = Float.infinity
        zAnimation.toValue = zAnimation.fromValue
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = fallingDuration
        animationGroup.repeatCount = 1
        animationGroup.animations = [moveAnimation, rotateAnimation, zAnimation]
        
        self.layer.add(animationGroup, forKey: self.animationKey)
    }
    
    func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.removeFromSuperview()
        }
    }
}

