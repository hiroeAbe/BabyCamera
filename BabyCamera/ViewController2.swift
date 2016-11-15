

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //再生する音源のURLを生成.
        let soundFilePath : String = Bundle.main.path(forResource: "Sample2", ofType: "mp3")!
        let fileURL = URL(fileURLWithPath: soundFilePath)
        
        //AVAudioPlayerのインスタンス化.
        myAudioPlayer = try! AVAudioPlayer(contentsOf: fileURL)
        
        //AVAudioPlayerのデリゲートをセット.
        myAudioPlayer.delegate = self
        
        //ボタンの生成.
        musicButton = UIButton()
        musicButton.frame.size = CGSize(width: 70, height: 70)
        musicButton.layer.position = CGPoint(x: self.view.frame.width/2-100, y: self.view.bounds.height-50)
        musicButton.setTitle("▶︎", for: UIControlState.normal)
        musicButton.setTitleColor(UIColor.black, for: .normal)
        musicButton.backgroundColor = UIColor.cyan
        musicButton.addTarget(self, action: #selector(onClickMyButton3), for: UIControlEvents.touchUpInside)
        musicButton.layer.masksToBounds = true
        musicButton.layer.cornerRadius = 50.0
        
        // セッションの作成.
        mySession = AVCaptureSession()
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // バックカメラをmyDeviceに格納.
        for device in devices! {
            if((device as AnyObject).position == AVCaptureDevicePosition.back){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        // バックカメラからVideoInputを取得.
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
        let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
        myButton.backgroundColor = UIColor.red
        myButton.layer.masksToBounds = true
        myButton.setTitle("撮影", for: .normal)
        myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        myButton.addTarget(self, action: #selector(onClickMyButton), for: .touchUpInside)
        
        let myButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
        myButton2.backgroundColor = UIColor.blue
        myButton2.layer.masksToBounds = true
        myButton2.setTitle("戻る", for: .normal)
        myButton2.layer.cornerRadius = 20.0
        myButton2.layer.position = CGPoint(x: self.view.bounds.width/2+100, y:self.view.bounds.height-50)
        myButton2.addTarget(self, action: #selector(onClickMyButton2), for: .touchUpInside)
        
        
        // UIボタンをViewに追加.
        self.view.addSubview(myButton);
        self.view.addSubview(myButton2);
        self.view.addSubview(musicButton);
        
        
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
            sender.setTitle("▶︎", for: .normal)
        } else {
            
            //myAudioPlayerの再生.
            myAudioPlayer.play()
            sender.setTitle("■", for: .normal)
        }
    }
    // MARK: - AVAudioPlayerDelegate
    
    //音楽再生が成功した時に呼ばれるメソッド.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if !flag { return }
        
        print("Music Finish")
        //再度myButtonを"▶︎"に設定.
        musicButton.setTitle("▶︎", for: .normal)
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
