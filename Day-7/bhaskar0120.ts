import * as fs from 'fs';

fs.readFile('./inp.txt', 'ascii', (Error, Data:string):void =>{
  if(Error){
    console.log(Error);
  }
  main(Data.split('\r\n'))
});

type childList =  {[key:string]: Node};

class Node{
  name:string;
  file:boolean;
  size:number;
  parent: Node;
  children: childList = {}

  constructor(name:string , file:boolean, size:number=0){
    this.name = name;
    this.file = file;
    this.size = size;
  }
  addChild(child:Node): void{
    if(this.file)
      console.log(`Can't add ${child.name} to a file ${this.name}`);
    else{
      this.children[child.name] = child
      child.parent = this;
    }
  }
  getSize(): number{
    if(this.file)
      return this.size;
    else{
      let sum = 0;
      for(let i in this.children)
        sum += this.children[i].getSize();
      return sum;
    }
  }
}

function Easy(root: Node):number{
  let sum = 0;
  for(let i in root.children){
    let child = root.children[i];
    if(!child.file){
      let t = child.getSize();
      sum += (100000>=t)?t:0
      sum += Easy(child);
    }
  }
  return sum;
}

let all_directory_size: number[] = [];
function Hard(root :Node): void{
  for(let i in root.children){
    let child = root.children[i];
    if(!child.file){
      all_directory_size.push(child.getSize())
      Hard(child);
    }
  }
}


function main(lines: string[]): void {

  let pointer:number = 0;
  let numOfLines:number = lines.length;

  let FS : Node = new Node("FS", false);
  let cur : Node = FS;
  cur.addChild(new Node('/',false));


  while(pointer < numOfLines){
    if(lines[pointer] == undefined) break;

    let instChunk: string[]  = lines[pointer].split(' ');       // Always an instruction
    if (instChunk[0] != '$')  console.log(`${lines[pointer]} is not an instruction`)

    if(instChunk[1] == 'ls'){
      pointer++;
      let output: string = lines[pointer];

      // go through all the outputs
      while((!output.startsWith("$")) && pointer < numOfLines){

        let outChunk: string[] = output.split(' ');

        // if not already in children
        if(!(outChunk[1] in cur.children)){
          if(outChunk[0] == "dir"){
            cur.addChild(new Node(outChunk[1], false));
          }
          else{
              cur.addChild(new Node(outChunk[1], true , parseInt(outChunk[0]) ));
          }
        }
        pointer++;
        output = lines[pointer];
        if(output == undefined) break;
      }
    }

    else if(instChunk[1] == 'cd'){
      if(instChunk[2] == '..'){
        cur = cur.parent;
      }
      else if(instChunk[2] in cur.children){
        cur = cur.children[instChunk[2]]
      }
      else{
        console.log(`Cd into non existing file ${instChunk[2]}`);
      }
      pointer++;
    }
    else{
      console.log("Not reachable")
    }
  }

  //Change to root
  
  FS = FS.children['/'];
  console.log("Easy:",Easy(FS));

  const totalSize = FS.getSize();
  const sizeToBeFreed = 30000000 - (70000000 - totalSize);

  Hard(FS);
  all_directory_size.sort( (a,b)=>a-b );

  for(let i in all_directory_size){
    let n = all_directory_size[i];
    if(n > sizeToBeFreed){
      console.log("Hard:", n)
      break;
    }
  }
}
