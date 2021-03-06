//
//  WZEnsemble.swift
//  WZAuditory
//
//  Created by admin on 6/12/17.
//  Copyright © 2017年 wizet. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

///多重奏 用于播放本地的音频对象
class WZEnsemble {
    ///音频列表
    lazy var audioMenu : Dictionary<URL , AVAudioPlayer> = {return Dictionary<URL , AVAudioPlayer>() }();
    let normalVolumn = 0.5
    /// 添加音频
    /// - Parameter url: 本地音频地址
    func appendAudioWithURL(url : URL) -> Void {
        //本地的音频
        if  FileManager.default.fileExists(atPath: url.path) {
            
            if self.audioMenu[url] != nil {
                print("已添加")
            } else {
                let audio : AVAudioPlayer = try! AVAudioPlayer(contentsOf: url)
                audio.volume = Float(self.normalVolumn);//默认值
                audio.prepareToPlay()
                audio.play()
                audio.numberOfLoops = -1
                self.audioMenu[url] = audio;
            }
        } else {
            assert(false, "添加失败,资源缺失~~~")
            print("添加失败,资源缺失~~~");
        }
    }
    
    /// 移除音频
    /// - Parameter url: 本地音频地址
    func removeAudioWithURL(url : URL) -> Void {
        if  FileManager.default.fileExists(atPath: url.path) {
            if self.audioMenu[url] != nil {
                self.audioMenu[url]?.pause()
                self.audioMenu.removeValue(forKey: url);
            }
        }
    }
    
    
    func pause() {
        for player in audioMenu.values {
            player.pause()
        }
    }
    
    func play() {
        for player in audioMenu.values {
            if !player.isPlaying {
                player.play()
            }
        }
    }
    
    func clear() {
        for player in audioMenu.values {
            player.stop()
            player.delegate = nil
        }
        audioMenu.removeAll()
    }
    
    //声道 pan [-1, 1] [极左, 极右]
    //音量 volume
    //播放率 0.8~2.0
    //numberOfLoops  -1实现无缝循环
    
    ///检查播放状态
    func isPlaying() -> Bool {
        if self.audioMenu.count > 0 {
           return (self.audioMenu.values.first)!.isPlaying
        } else {
            return false
        }
    }
    
    ///获取系统级别的声音控件
    static func getSystemVolumeView() -> MPVolumeView {
//        let mpView : MPVolumeView = MPVolumeView(frame: CGRect.zero)
//        mpView.clipsToBounds = true
//        mpView.showsRouteButton = false
//        mpView.alpha = 0.0
//        mpView.layer.opacity = 0.0
//        mpView.isUserInteractionEnabled = false
//        mpView.sizeToFit()
//        //难过~香菇
//        mpView.showsVolumeSlider = true ///设置为true 才会能调节声音成功
////        mpView.isHidden = true
        
        let mpView : MPVolumeView = MPVolumeView(frame: CGRect(x: -1000, y: -1000, width: 40, height: 40))
        mpView.isHidden = false
     
        return mpView
    }
    
    
    
    ///调节系统级别的声音 [0, 1]
    static func slideSystemVolumne(volumneView: MPVolumeView,  volumne : Float) {
        var slider : UISlider?
        for view in volumneView.subviews {
            if ((view.classForCoder as? UISlider.Type) != nil) {
                slider = view as? UISlider
                break
            }
        }
        slider?.setValue(volumne, animated: true)
    }
    
    
    static func slideSystemVolumneSlider(volumneView: MPVolumeView) -> UISlider? {
        var slider : UISlider?
        for view in volumneView.subviews {
            if ((view.classForCoder as? UISlider.Type) != nil) {
                slider = view as? UISlider
                break
            }
        }
        return  slider
    }
    
    //获取当前系统级别的音量
    static func getSystemVolume() -> Float {
        let mpView : MPVolumeView = MPVolumeView()
        var slider : UISlider?
        for view in mpView.subviews {
            if ((view.classForCoder as? UISlider.Type) != nil) {
                slider = view as? UISlider
                return slider?.value ?? 0
            }
        }
        return 0
    }
}
