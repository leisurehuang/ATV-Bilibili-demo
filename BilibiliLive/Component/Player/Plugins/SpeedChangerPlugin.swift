//
//  SpeedChangerPlugin.swift
//  BilibiliLive
//
//  Created by yicheng on 2024/5/25.
//

import AVKit

class SpeedChangerPlugin: NSObject, CommonPlayerPlugin {
    private weak var player: AVPlayer?
    private weak var playerVC: AVPlayerViewController?

    @Published private(set) var currentPlaySpeed: PlaySpeed = .default

    func playerDidLoad(playerVC: AVPlayerViewController) {
        self.playerVC = playerVC
    }

    func playerDidChange(player: AVPlayer) {
        self.player = player
    }

    func playerWillStart(player: AVPlayer) {
        playerVC?.selectSpeed(AVPlaybackSpeed(rate: currentPlaySpeed.value, localizedName: currentPlaySpeed.name))
    }

    func addMenuItems(current: inout [UIMenuElement]) -> [UIMenuElement] {
        let gearImage = UIImage(systemName: "gearshape")

        let speedActions = PlaySpeed.blDefaults.map { playSpeed in
            UIAction(title: playSpeed.name, state: currentPlaySpeed == playSpeed ? .on : .off) {
                [weak self] _ in
                guard let self else { return }
                player?.currentItem?.audioTimePitchAlgorithm = .timeDomain
                playerVC?.selectSpeed(AVPlaybackSpeed(rate: playSpeed.value, localizedName: playSpeed.name))
                currentPlaySpeed = playSpeed
            }
        }
        let playSpeedMenu = UIMenu(title: "播放速度", options: [.displayInline, .singleSelection], children: speedActions)
        let menu = UIMenu(title: "播放设置", image: gearImage, identifier: UIMenu.Identifier(rawValue: "setting"), children: [playSpeedMenu])
        return [menu]
    }
}

struct PlaySpeed {
    var name: String
    var value: Float
}

extension PlaySpeed: Equatable {
    static let `default` = PlaySpeed(name: "1X", value: 1)

    static let blDefaults = [
        PlaySpeed(name: "0.5X", value: 0.5),
        PlaySpeed(name: "0.75X", value: 0.75),
        PlaySpeed(name: "1X", value: 1),
        PlaySpeed(name: "1.25X", value: 1.25),
        PlaySpeed(name: "1.5X", value: 1.5),
        PlaySpeed(name: "2X", value: 2),
    ]
}
