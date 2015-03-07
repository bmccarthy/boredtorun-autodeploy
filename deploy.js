var githubhook = require('githubhook');
var _ = require('underscore');
var exec = require('child_process').exec;
var deployScript = __dirname + '/deploy.sh ';
var deployCodeThreshold = 60*1000; // triggers every minute
var github = githubhook({port: 9001});

github.listen();

console.log('listening on port 9001');
console.log('deploy.sh: ' +  deployScript);

function deployCode() {
    console.log('executing ' + deployScript);

    var child = exec(deployScript, // command line argument directly in string
      function (error, stdout, stderr) { // one easy function to capture data/errors
        console.log('stdout: ' + stdout);
        console.log('stderr: ' + stderr);
        if (error !== null) {
          console.log('exec error: ' + error);
        }
    });
}

var debouncedDeploy = _.debounce(deployCode, deployCodeThreshold);

github.on('push:boredtorun:refs/heads/master', function (payload) {
    console.log('message recieved from github');
    console.log(payload);

    debouncedDeploy();
});
