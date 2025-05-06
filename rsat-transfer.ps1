$user = $args[0]
$root = $args[1]
$_ = rmdir .tmp -Force -Recurse -ErrorAction SilentlyContinue
$_ = mkdir .tmp -ErrorAction SilentlyContinue
$_ = tar -czf .tmp\context.tar.gz --exclude=.git --exclude=.tmp --format=ustar .
$dir = ssh $user "mkdir -p `"$root`" && cd `"$root`" && echo `$PWD"
scp -qr .tmp "$user`:$root"
ssh $user "cd `"$root`" && tar -xzf .tmp/context.tar.gz && rm -rf .tmp"

if (Get-Command code -ErrorAction SilentlyContinue) {
    code --install-extension ms-vscode-remote.remote-ssh --force
    code --folder-uri "vscode-remote://ssh-remote+$user$dir"
}
else {
    ssh -tt $user "cd `"$root`" && bash"
}
