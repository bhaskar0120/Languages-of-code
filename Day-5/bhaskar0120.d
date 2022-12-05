const LIM = 100;
const STACKS = 10;

struct Stack{
	char[LIM] c;
	size_t top = 0;
	void push(char x){
    if(top >= LIM){
      throw new Exception ("Overflow");
    }
    c[top++] =x;
	}
   char pop(){
    if(top == 0){
      throw new Exception ("Underflow");
    }
    return c[--top];
   }
   char front(){
    if(top == 0){
      throw new Exception ("Underflow");
    }
    return c[top-1];
   }
   void rev(){
     for(int i = 0; i < top/2; ++i){
       auto tmp = c[i];
       c[i] = c[top-1-i];
       c[top-1-i] = tmp;
     }
   }
   char[] popn(size_t n){
      if(n > top){
        throw new Exception ("Underflow");
      }
      char[] ret = new char[n];
      for(size_t i = top - n; i < top; ++i){
        ret[i-top+n] = c[i];
      }
      top-=n;
      return ret;
   }
   void pushn(size_t n, char[] x){
     if(top+n > LIM)
      throw new Exception ("Overflow");
     for(int i = 0; i < n; ++i)
       c[top++] = x[i];
   }
}

void main(){
	import std.stdio: writeln, write;
	import std.file : readText, FileException;
  import std.regex: ctRegex, matchFirst;

  auto R = ctRegex!(`move (\d+) from (\d+) to (\d+)`);
	try{
		string x = readText("./inp.txt");
		import std.string : splitLines;
    Stack[STACKS] stacks, stacks_hard;

    size_t line = 0;
    auto lines = x.splitLines();
		foreach(i,E; lines){
      line = i;
      if(E=="") break;
			int spaceCount = 0;
			int colCount = 0;
      foreach(ch;E){
        if(ch == ' ')
          spaceCount++;
        else if('A' <= ch && ch <= 'Z'){
          spaceCount = 0;
          stacks[colCount].push(ch);
          colCount++;
        }
        if(spaceCount == 4){
          spaceCount = 0;
          colCount++;
        }
      }
		}

    foreach(j,ref i;stacks){
      i.rev();
      stacks_hard[j] = i;
    }

    for(size_t t = line+1; t < lines.length; ++t){
      import std.conv : to;
      auto nums = matchFirst(lines[t],R); 
      if(nums.length > 0){
        int a = to!int(nums[1]);
        int b = to!int(nums[2]);
        int c = to!int(nums[3]);
        
        stacks_hard[c-1].pushn(a,stacks_hard[b-1].popn(a));
        foreach(j;0..a){
          stacks[c-1].push(stacks[b-1].pop());
        }
      }
    }

    write("Easy: ");
    foreach(i;stacks){
      if(i.top > 0)
        write(i.front());
    }
    write("\nHard: ");
    foreach(i;stacks_hard){
      if(i.top > 0)
        write(i.front());
    }
	}
	catch(FileException E){
		writeln("File not found");
	}
  catch(Exception E){
    writeln(E);
  }
  writeln();
}
