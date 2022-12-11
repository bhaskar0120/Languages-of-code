import 'dart:io';

int max(int a, int b) { if(a>=b) return a; return b; }
int abs(int x){ if(x >= 0) return x; return -x; }

int dist(int x1 , int y1 , int x2 , int y2){
  return max(abs(x1-x2),abs(y1-y2));
}

var map = new Map();
var count = 0;

List<int> move(var head, var tail, var track){
  var d = dist(tail[0],tail[1], head[0],head[1]);
  assert(d <= 2);
  if(d > 1){
    if(tail[0] == head[0] || tail[1] == head[1]){
      tail[0] = ((tail[0]+head[0])/2).toInt();
      tail[1] = ((tail[1]+head[1])/2).toInt();
    }
    else{
      bool moved = false;
      var oneMove = [];
      outer:for(int i in [-1,0,1]){
        for(int j in [-1,0,1]){
          if(i == 0 && j == 0) continue;
            var x = dist(tail[0]+i,tail[1]+j,head[0],head[1]);
            if(x == 1){
              oneMove.add([i,j]);
              if((tail[0]+i == head[0] || tail[1]+j == head[1])){
                tail[0] += i;
                tail[1] += j;
                moved = true;
                break outer;
              }
            }
          }
        }
        if(!moved){
          tail[0] += oneMove[0][0];
          tail[1] += oneMove[0][1];
        }
    }
    if(track){
      if(!map.containsKey(tail[0])){
        count++;
        map[tail[0]] = new Map();
        map[tail[0]][tail[1]] = true;
      }
      else if(!map[tail[0]].containsKey(tail[1])){
        count++;
        map[tail[0]][tail[1]] = true;
      }
    }
  }
  return tail;
}

Future<int> solve(var n) async{
  map = new Map();
  map[0] = new Map();
  map[0][0] = true;
  count = 1;

  var points = [];
  for(int i = 0; i < n; ++i)
    points.add([0,0]);
  await File('inp.txt').readAsString().then((String data){
      for(String inst in data.split('\n')){
        var token = inst.split(' ');
        var mx = 0, my = 0;
        switch(token[0]){
          case 'R': mx = 1; break;
          case 'U': my = 1; break;
          case 'L': mx = -1; break;
          case 'D': my = -1; break;
        }
        for(int i = 0; i < int.parse(token[1]); ++i){
          points[0][0]+=mx;
          points[0][1]+=my;
          for(int i = 1; i < n;++i ){
            points[i] = move(points[i-1],points[i], i == (n-1));
          }
        }
      }
  });
  return count;
}
void main() async{
  print("Easy: ${await solve(2)}");
  print("Hard: ${await solve(10)}");
}
