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

origsize=$(stat -c '%s' "$1")

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

cat << EOF > "$1.results.html"
<html>
<title>Brotli performance chart for $1 original size $origsize bytes.</title>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">

google.charts.load('current', {packages: ['corechart', 'line']});
google.charts.setOnLoadCallback(drawAxisTickColors);

function drawAxisTickColors() {
      var data = new google.visualization.DataTable();
      data.addColumn('number', 'X');
      data.addColumn('number', 'GZIP Size (bytes)');
      data.addColumn('number', 'Brotli Size (bytes)');
      data.addColumn('number', 'GZIP Time (microsec)');
      data.addColumn('number', 'Brotli Time (microsec)');

      data.addRows([
$dataset
      ]);

      var options = {
                'title':'Brotli vs Gzip time and size', 
                'width':1440,
                'height':1024,
        hAxis: {
          title: 'Compression Level',
          textStyle: {
            color: '#01579b',
            fontSize: 20,
            fontName: 'Arial',
            bold: true,
            italic: true
          },
          titleTextStyle: {
            color: '#01579b',
            fontSize: 16,
            fontName: 'Arial',
            bold: false,
            italic: true
          }
        },
        vAxis: {
          title: 'Time/Size',
          textStyle: {
            color: '#1a237e',
            fontSize: 24,
            bold: true
          },
          titleTextStyle: {
            color: '#1a237e',
            fontSize: 24,
            bold: true
          }
        },
        colors: ['#FF0000', '#00FF00', '#FF00FF', '#0000FF']
      };
      var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
      chart.draw(data, options);
    }
</script>
<body><h1>Brotli performance chart for $1 original size $origsize bytes.</h1>
<div id="chart_div"></div>
</body>
</html>
EOF
