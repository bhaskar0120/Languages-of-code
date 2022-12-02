# Counting Calories

sub max{
  ($a, $b) = @_;
  if ($a >= $b){
    return $a;
  }
  else{
    return $b;
  }
}

$ans1 = 0;

open($f,"inp.txt") or die "File not found";
  until(eof $f){
    $line = readline $f or die "Couldn't readline";
    if($line == "\n"){
      $ans1 = max $ans1, $sum;
      $sum = 0;
    }
    else{
      chomp $line;
      $sum += $line;
    }
  }
close $f or warn "Unable to close file";

$ans1 = max $ans1, $sum;
print "Easy: $ans1\n";

@maximum_array = ();
$sum = 0;

open($f,"inp.txt") or die "File not found";
  until(eof $f){
    $line = readline $f or die "Couldn't readline";
    if($line == "\n"){
      push @maximum_array, $sum;
      $sum = 0;
    }
    else{
      chomp $line;
      $sum += $line;
    }
  }
close $f or warn "Unable to close file";

push @maximum_array, $sum;

@sorted_array = reverse sort {$a <=> $b} @maximum_array;

$ans2 = @sorted_array[0] + @sorted_array[1] + @sorted_array[2];
print "Hard: $ans2\n";
