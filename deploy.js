var githubhook = require('githubhook');
var _ = require('underscore');
var util = require('util');
var exec = require('child_process').exec;
var execFile = require('child_process').execFile;

var deployCodeThreshold = 60*1000; // triggers every minute
var github = githubhook({port: 9001});

github.listen();

console.log('listening on port 9001');

function deployCode(){
    var id = 'btr-' + (new Date().getTime().toString());
    console.log('new id: ' + id);

    var command = '/home/bmccarthy/boredtorun-release/deploy.sh ' + id;

    var child = exec(command, // command line argument directly in string
      function (error, stdout, stderr) { // one easy function to capture data/errors
        console.log('stdout: ' + stdout);
        console.log('stderr: ' + stderr);
        if (error !== null) {
          console.log('exec error: ' + error);
        }
    });
}

github.on('*:boredtorun:ref/heads/master', function (event, repo, ref, data) {
    console.log('message recieved for repo: ' + repo);
    _.debounce(changeMeter, deployCodeThreshold)
});
