//
//  Lyric.swift
//  JamAlpha2
//
//  Created by Xing Liu on 7/6/15.
//  Copyright (c) 2015 Song Liao. All rights reserved.
//

import Foundation

class Lyrics: NSObject{
    var lyrics: [String] = [String]()
    var times: [TimeNumber] = [TimeNumber]()
    
    override init(){
        lyrics = [String]()
        times = [TimeNumber]()
    }
    
    func addLine(time: TimeNumber, str: String){
        lyrics.append(str)
        times.append(time)
    }
    
    func get(i: Int) -> (time: TimeNumber, lyric: String){
        return (time: times[i], lyric: lyrics[i])
    }
    
    
    class func getRainbowLyrics ()-> Lyrics {
        var lyric = Lyrics()
        
        lyric.addLine(TimeNumber(time:12.56), str: "哪里有彩虹告诉我")
        lyric.addLine(TimeNumber(time:18.80), str: "能不能把我的愿望还给我")
        lyric.addLine(TimeNumber(time:25.82), str: "为什么天这么安静")
        lyric.addLine(TimeNumber(time:31.98), str: "所有的云都跑到我这里")
        lyric.addLine(TimeNumber(time:38.91), str: "有没有口罩一个给我")
        lyric.addLine(TimeNumber(time:44.79), str: "释怀说了太多就成真不了")
        lyric.addLine(TimeNumber(time:51.90), str: "也许时间是一种解药")
        lyric.addLine(TimeNumber(time:57.82), str: "也是我现在正服下的毒药")
        lyric.addLine(TimeNumber(time:63.91), str: "看不见妳的笑 我怎么睡得着")
        lyric.addLine(TimeNumber(time:70.44), str: "妳的声音这么近我却抱不到")
        lyric.addLine(TimeNumber(time:76.78), str: "没有地球 太阳还是会绕")
        lyric.addLine(TimeNumber(time:83.18), str: "没有理由 我也能自己走")
        lyric.addLine(TimeNumber(time:89.99), str: "妳要离开 我知道很简单")
        lyric.addLine(TimeNumber(time:96.2), str: "妳说依赖 是我们的阻碍")
        lyric.addLine(TimeNumber(time:102.74), str: "就算放开 但能不能别没收我的爱")
        lyric.addLine(TimeNumber(time:110.27), str: "当作我最后才明白")
        return lyric
    }
}