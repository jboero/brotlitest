#!/bin/bash
# John Boero

# Gives microseconds for a task.
function microsecs()
{
	ts=$(date +%s%N)
	$@
	tt=$((($(date +%s%N) - $ts)/1000))
	echo $tt
}

if [[ ! -f $1 ]]
then
	echo "Need to pass file arg."
	exit 1
fi

rm -f *.br *.gz

for level in {1..9}
do
	brtime=$(microsecs brotli -$level -f -o "$1.$level.br" "$1")
	brsize="$(stat -c '%s' ""$1.$level.br"")"
	echo "brotli	-$level: ${brtime}ms, ${brsize}b"

	gztime=$(microsecs gzip -$level -f -k "$1")
	gzsize="$(stat -c '%s' ""$1.gz"")"
	echo "gzip	-$level: ${gztime}ms, ${gzsize}b"
	rm -f "$1.gz"

	dataset="$dataset [$level, $gzsize, $brsize, $gztime, $brtime], "
done

#rm -f *.br *.gz

cp template.head.html "$1.results.html"
echo "${dataset:-2}" >> "$1.results.html"
cat template.tail.html >> "$1.results.html"

echo "Original file size: $(stat -c '%s' ""$1"")" >> "$1.results.html"

#xdg-open "$1.results.html" &
