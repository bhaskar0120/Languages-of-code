defmodule Util do
	def toInteger(a) do
		case a do
			[x] -> [elem(Integer.parse(x), 0)]
			[x | tail] -> [elem(Integer.parse(x), 0) | toInteger(tail)]
		end
	end
		
	def checkFullyContained(list) do
		reg = ~r/(\d+)-(\d+),(\d+)-(\d+)/
		case toInteger(tl Regex.run(reg,list)) do
			[a,_b,c,_d]  when a == c -> 1
			[_a,b,_c,d]  when b == d -> 1
			[a,b,c,d]  when a < c -> if b > d do 1 else 0 end
			[a,b,c,d]  when c < a -> if d > b do 1 else 0 end
		end
	end

	def anyOverlap(list) do
		reg = ~r/(\d+)-(\d+),(\d+)-(\d+)/
		case toInteger(tl Regex.run(reg,list)) do
			[a,_b,c,d] when a >= c and a <= d  -> 1
			[_a,b,c,d] when b >= c and b <= d  -> 1
			[a,b,c,d] when c >= a and d <= b  -> 1
			_ -> 0
		end
		
	end

	def countPartiallyContained(list) do
		case list do
			[x] ->  anyOverlap(x)
			[x | tail] -> anyOverlap(x) + countPartiallyContained(tail)
		end
	end

	def countFullyContained(list) do
		case list do
			[x] ->  checkFullyContained(x)
			[x | tail] -> checkFullyContained(x) + countFullyContained(tail)
		end
	end
end

case File.read "inp.txt" do
	{:ok, data} -> #IO.puts(length String.split(data,"\n",trim: true))
		IO.puts "Easy: #{Util.countFullyContained(String.split(data, "\n",trim: true))}";
		IO.puts "Hard: #{Util.countPartiallyContained(String.split(data, "\n",trim: true))}";
		

	{:error, _} -> IO.puts "Error"
end
