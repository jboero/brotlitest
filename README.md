# Brotli Test
This repo contains some basic scripts to test any file comparing Gzip and Brotli across time and compression strength.  Output is dumped to an HTML result and plotted with Google Charts.

## Usage
```
$ git clone 
$ ./test.sh [test file]
```

For best results clone into /tmp or tmpfs to guarantee eliminating I/O time.
Beware that each run will delete the results from a previous run in pwd, so best to work in a new directory with copies of files.

## Viewing results
A local file will be generated called $INPUTFILE.results.html.  This may be viewed with a browser.  There is a line commented out in the script that automatically views the results file with xdg-open, but this is commented to eliminate browser CPU steal.  For best results view manually after runs.

```
$ xdg-open *results.html
```


## Example
![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")
