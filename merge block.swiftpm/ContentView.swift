import SwiftUI

struct ContentView: View {
    @State private var point:Int=0
    @State private var board: [[Int]]=Array(repeating:Array(repeating: 0, count: 7), count: 7)
    @State private var nextNum:Int=1
    @State private var maxNum:Int=0
    @State private var game_end:Int=0
    @State private var show:Bool=false
    @State private var high_score:Int=0
    func get_color(num:Int)->Color{
        var n:Double=Double(min(num,10))
        return Color(.sRGB,red: n*0.05+0.5,green: 0,blue: 1-n*0.1)
    }
    func generate_next(){
        maxNum=min(maxNum, 3)
        nextNum=Int.random(in: 1...maxNum)
    }
    func lose()->Bool {
        var cnt:Int=0
        for i in(1..<6){
            for j in(1..<6){
                if board[i][j] == 0{
                    cnt += 1
                }
            }
        }
        if cnt == 0{
            return true
        }
        return false
    }
    func merge(x:Int,y:Int){
        var cnt:Int=0
        var a=0,b=0,c=0,d=0
        if board[x-1][y] == board[x][y] {
            cnt += 1
            a=1
        }
        if board[x+1][y] == board[x][y] {
            cnt += 1
            b=1
        }
        if board[x][y-1] == board[x][y] {
            cnt += 1
            c=1
        }
        if board[x][y+1] == board[x][y] {
            cnt += 1
            d=1
        }
        if cnt >= 1 {
            point += 1
            if a != 0 {
                board[x-1][y]=0
            }
            if b != 0 {
                board[x+1][y]=0
            }
            if c != 0 {
                board[x][y-1]=0
            }
            if d != 0 {
                board[x][y+1]=0
            }
            board[x][y] += 1
            var n = board[x][y]
            if n == board[x+1][y] || n == board[x-1][y] || 
                n == board[x][y+1] || n == board[x][y-1] {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false){
                    t in
                    merge(x: x, y: y)
                    t.invalidate()
                }
            }
        }
        maxNum=max(maxNum,board[x][y])
        if lose() == true{
            high_score=max(high_score,point)
            show=true
        }
    }
    var body: some View {
        Text("Score:\(point)").font(.system(.largeTitle)).alert("You lose", isPresented: $show, actions: {
            Button("Restart"){
                point=0
                for i in(1..<6){
                    for j in(1..<6){
                        board[i][j]=0
                    }
                }
                maxNum=1
                nextNum=1
                show=false
            }
        },message: {
            Text("Score:\(point)\nHigh Score:\(high_score)")
        })
        VStack {
            ForEach(1..<6){
                i in
                HStack{
                    ForEach(1..<6){
                        j in
                        if board[i][j] == 0{
                            Rectangle().fill(Color.gray).frame(width: 50, height: 50).onTapGesture {
                                if board[i][j] == 0  {
                                    board[i][j] = nextNum
                                    maxNum=max(maxNum, board[i][j])
                                    generate_next()
                                    merge(x:i,y:j)
                                }
                            }
                        }
                        else{
                            Rectangle().fill(get_color(num: Int(board[i][j]))).frame(width: 50, height: 50).overlay(Text("\(String(board[i][j]))"))
                        }
                    }
                }
            }
        }
        HStack{
            Text("Next:").font(.system(.largeTitle))
            Rectangle().fill(get_color(num: nextNum)).frame(width: 50, height: 50).overlay(Text("\(String(nextNum))"))
        }
    }
}
